# opt-script
本脚本是hiboy旧脚本的改进IPv6优化，若无IPV6环境不推荐使用，在“自定义 opt-script 下载地址”改为：https://bitcion.github.io/opt-script/     最好搭配旧OPT环境：https://bitcion.github.io/opt-file 默认的https://opt.cn2qq.com/opt-file 也可兼容

建议搭配	3.4.3.9-099_24-02-1以及更旧固件版本使用，若使用新固件，chinadns-ng 会出现4个选项，如果遇到这种，先把选项切换到"启动 手动设置"复制参数，再切换到“启动 sstproyx自动设置”把其中的“0”参数删除，再复制进去，应用页面设置保存

相对于原本脚本主要改动之处是强制把clash dns的监听端口改了“8054”

改进目的是是与ChinaDNS-NG的8053监听端口不同，实现ipv4透明代理与ipv6共存。设置建议：

1、开启clash dns的ipv6查询，不配置fallback，保证clash dns的  nameserver为无污染dns。然后开启clash的tun转发，具体设置可以参考：https://github.com/Bitcion/zaixiantuoguan/blob/master/clashDNS   （如果无特殊需求建议删除或自己设置  nameserver-policy部分）

2、开启 ChinaDNS-NG 与SmartDNS

3、SmartDNS的安全dns查询（默认8052）增加 -force-aaaa-soa -force-https-soa屏蔽ipv6结果反馈，例如：bind 0.0.0.0:8052 -group office -force-aaaa-soa -force-https-soa



ipv6使用提示：
对于很多需要必须进行代理（比如Netflix）以及很多网站无法自动跳回ipv4透明代理的需求，则需要在clash dns配置：
  nameserver-policy:
       "geosite:bing,openai,yahoo,netflix": 
             - 0.0.0.0:8052
这些网站的dns请求会在clash dns分流到SmartDNS的bind 0.0.0.0:8052 -group office -force-aaaa-soa -force-https-soa 过滤ipv6 查询，实现纯ipv4透明代理

