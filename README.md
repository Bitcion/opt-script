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
**开启IPv6 透明代理 模式时，实际是：IPv4透明代理 + IPv6直连**
- IPv4 流量通过 Clash 透明代理，访问国外服务
- IPv6 流量保持直连，享受原生 IPv6 网络速度
- 实现最佳性能与稳定性的平衡

**可选模式：IPv4+IPv6透明代理 **
- ipv6会被打标，但不会真正进入代理，实际上还是直连
- 出现ipv6转发错误时可尝试

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


## 📋 兼容性说明

- 推荐固件：3.4.3.9-099_24-02-1 及更旧版本
- 新固件可能需要手动调整 chinadns-ng 参数
- 无 IPv6 环境不推荐使用

---

## Notes

脚本主要文件位于 `script/Sh10_clash.sh`，负责 Clash 的启动和配置管理。域名列表文件通过 `script/ad.sh` 自动下载 [5-cite-8](#5-cite-8) ，无需手动配置。首次启动检测机制通过检查 `first_boot_done` NVRAM 变量实现 [5-cite-9](#5-cite-9) 。如需完整功能，建议搭配 `https://bitcion.github.io/opt-file` 旧 OPT 环境使用。

