# hibernalglow/tap

[![brew test-bot](https://github.com/HibernalGlow/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/HibernalGlow/homebrew-tap/actions/workflows/tests.yml)

仓库地址：<https://github.com/HibernalGlow/homebrew-tap>

个人 Homebrew tap：收纳 Homebrew 官方仓库（`homebrew/cask`）没有收录的小众 macOS GUI 应用。

相当于原来 Windows 上自建 Scoop bucket 的 macOS 对应物 —— 上游有 GitHub Release、产物命名稳定，但没人打包的软件，都在这里。

## 安装 tap

```sh
brew tap hibernalglow/tap
```

> GitHub 上的 owner 是 `HibernalGlow`（含大写），但 Homebrew 会把 tap 名统一转小写，克隆路径也是小写的（`/opt/homebrew/Library/Taps/hibernalglow/homebrew-tap`）。写 `HibernalGlow/tap` 同样能装，只是内部规范形式是 `hibernalglow/tap`。

Homebrew 7 起默认**不加载**第三方 tap 里的 cask/公式，首次 `install` 时会弹出信任提示。想提前授权：

```sh
brew trust hibernalglow/tap
```

## 安装软件

```sh
brew install --cask splayer-next
```

不先 `tap` 也可以直接一步到位：

```sh
brew install --cask hibernalglow/tap/splayer-next
```

写进 `Brewfile`：

```ruby
tap "hibernalglow/tap"
cask "splayer-next"
```

卸载（`--zap` 会一并清掉应用数据）：

```sh
brew uninstall --cask --zap splayer-next
```

## 当前收录

| Cask | 版本 | 上游 | 说明 |
| --- | --- | --- | --- |
| `splayer-next` | 1.1.0 | [SPlayer-Dev/SPlayer-Next](https://github.com/SPlayer-Dev/SPlayer-Next) | 跨平台桌面音乐播放器（Electron + Rust），arm64 / intel 双架构 |

## 目录结构

```
.
├── Casks/
│   └── s/
│       └── splayer-next.rb     # 按 token 首字母分子目录（对齐 homebrew/cask 布局）
├── Formula/                    # 目前为空，保留占位
├── .github/
│   ├── dependabot.yml          # 每周自动更新 workflow 里的 action 版本
│   └── workflows/
│       ├── tests.yml           # push / PR 触发：测试 + 校验
│       └── autobump.yml        # 每天检查上游 Release，开升级 PR
└── README.md
```

`Casks/<首字母>/<name>.rb` 与扁平的 `Casks/<name>.rb` 都能被 Homebrew 识别（内部按 `Casks/**/*.rb` 递归匹配）。这里跟随官方仓库用首字母分目录，cask 多了以后不会挤在一个平面里。

## 添加新的 cask

> **前提**：上游必须提供稳定的 GitHub Release，而且产物文件名里带版本号。
> 只有满足这一点，`livecheck` + autobump 才能自动工作。如果上游只有 rolling tag（如 `latest`）或产物名不带版本号，见下文「无法自动检测时的维护方案」。

```sh
cd ~/Projects/homebrew-tap

# 1) 查上游最新 release 的 tag 与产物名
gh release view --repo <owner>/<repo> --json tagName,assets

# 2) 下载产物算真实 sha256（version / sha256 必须是真实值，不能猜）
gh release download <tag> --repo <owner>/<repo> --pattern '*.dmg' --dir /tmp/casksha
shasum -a 256 /tmp/casksha/*.dmg

# 3) 新建 cask 文件
$EDITOR Casks/<首字母>/<name>.rb
```

骨架参考 `Casks/s/splayer-next.rb`。要点：

- 顺序遵循 Cask Style Guide：`arch` → `version` → `sha256` → `url` → `name` → `desc` → `homepage` → `livecheck` → `depends_on` → `app` → `zap`
- 上游产物有架构区分时，用 `arch arm: "arm64", intel: "x64"` 重定义 `arch`，再在 URL 里插值，避免写 `on_arm` / `on_intel` 两份
- `desc` 不重复包名、结尾不加句号、不超过 80 字符
- **不要写 `verified:`** —— Homebrew 已废弃该参数，写了会持续报 deprecation 警告
- `zap trash:` 只列应用自己产生的数据；用户的下载内容 / 音乐库不要列入（`--zap` 会真删）

## 更新版本

### 自动（日常走这条）

`.github/workflows/autobump.yml` 每天 11:30 UTC 跑一次 `brew bump --casks --open-pr`：

1. 用 `livecheck` 逐个比对上游 GitHub Release
2. 对落后的 cask 自动算新版本 + 新 sha256，写好文件
3. **开一个 Pull Request，仅此而已**

不会自动合并、不会自动打 tag、不会自动发版 —— 需要人工看完 diff 再点 merge。想立刻检查也可以手动触发：

```sh
gh workflow run "brew bump"
```

> 注意：用默认 `GITHUB_TOKEN` 开的 PR 不会再触发 workflow（GitHub 会屏蔽由该 token 产生的事件），所以升级 PR 上看不到 CI 状态。要拿到 CI 状态，把 `autobump.yml` 里的 `HOMEBREW_GITHUB_API_TOKEN` 换成一个 fine-grained PAT（`contents: write` + `pull-requests: write`）。不换也能用，只是需要人工肉眼核对版本号与 checksum。

### 手动

```sh
cd ~/Projects/homebrew-tap
# 改 version + 重新算两个架构的 sha256，然后：
brew style Casks/s/splayer-next.rb
git commit -am "splayer-next 1.2.0" && git push
```

## 本地测试

```sh
cd ~/Projects/homebrew-tap
```

**语法 / 格式 / 风格**（这些直接吃文件路径，不用先 tap）：

```sh
ruby -c Casks/s/splayer-next.rb
brew style Casks/s/splayer-next.rb
```

**完整校验**（`audit` / `livecheck` / `install` 都要求 cask 在 tap 里，裸路径会被拒绝：`Error: Homebrew requires casks to be in a tap`）：

```sh
# 让本地 tap 的克隆同步到最新提交
git -C "$(brew --repo hibernalglow/tap)" pull

brew audit --strict --online --tap=hibernalglow/tap
brew livecheck --cask --tap=hibernalglow/tap

brew install --cask --dry-run hibernalglow/tap/splayer-next   # 预演
brew install --cask hibernalglow/tap/splayer-next             # 真装
```

**CI 本地等价物**：

```sh
brew test-bot --only-cleanup-before
brew test-bot --only-setup
brew test-bot --only-tap-syntax
```

> 本地 `brew audit` 需要可用的 Command Line Tools。本机 CLT 26.6 对 macOS 27.0 偏旧时，`brew audit` 会直接以 `Your Command Line Tools are too outdated` 退出（连官方 cask 也一样），此时 `brew style` / `ruby -c` / `install` 仍然正常。**CI 不受影响** —— 同一份 cask 在 `macos-26` runner 上 `brew audit --strict --online` 是通过的。要修本机：`sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install`。

## CI 都检查什么

`tests.yml` 分三个 job，全部在 `macos-26` 上跑（cask 是 macOS 专属产物）：

| Job | 内容 |
| --- | --- |
| `tap-syntax` | 官方 `brew test-bot`：`--only-cleanup-before` → `--only-setup` → `--only-tap-syntax` |
| `cask-checks` | `ruby -c` 全量语法检查 → `brew style <tap>` → `brew audit --strict --online --tap=<tap>` |
| `install` | `brew trust --tap`，然后逐个 cask 真实 `install` + `uninstall --zap` |

为什么不能只靠 `test-bot`：`brew test-bot` 是围绕 formula 设计的，没有 cask 步骤；`--only-tap-syntax` 里的 audit **不带** `--strict` / `--online`。cask 的格式、URL 可达性、checksum 格式、`depends_on macos` 这些，实际是靠 `cask-checks` 那个 job 兜住的。

## 后续扩展

新增 MImage 之类的独立 macOS GUI 应用，直接往 `Casks/` 里放文件即可，CI 与 autobump 会自动覆盖 —— 两个 workflow 都是遍历 `Casks/**/*.rb`，不维护软件清单，所以**不需要改任何 workflow**。

约定：

- **不引入额外依赖**：只用 Homebrew 自带的 `brew style` / `audit` / `livecheck` / `bump` + 官方 `Homebrew/actions/*`，不写自定义脚本、不加第三方 action
- **版本信息单一来源**：版本号只写在 cask 的 `version` 里，靠 `livecheck` 从上游推导，不额外维护 manifest
- **上游必须可自动检测**：否则见下
- formula（CLI 工具）目前不需要；真要加，把 `brew tap-new` 生成的 `publish.yml`（`brew pr-pull`，给 bottle 用）从模板取回来即可 —— 现在没有 formula，那个 workflow 永远跑不起来，所以没放进来

### 无法自动检测时的维护方案

如果某个上游不满足「稳定 Release + 产物名带版本号」，autobump 会拿不到新版本（输出 `Latest livecheck version: unable to get versions`）。按顺序处理：

**1. 优先补 livecheck。** 多数情况是 Release 命名不规律，写个 `livecheck` block 指定 `regex` / `strategy` 就能救回来：

```ruby
livecheck do
  url :url
  regex(/SPlayer-Next[._-]v?(\d+(?:\.\d+)+)/i)
  strategy :github_releases
end
```

`:github_releases` 会遍历所有 release 而不是只看 `/releases/latest`，适合上游把稳定版标成 prerelease 的情况。

**2. 退化为手动更新。** `version :latest` 的 rolling 包只能这样：按上文「更新版本 → 手动」流程走一遍，每季度检查一次。

**3. 换渠道。** 既不满足又需要频繁更新的，考虑不做成 cask，改用上游自己的安装方式，别给 tap 引入长期手工负担。

> 注意：`brew style <tap>` 会用 rubocop-md 把 README 里的 Ruby 代码块也一起检查，所以文档中的 Ruby 片段同样要保持缩进与风格正确，否则 CI 会红。

## 已知注意事项

**`splayer-next` 没有设 `auto_updates true`，这是刻意的。** 上游确实带了 `electron-updater`（`app-update.yml` 指向自己的 GitHub Release），但发布的 macOS 包是 **adhoc 签名、没有 Developer ID**（`codesign -dv` 显示 `Signature=adhoc`、`TeamIdentifier=not set`）。未签名的 macOS 应用自更新不可靠，而且一旦标了 `auto_updates true`，`brew outdated` 就不再上报该 cask —— 等于把 tap 唯一的升级提醒也关掉了。所以这里让 Homebrew 作为升级渠道（`brew upgrade --cask splayer-next`）。

**应用未签名会被 Gatekeeper 拦。** 通过 `brew install --cask` 安装时 Homebrew 会清掉 quarantine 属性，正常打开即可；手动从 dmg 拖进 `/Applications` 的话需要 `xattr -dr com.apple.quarantine /Applications/SPlayer-Next.app`。
