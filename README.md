# opt-script
opt-script - Clash 透明代理增强脚本  

专为 Clash 透明代理优化的脚本集合，重点改进 IPv6 环境下的 DNS 配置和用户体验。
🆕 新特性亮点  

Clash DNS 端口自动优化  
自动将 Clash DNS 端口设置为 8054，避免与 ChinaDNS-NG 的 8053 端口冲突 Sh10_clash.sh:699
实现 IPv4 透明代理与 IPv6 的完美共存
智能首次启动配置  
固件首次安装时自动覆盖 Clash DNS、SmartDNS 和 ChinaDNS-NG 配置
无需手动配置即可开箱即用
多内核支持  
支持 Clash Premium、Meta 等多种内核 Sh10_clash.sh:257-263
自动识别并适配不同内核特性
⚙️ 自定义配置指南  

1. 下载地址配置  
在路由器"自定义 opt-script 下载地址"中设置：
https://bitcion.github.io/opt-script/  
2. ChinaDNS-NG 参数自定义  
默认参数： Sh09_chinadns_ng.sh:30
-M -b :: -c ::#8051,udp://223.5.5.5 -t ::#8054,198.18.0.2 -m /opt/app/chinadns_ng/chnlist.txt,/opt/cn.txt,/opt/ad.txt -g /opt/app/chinadns_ng/gfwlist.txt,/opt/ipv4.txt
自定义选项：
-c ::#8051,udp://2409:803c:2000:1::26 - 替换为你的 IPv6 DNS 服务器
-t ::#8054,udp://198.18.0.1 - 调整可信 DNS 服务器
添加/删除域名列表文件路径
3. SmartDNS Bind 配置  
默认配置： Sh09_chinadns_ng.sh:407-410
bind [::]:8051 -group china  
bind-tcp [::]:8051 -group china -no-cache  
bind [::]:8052 -group office -force-aaaa-soa   
bind-tcp [::]:8052 -group office -force-aaaa-soa -no-cache
自定义选项：
8051 端口：中国域名 DNS（可添加国内 DNS 服务器）
8052 端口：国外域名 DNS（-force-aaaa-soa 过滤 IPv6）
4. Clash DNS 完整配置  
基础模板： Sh10_clash.sh:694-746
dns:  
  enable: true  
  listen: 0.0.0.0:8054  
  enhanced-mode: redir-host  
  ipv6: true  
    
  nameserver:  
    - https://dns64.dns.google/dns-query  
    - https://dns.google/dns-query  
    - https://doh.opendns.com/dns-query  
    - tls://dns.opendns.com  
    - tls://dns.google  
    - tls://one.one.one.one  
      
  nameserver-policy:  
    "RULE-SET:DLC规则,DNS4":  
      - tcp://0.0.0.0:8052   
    "geosite:bing,category-ai-!cn,netflix,spotify,yahoo":   
      - tcp://0.0.0.0:8052
高级自定义：
添加更多 DoH/DoT 服务器
调整 nameserver-policy 实现网站分流
配置 fake-ip-filter 过滤特定域名
5. 流量嗅探和 TUN 配置  
sniffer:  
  enable: true  
  override-destination: false  
  sniff:  
    tls: { ports: [853, 8443] }        
  
tun:  
  enable: true  
  stack: system   
  auto-route: false  
  mtu: 1500
6. Web 面板选择  
支持多种管理面板，可在配置中选择：
Clash Dashboard（默认） Sh10_clash.sh:401-403
Yacd-meta Sh10_clash.sh:405-409
Razord-meta Sh10_clash.sh:410-414
MetaCubeXD Sh10_clash.sh:415-419
📋 兼容性说明  

推荐固件：3.4.3.9-099_24-02-1 及更旧版本
新固件可能需要手动调整 chinadns-ng 参数
无 IPv6 环境不推荐使用

