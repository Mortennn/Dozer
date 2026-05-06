# Apple Silicon 支持说明

## 概述

本项目现已支持 Apple Silicon (arm64) 架构，可以在 M1/M2/M3 等 Apple Silicon Mac 上原生运行。

## 技术实现

### 1. Carthage XCFrameworks

使用 `--use-xcframeworks` 参数来构建依赖库，这样可以同时支持多个架构：

```bash
carthage bootstrap --use-xcframeworks --cache-builds --platform osx
```

XCFrameworks 的优势：
- 支持多架构（x86_64 和 arm64）
- 单一 framework 包含所有架构
- Xcode 自动选择正确的架构

### 2. 架构配置

在 `project.yml` 中添加了架构设置：

```yaml
ARCHS: $(ARCHS_STANDARD)
VALID_ARCHS: x86_64 arm64
```

这确保了：
- 使用标准架构（当前平台的原生架构）
- 明确支持 x86_64 和 arm64

## 构建说明

### 首次构建

```bash
make build
```

这会：
1. 安装 Homebrew 依赖
2. 使用 XCFrameworks 构建 Carthage 依赖
3. 生成 SwiftGen 文件
4. 生成 Xcode 项目
5. 打开 Xcode

### 清理重建

如果遇到架构相关问题，可以清理 Carthage 缓存：

```bash
rm -rf ~/Library/Caches/org.carthage.CarthageKit
rm -rf Carthage
make build
```

## 依赖库

所有 Carthage 依赖都已支持 Apple Silicon：

- LaunchAtLogin (v4.1.0)
- Defaults (v4.2.2)
- Preferences (v2.2.1)
- MASShortcut (2.4.0)
- Sparkle (1.26.0)

## 兼容性

- **最低系统要求**: macOS 10.13 (High Sierra)
- **支持架构**: x86_64 (Intel) 和 arm64 (Apple Silicon)
- **通用二进制**: 构建的应用是通用二进制，可在两种架构上运行

## 故障排除

### 问题：Carthage 构建失败

**解决方案**：
```bash
# 清理缓存
rm -rf ~/Library/Caches/org.carthage.CarthageKit
rm -rf Carthage

# 重新构建
carthage bootstrap --use-xcframeworks --cache-builds --platform osx
```

### 问题：架构不匹配错误

**解决方案**：
确保使用了 `--use-xcframeworks` 参数，并且 Carthage 版本 >= 0.37.0

```bash
carthage version
```

如果版本过低，更新 Carthage：
```bash
brew upgrade carthage
```

## 更新日期

2026-05-05
