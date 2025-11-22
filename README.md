# opt-script
本脚本是hiboy旧脚本的改进IPv6优化，若无IPV6环境不推荐使用，在“自定义 opt-script 下载地址”改为：https://bitcion.github.io/opt-script/     最好搭配旧OPT环境：https://bitcion.github.io/opt-file 默认的https://opt.cn2qq.com/opt-file 也可兼容.

建议搭配	3.4.3.9-099_24-02-1以及更旧固件版本使用，若使用新固件，chinadns-ng 设置会有些问题，不过默认参数开启也能用，就是修改参数需要尝试

相对于原本脚本主要改动之处是强制把clash dns的监听端口改了“8054”

改进目的是是与ChinaDNS-NG的8053监听端口不同，实现ipv4透明代理与ipv6共存。设置建议：

1、开启clash dns的ipv6查询，不配置fallback，保证clash dns的  nameserver为无污染dns。然后开启clash的tun转发，具体设置可以参考：https://github.com/Bitcion/zaixiantuoguan/blob/master/clashDNS   （如果无特殊需求建议删除或自己配置  nameserver-policy部分）

2、开启 ChinaDNS-NG 与SmartDNS

3、编辑SmartDNS的配置参数，把安全dns查询（默认8052）增加 -force-aaaa-soa -force-https-soa屏蔽ipv6结果反馈，如：bind 0.0.0.0:8052 -group office -force-aaaa-soa -force-https-soa

4、下载https://bitcion.github.io/opt-script/adv6.txt 与 https://bitcion.github.io/opt-script/ad.sh 到Opt文件夹。若不下载，建议手动删除 chinadns-ng 参数中的“ -C /opt/adv6.txt” ‘,/opt/cn.txt’ ‘,/opt/quic.txt’（不清理问题也不大）



ipv6使用提示：
对于很多需要必须进行代理（比如Netflix）以及很多网站无法自动跳回ipv4透明代理的需求，则需要在clash dns配置：
  nameserver-policy:
       "geosite:bing,openai,yahoo,netflix": 
             - 0.0.0.0:8052
这些网站的dns请求会在clash dns分流到SmartDNS的bind 0.0.0.0:8052 -group office -force-aaaa-soa -force-https-soa 过滤ipv6 查询，实现纯ipv4透明代理。
另外删除掉    "rule-set:DLC规则": 
      - tcp://0.0.0.0:8052 
      - 0.0.0.0:8052 这是我方便自己用的配置，若不熟悉clash的“- RULE-SET,DLC规则”功能，删除保存



首次启动配置覆盖功能 
功能说明：
添加了首次启动检测机制，在固件首次安装或 NVRAM 重置后，自动使用脚本预设覆盖 Clash DNS、SmartDNS 和 ChinaDNS-NG 的配置文件。日常运行时保持原有的"配置文件存在则不覆盖"逻辑。

若不需要，清除以下增量部分：

文件 1: script/Sh10_clash.sh 
删除位置 1： 第 679 行之后、第 680 行之前的插入内容 

删除位置 2： 第 424 行之后、第 426 行之前的插入内容 

文件 2: script/Sh09_chinadns_ng.sh 
删除位置 1： 第 361 行之后、第 362 行之前的插入内容

删除位置 2： 第 216 行之后、第 217 行之前的插入内容

文件 3: script/Sh99_ss_tproxy.sh

删除位置 : 第 403 行之后、第 404 行之前的插入内容


