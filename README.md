# opt-script - Clash 透明代理增强脚本

专为 Clash 透明代理优化的脚本集合，重点改进 IPv6 环境下的 DNS 配置和用户体验。

## 🆕 新特性亮点

### Clash DNS 端口自动优化
- 自动将 Clash DNS 端口设置为 **8054**，避免与 ChinaDNS-NG 的 8053 端口冲突 [5-cite-0](#5-cite-0) 
- 实现 IPv4 透明代理与 IPv6 的完美共存

### 智能首次启动配置
- 固件首次安装时自动覆盖 Clash DNS、SmartDNS 和 ChinaDNS-NG 配置 [5-cite-1](#5-cite-1) 
- 无需手动配置即可开箱即用

### 多内核支持
- 支持 Clash Premium、Meta 等多种内核 [5-cite-2](#5-cite-2) 
- 自动识别并适配不同内核特性

## 🌐 推荐启用 IPv6 透明代理

### 工作模式说明
**推荐模式：IPv4透明代理 + IPv6直连**
- IPv4 流量通过 Clash 透明代理，访问国外服务
- IPv6 流量保持直连，享受原生 IPv6 网络速度
- 实现最佳性能与稳定性的平衡

**可选模式：IPv4+IPv6 双栈代理**
- 所有流量（IPv4 和 IPv6）均通过代理
- 适用于需要全面代理的特殊网络环境

### 配置方式
在路由器管理界面设置 `ss_ip46=2` 启用双栈代理，或 `ss_ip46=0` 仅启用 IPv4 代理 [5-cite-3](#5-cite-3) 。

## ⚙️ 自定义配置指南

### 1. 下载地址配置
在路由器"自定义 opt-script 下载地址"中设置：
```
https://bitcion.github.io/opt-script/
```

### 2. ISP DNS 性能优化

**运营商 DNS 自定义：**
```bash
# 将默认的 223.5.5.5 替换为你的运营商 DNS
-c ::#8051,udp://2409:803c:2000:1::26
```

**TUN 接口选择：**
- `198.18.0.1` - TUN 外部接口（推荐，避免转发问题）
- `198.18.0.2` - TUN 内部接口（默认）

### 3. 节点域名解析保护

**proxy-server-nameserver 配置：**
```yaml
proxy-server-nameserver:
  - https://dns.alidns.com/dns-query  # 防止节点域名泄露给运营商
```

此配置为代理节点提供专用 DNS 解析，使用 DoH 避免域名泄露。

### 4. 服务分流策略

**强制 IPv4 代理：**
```yaml
nameserver-policy:
  "geosite:bing,category-ai-!cn,netflix,spotify,yahoo": 
    - tcp://0.0.0.0:8052  # 通过 SmartDNS 过滤 IPv6，实现纯 IPv4 代理
```

### 5. 流量嗅探和 TUN 配置

```yaml
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
```

### 6. Web 面板选择

支持多种管理面板，可在配置中选择：
- Clash Dashboard（默认） [5-cite-4](#5-cite-4) 
- Yacd-meta [5-cite-5](#5-cite-5) 
- Razord-meta [5-cite-6](#5-cite-6) 
- MetaCubeXD [5-cite-7](#5-cite-7) 

## 📋 兼容性说明

- 推荐固件：3.4.3.9-099_24-02-1 及更旧版本
- 新固件可能需要手动调整 chinadns-ng 参数
- 无 IPv6 环境不推荐使用

---

## Notes

脚本主要文件位于 `script/Sh10_clash.sh`，负责 Clash 的启动和配置管理。域名列表文件通过 `script/ad.sh` 自动下载 [5-cite-8](#5-cite-8) ，无需手动配置。首次启动检测机制通过检查 `first_boot_done` NVRAM 变量实现 [5-cite-9](#5-cite-9) 。如需完整功能，建议搭配 `https://bitcion.github.io/opt-file` 旧 OPT 环境使用。

Wiki pages you might want to explore:
- [Network Architecture and Data Flow (Bitcion/opt-script)](/wiki/Bitcion/opt-script#9.2)
- [Transparent Proxy Framework (Sh99_ss_tproxy.sh) (Bitcion/opt-script)](/wiki/Bitcion/opt-script#3.6)

Wiki pages you might want to explore:
- [Transparent Proxy Framework (Sh99_ss_tproxy.sh) (Bitcion/opt-script)](/wiki/Bitcion/opt-script#3.6)

### Citations

**File:** script/Sh10_clash.sh (L257-263)
```shellscript
if [ "$app_78" == "premium" ] || [ "$app_78" == "premium_1" ] ; then
	[ ! -s "$SVC_PATH" ] && logger -t "【clash】" "下载 premium (闭源版) 主程序: https://github.com/Dreamacro/clash/releases/tag/premium" && [ "$app_78" != "premium_1" ] && nvram set app_78="premium_1" && app_78="premium_1"
	wgetcurl_file "$SVC_PATH" "$hiboyfile/clash-premium" "$hiboyfile2/clash-premium"
else
	[ ! -s "$SVC_PATH" ] && logger -t "【clash】" "下载 Clash.Meta 主程序: https://github.com/Clash-Mini/mihomo" && [ "$app_78" != "meta_1" ] && nvram set app_78="meta_1" && app_78="meta_1"
	wgetcurl_file "$SVC_PATH" "$hiboyfile/clash-meta" "$hiboyfile2/clash-meta"
fi
```

**File:** script/Sh10_clash.sh (L401-403)
```shellscript
		logger -t "【clash】" " 下载 clash 面板 : https://github.com/Dreamacro/clash-dashboard/tree/gh-pages"
		wgetcurl_checkmd5 /opt/app/clash/clash_webs.tgz "$hiboyfile/clash_webs2.tgz" "$hiboyfile2/clash_webs2.tgz" N
		[ "$app_79" != "clash_1" ] && nvram set app_79="clash_1" && app_79="clash_1"
```

**File:** script/Sh10_clash.sh (L405-409)
```shellscript
	if [ "$app_79" == "yacd" ] || [ "$app_79" == "yacd_1" ] ; then
		logger -t "【clash】" "下载 yacd 面板 : https://github.com/MetaCubeX/Yacd-meta/tree/gh-pages"
		wgetcurl_checkmd5 /opt/app/clash/clash_webs.tgz "$hiboyfile/clash_webs.tgz" "$hiboyfile2/clash_webs.tgz" N
		[ "$app_79" != "yacd_1" ] && nvram set app_79="yacd_1" && app_79="yacd_1"
	fi
```

**File:** script/Sh10_clash.sh (L410-414)
```shellscript
	if [ "$app_79" == "meta" ] || [ "$app_79" == "meta_1" ] ; then
		logger -t "【clash】" "下载 Meta 面板 : https://github.com/MetaCubeX/Razord-meta/tree/gh-pages"
		wgetcurl_checkmd5 /opt/app/clash/clash_webs.tgz "$hiboyfile/clash_webs3.tgz" "$hiboyfile2/clash_webs3.tgz" N
		[ "$app_79" != "meta_1" ] && nvram set app_79="meta_1" && app_79="meta_1"
	fi
```

**File:** script/Sh10_clash.sh (L415-419)
```shellscript
	if [ "$app_79" == "xd" ] || [ "$app_79" == "xd_1" ] ; then
		logger -t "【clash】" "下载 xd 面板 : https://github.com/metacubex/metacubexd/tree/gh-pages"
		wgetcurl_checkmd5 /opt/app/clash/clash_webs.tgz "$hiboyfile/clash_webs4.tgz" "$hiboyfile2/clash_webs4.tgz" N
		[ "$app_79" != "xd_1" ] && nvram set app_79="xd_1" && app_79="xd_1"
	fi
```

**File:** script/Sh10_clash.sh (L699-699)
```shellscript
  listen: 0.0.0.0:8054
```

**File:** script/Sh99_ss_tproxy.sh (L405-415)
```shellscript
#以下为自动覆盖
first_boot=`nvram get first_boot_done`  
[ -z $first_boot ] && first_boot=0  
  
if [ "$first_boot" = "0" ] ; then  
    logger -t "【ss_tproxy】" "首次启动，初始化 ss-tproxy 钩子配置"  
    rm -f "/etc/storage/app_26.sh"  
    nvram set first_boot_done=1  
    nvram commit	
fi
#清除以上内容清除自动覆盖
```

**File:** script/Sh99_ss_tproxy.sh (L451-452)
```shellscript
ipv4='true'     # true:启用ipv4透明代理; false:关闭ipv4透明代理
ipv6='false'    # true:启用ipv6透明代理; false:关闭ipv6透明代理
```
