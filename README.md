# opt-script
本脚本是hiboy旧脚本的改进稳定版，在“自定义 opt-script 下载地址”改为：https://bitcion.github.io/opt-script/

新版脚本因为改变了以前的工作方式，脚本之间的依赖性更强，容易出现功能设置与预设脚本不同就会出现运行故障。而这个脚本则是以前脚本的备份改进，可以与最新的OPT环境并存

相对于原本脚本主要改动之处是强制把clash dns的监听端口改了“8054”，虽然启动日志依旧显示8053

改进目的是是与ChinaDNS-NG的8053监听端口不同，实现ipv4透明代理与ipv6共存。原理如下：

因为透明代理，导致指向clash dns的所有查询只有IPV4结果，即使开启ipv6，因为没有dns6的查询，在非大陆大名单中的访问无法使用ipv6，只有Ipv4，即只能进行透明代理访问。而实际很多被墙资源是可以通过ipv6也能直接访问（cloudflare托管网站居多），即使ipv6地址被墙，因为双栈道工作原理，系统机制会自动回落ipv4访问，进而使用透明代理继续访问，ipv6的相当于是一个直连规则的存在（能直连直连，不能直连则代理）
如果要实现这个需求，必须开启smartdns来实现所有请求都会获取到ipv6查询结果。但是开启smartdns的问题是clash所有的代理都会变成纯IP访问，无法进行代理规则的分流。
为了解决这个问题，有两个方案：
1、使用meta内核，开启sniffer还原。
2、把CLASH DNS监听端口强制改了8054，然后把“server 192.168.123.1:8054 -group office”加入smartdns配置中。这样所有DNS请求会通过并行查询office 组，对于公共DNS能顺利获取ipv6查询，对于发送到“server 192.168.123.1:8054 -group office”的查询则可以让clash还原出域名然后进行规则分流


ipv6使用提示：
对于很多需要必须进行代理（比如Netflix）以及很多网站无法自动跳回ipv4透明代理的资源，则需要在smartdns指定他们域名屏蔽掉ipv6查询，具体使用方法参照smartdns配置


# 高阶方案，256内存以上的机型，128内存不要尝试
开启一次“AdGuardHome 开关”，等待AdGuardHome启动后，关闭AdGuardHome，无需配置。在“ss_tproxy启动前运行脚本”中添加“    /opt/AdGuardHome/AdGuardHome”，然后再进入192.168.123.1：3000,配置AdGuardHome。完成配置后在smartdns的配置中加入：

“server 0.0.0.0:5353 -group office
server 192.168.123.1:8054 -group office”

OFFICE组只保留clash dns与AdGuardHome本地DNS。

如果追求极致DNS访问，可以把clash dns中的  nameserver与  fallback，都改为“    - 127.0.0.1:5353”，只查询AdGuardHome DNS。

这样做的好处是可以在AdGuardHome中更好的控制ipv6请求屏蔽，可以订阅我自用的AdGuard规则（必须屏蔽的ipv6）：https://bitcion.github.io/zaixiantuoguan/AdGuard%E8%A7%84%E5%88%99.txt 。更多需求可以参考里面的规则写法
