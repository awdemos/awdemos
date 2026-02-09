# QubesOS Security Research

**Security-by-design operating system for isolation and privacy research.**

## Overview

QubesOS is a security-focused operating system that uses virtualization to compartmentalize different activities into isolated domains called qubes. Each qube runs on its own virtual machine, providing strong isolation between different work contexts.

This demo contains research and experiments with QubesOS for security-focused infrastructure and isolation patterns.

## Why QubesOS?

- **Compartmentalization**: Each qube (VM) is isolated from others
- **Security**: Compromise in one qube doesn't affect others
- **Privacy**: Separate qubes for different trust levels
- **Disposable**: Temporary qubes for untrusted activities
- **Xen-based**: Built on Xen hypervisor with proven security

## Research Areas

### 1. Kubernetes Isolation

Research on running Kubernetes clusters within QubesOS qubes for isolated development environments.

- **Domain isolation**: Separate qubes for control plane, worker nodes, and workloads
- **Network segmentation**: Isolated networks between qubes
- **Template-based qubes**: Read-only templates for base images
- **Disposable workers**: Temporary worker qubes for testing

Status: Under development - more details to be added soon.

## Use Cases

| Scenario | Approach | Security Benefit |
|-----------|-----------|------------------|
| Development | Separate qube per project | Compromise isolation |
| Testing | Disposable qubes for each test | Clean state, no persistence |
| Production | Dedicated admin qubes | Least privilege access |
| Security research | Isolated qubes for malware analysis | No escape from analysis environment |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     QubesOS Domux0                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  sys-net     │  │  sys-firewall│  │  sys-usb     │  │
│  │  (network)   │  │  (firewall)  │  │  (USB)       │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐    │
│  │              AppVMs (Isolated Qubes)               │    │
│  │                                                       │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐         │    │
│  │  │  dev     │  │  work    │  │  personal│         │    │
│  │  │  qube    │  │  qube    │  │  qube    │         │    │
│  │  └─────────┘  └─────────┘  └─────────┘         │    │
│  │                                                       │    │
│  │  ┌───────────────────────────────────────────┐       │    │
│  │  │     Disposable qubes (ephemeral)       │       │    │
│  │  └───────────────────────────────────────────┘       │    │
│  └───────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## Security Benefits

### Compartmentalization
- **Kernel isolation**: Each qube has its own Linux kernel
- **Memory isolation**: No shared memory between qubes
- **Network isolation**: Separate virtual network interfaces

### Attack Surface Reduction
- **Template-based**: Read-only base images reduce attack surface
- **Disposable**: Ephemeral qubes reset to clean state
- **Service qubes**: Network access only in dedicated qubes

### Least Privilege
- **Role-based**: Different qubes for different trust levels
- **Whitelist approach**: Network and device access controlled per qube
- **No shared resources**: No access to other qubes by default

## Getting Started

### Installation

1. **Download QubesOS**: https://www.qubes-os.org/downloads/

2. **Verify ISO**:
   ```bash
   sha256sum qubes-installer.iso
   # Compare with signature on website
   ```

3. **Install**: Follow official installation guide

### Basic Setup

1. **Create work qube**:
   ```bash
   qvm-create work --template template-fedora-39
   qvm-prefs --set work netvm sys-firewall
   ```

2. **Create disposable qube**:
   ```bash
   qvm-create --template template-fedora-39 --label red disposable
   qvm-prefs --set disposable netvm sys-firewall
   ```

3. **Setup clipboard**:
   ```bash
   # Enable copy-paste between qubes (caution)
   qvm-prefs --set work allow_full_screen true
   ```

## Advanced Topics

### Kubernetes in QubesOS

Research on running isolated Kubernetes clusters within QubesOS:

- **Control plane qube**: Dedicated qube for etcd, API server, scheduler
- **Worker qubes**: Separate qubes for each worker node
- **Network**: Isolated virtual networks between qubes
- **Storage**: Template-based images with persistent volumes

Status: See `KubernetesClusterProject.md` for ongoing research.

## Security Best Practices

### 1. Template Management
- Keep templates updated: `sudo dnf update -y`
- Use separate templates for different security levels
- Clone templates for base images

### 2. Network Isolation
- No network access to sys-net from app qubes
- Firewall qube for all external connections
- Separate VPN qubes for different contexts

### 3. File Sharing
- Use QubesOS built-in file copy (Shift+Ctrl+Alt+F/V)
- Avoid sharing executables between qubes
- Use disposable qubes for untrusted files

### 4. Service qubes
- Dedicqate qubes for services (sys-net, sys-firewall, sys-usb)
- No GUI on service qubes
- Minimize attack surface

## Resources

### Official Documentation
- [QubesOS Official Site](https://www.qubes-os.org/)
- [QubesOS Documentation](https://www.qubes-os.org/doc/)
- [Security Bulletins](https://www.qubes-os.org/news/)

### Community
- [QubesOS Forum](https://forum.qubes-os.org/)
- [Mailing Lists](https://www.qubes-os.org/mailing-lists/)
- [Wiki](https://wiki.qubes-os.org/)

## Future Research

- [ ] Complete Kubernetes isolation research
- [ ] Add container isolation patterns
- [ ] Explore multi-tenant infrastructure in QubesOS
- [ ] Document CI/CD pipeline in isolated qubes
- [ ] Security audit of qube configurations

## Related Projects

This research complements other security and isolation projects in this portfolio:
- `demos/kubernetes/` - Kubernetes production patterns
- `demos/llm/` - AI/ML infrastructure
- `demos/security/` - Security best practices

---

**Research Status**: 🚧 Under development - more details to be added soon.
