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
| `micyou` | 2.0.3 | [LanRhyme/MicYou](https://github.com/LanRhyme/MicYou) | 把安卓设备变成电脑麦克风（Tauri 2），**仅 arm64**，需 macOS ≥ 11，另带 `micyou-cli` / `micyou-tui`。⚠️ 装完需重签名，见「已知上游问题」 |
| `netcatty` | 1.1.83 | [binaricat/Netcatty](https://github.com/binaricat/Netcatty) | SSH / SFTP / 终端工作台，支持分屏与 Telnet / Mosh；arm64 / intel 双架构。签名与公证正常，装完即用 |
| `splayer-next` | 1.1.0 | [SPlayer-Dev/SPlayer-Next](https://github.com/SPlayer-Dev/SPlayer-Next) | 跨平台桌面音乐播放器（Electron + Rust），arm64 / intel 双架构。⚠️ 装完需重签名，见「已知上游问题」 |
| `lume` | 1.2.0 | [hugomyb/Lume](https://github.com/hugomyb/Lume) | 轻量虚拟机管理器（macOS / Linux 客户机），universal 二进制。⚠️ 装完需重签名，见「已知上游问题」 |
| `font-lxgw-wenkai-screen` | 1.522 | [lxgw/LxgwWenKai-Screen](https://github.com/lxgw/LxgwWenKai-Screen) | 霞鹜文楷屏幕阅读版，半陆标字形，Roboto 打底补字 |
| `font-lxgw-wenkai-gb-screen` | 1.522 | 同上 | 屏幕阅读版 GB 版，**陆标（简体）字形 —— 简体用户装这个** |
| `font-lxgw-wenkai-mono-screen` | 1.522 | 同上 | 等宽屏幕阅读版，Inconsolata 打底补字 |
| `font-lxgw-wenkai-mono-gb-screen` | 1.522 | 同上 | 等宽屏幕阅读版 GB 版 |

> `micyou` / `splayer-next` / `lume` 装完**必须重签名才能启动**（上游打包缺陷，不是安装出错）。命令见下文「已知上游问题 → 签名不一致」。`brew info --cask <name>` 的 Caveats 段里也会打出来；机器上已配了 LaunchAgent 自动做这件事，见「签名不一致 → 自动修复」。


> 屏幕阅读版与主版「霞鹜文楷」的区别：字重由 Medium 改为 Regular 并调整度量数据，PC / 手机屏幕上更清晰。上游只提供裸 `.ttf`（没有压缩包），所以 4 个变体各自一个 cask —— 一个 cask 只能带一组 `url` / `sha256`。只想要其中一个的话装对应的即可。

## 目录结构

```
.
├── Casks/
│   ├── f/
│   │   └── font-lxgw-wenkai-*.rb   # 4 个字体变体各一个 cask
│   ├── m/
│   │   └── micyou.rb
│   ├── n/
│   │   └── netcatty.rb
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

骨架参考 `Casks/s/splayer-next.rb`（双架构应用）与 `Casks/m/micyou.rb`（单架构 + 附带 CLI + caveats）。要点：

- 顺序遵循 Cask Style Guide：`arch` → `version` → `sha256` → `url` → `name` → `desc` → `homepage` → `livecheck` → `depends_on` → `app` → `zap`
- 上游产物有架构区分时，用 `arch arm: "arm64", intel: "x64"` 重定义 `arch`，再在 URL 里插值，避免写 `on_arm` / `on_intel` 两份
- 上游只发**单一架构**时，直接 `depends_on arch: :arm64`（或 `:x86_64`），URL 里写死该架构即可
- `depends_on macos:` **别照抄 `Info.plist` 的 `LSMinimumSystemVersion`** —— Tauri / Electron 常统一写 `10.13`，不代表真实下限。以二进制为准：`otool -l <exe> | grep -A5 LC_BUILD_VERSION` 里的 `minos`（例：MicYou 的 plist 写 10.13，实际 `minos 11.0` → `depends_on macos: :big_sur`）
- `desc` 不重复包名、结尾不加句号、不超过 80 字符
- **不要写 `verified:`** —— Homebrew 已废弃该参数，写了会持续报 deprecation 警告
- `zap trash:` 只列应用自己产生的数据；用户的下载内容 / 音乐库不要列入（`--zap` 会真删）
- app 里若还打包了 CLI / TUI 可执行文件，用 `binary "#{appdir}/X.app/Contents/MacOS/x-cli", target: "x-cli"` 暴露出来

### 字体类 cask（`font-` token）

- **必须写 `desc`。** 官方 `homebrew/cask` 里的 font cask 大多没有 `desc`，但那是硬编码的特例：audit 的豁免条件是 `cask.tap == "homebrew/cask"`，第三方 tap 缺 `desc` 会直接报 `Cask should have a description`
- 上游只给裸 `.ttf`（没有压缩包）时，**一个变体一个 cask** —— 一个 cask 只能带一组 `url` / `sha256`。`font` stanza 写 staged 根目录下的文件名，如 `font "LXGWWenKaiScreen.ttf"`
- 上游给压缩包时，一个 cask 可以列多个 `font`（参考官方 `font-lxgw-wenkai` 一次装 6 个字重）
- `name` 写两行（英文 + 中文），`livecheck` 用 `url :url` + `strategy :github_latest`，结尾加 `# No zap stanza required`

### `caveats`

块必须**产出字符串**。最稳、也最推荐的是让 heredoc 作为块的返回值：

```ruby
caveats do
  <<~EOS
    MicYou needs a virtual audio device to expose the phone audio as a
    system input:

      brew install --cask blackhole-2ch
  EOS
end
```

`puts` 也可以用 —— Homebrew 覆写掉了 `Cask::DSL::Caveats#puts`，参数会被收进自定义 caveats（实测有效）。但要注意 **`eval_caveats` 取的是块最后一条表达式的返回值**：如果块以 `if` / 赋值 / 返回 nil 的调用收尾，Caveats 段会静默变空，而 `brew style` 查不出来。所以要么以 heredoc 收尾，要么全文用 `puts`。

`appdir` / `token` / `version` 在 caveats 里可用（`Cask::DSL::Base` 把这些委托给了 cask），可以直接写 `"#{appdir}/X.app"`。

### 不要用 install steps 给上游「打补丁」

Homebrew 7 的 `postflight_steps` 能在安装后跑命令（官方有 cask 在用，如 `pd`、`vcam`），但**这个 tap 里禁用**。原因是一次实测：

- 这些步骤跑在 Homebrew 自己的 `sandbox-exec` 里。当 brew 本身处在另一个沙箱中（IDE 内置终端、脚本运行器、CI 封装等），内层沙箱起不来，报 `sandbox-exec: sandbox_apply: Operation not permitted`，进程 exit 71。
- **`must_succeed: false` 挡不住** —— 沙箱启动失败时整个安装照样中止，而且 Homebrew 会把刚解包出来的 app 删掉（`==> Removing App` → `Purging files`）。也就是说"自动修复失败"的结果是**应用直接消失**，比不写这段更糟。
- 用户没有逃生舱：`HOMEBREW_NO_SANDBOX_CASK` 在 Homebrew 7 里已标记 `odisabled`。
- CI 也验证不了：runner 是 `macos-26`，本机是 macOS 27，`sandbox-exec` 行为不一致，CI 绿灯不代表本机可用。

结论：上游产物缺陷一律写成 `caveats` 命令，由使用者在自己的终端执行一次 —— 可验证、失败无害、不会删掉 app。

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

想让 tap 暂时指向开发目录、省掉 push → pull 的往返：

```sh
brew untap hibernalglow/tap
brew tap hibernalglow/tap ~/Projects/homebrew-tap
```

但 `brew tap <name> <path>` 依然是 **git clone 而非软链** —— 未提交的改动 tap 看不到，必须先 `git commit`。反过来，如果你在开发目录改写过后历史（`--amend` / `rebase`），要用 `git -C "$(brew --repo hibernalglow/tap)" reset --hard origin/main` 把克隆拉回来，否则 `git pull` 会因分叉而失败、brew 继续读旧代码（这点很坑：cask 明明改了却毫无效果）。调试完记得换回 `brew tap hibernalglow/tap`，从 GitHub 克隆，与真实用户视角一致。

换回 GitHub 时**不能直接 `brew untap`**：只要这个 tap 里还有已安装的 cask，Homebrew 会拒绝解绑 —— `Error: Refusing to untap hibernalglow/tap because it contains the following installed casks: hibernalglow/tap/splayer-next`。要么先 `brew uninstall --cask splayer-next`，要么直接改克隆的远端：

```sh
T="$(brew --repo hibernalglow/tap)"
git -C "$T" remote set-url origin https://github.com/HibernalGlow/homebrew-tap.git
git -C "$T" fetch origin && git -C "$T" reset --hard origin/main
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
- **上游产物缺陷用 `caveats` 写清楚，不用 install steps 自动改**：失败会连应用一起删掉，理由见上文
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

## 已知上游问题

### 签名不一致：`splayer-next` / `micyou` / `lume` 装完必须重签名

两个应用带的是**同一类上游打包缺陷**：可执行文件是链接期 ad-hoc 签名（`codesign -dv` 显示 `Signature=adhoc` + `flags=0x2(adhoc,linker-signed)`），签名声明了「有密封资源」，但 `.app` 包体从未生成 `Contents/_CodeSignature`。macOS 读到这个自相矛盾就判定为损坏：

```text
"SPlayer-Next.app" is damaged and can't be opened.
```

`codesign -v` 的原文是 `code has no resources but signature indicates they must be present`。

修复（**首次启动前**执行；把路径换成对应应用）：

```sh
codesign --force --deep --sign - /Applications/SPlayer-Next.app
xattr -dr com.apple.quarantine /Applications/SPlayer-Next.app
```

要点：

- **必须在启动之前修。** 带着坏签名去打开，macOS 会把 app 直接丢进废纸篓 —— 这就是「打开报损坏、然后应用不见了」的原因。真丢了就重新 `brew install` 再修一遍。
- **真正起作用的是重签名。** 实测已重签的副本即使保留 `com.apple.quarantine` 也能正常启动；清 quarantine 只是把 Gatekeeper 的提示一并消掉，属于顺手做的事。
- **每次升级都要重做。** Homebrew 原样解包上游产物，修复不会被保留：`brew upgrade --cask splayer-next` 之后要再执行一次 —— 所以下面给了个自动化的办法。
- **但不放进 cask 的 install steps**，理由见上文「不要用 install steps 给上游打补丁」：那个方案失败时会把刚装好的应用一起删掉。
- 根治要上游改打包流程（Tauri / electron-builder 默认只签二进制、不打资源封套），可以去上游开 issue。

#### 自动修复（推荐）

修复必须在**启动之前**完成（带坏签名被打开时 macOS 会直接把 app 丢进废纸篓），所以让系统在 app 变化时自动跑一遍「检测 → 修复」。用 LaunchAgent 监听 app 包，脚本独立于 Homebrew，最坏情况也只是它自己失败，不会影响安装。

`~/Library/Application Support/cask-sign-repair/repair.sh` —— 检测靠 `codesign --verify --deep --strict` 的退出码（修复过的包通过、上游坏产物失败），通过就什么都不做，因此可以无脑重复执行：

```sh
for app in "$@"; do
  /usr/bin/codesign --verify --deep --strict "$app" >/dev/null 2>&1 && continue
  /usr/bin/codesign --force --deep --sign - "$app"
  /usr/bin/xattr -dr com.apple.quarantine "$app"
done
```

`~/Library/LaunchAgents/com.hibernalglow.cask-sign-repair.plist` 的关键字段：

```xml
<key>RunAtLoad</key><true/>
<key>WatchPaths</key>
<array>
  <string>/Applications/SPlayer-Next.app</string>
  <string>/Applications/MicYou.app</string>
  <string>/Applications/Lume.app</string>
</array>
<key>StartInterval</key><integer>21600</integer>
```

`brew upgrade --cask` 会删除并重建 `.app` 目录，`WatchPaths` 因此触发；`StartInterval` 是 6 小时兜底，防止路径短暂不存在时监听被摘掉。

```sh
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.hibernalglow.cask-sign-repair.plist
launchctl print gui/$(id -u)/com.hibernalglow.cask-sign-repair    # 查看状态
sh ~/Library/Application\ Support/cask-sign-repair/repair.sh      # 手动跑一次
launchctl bootout gui/$(id -u)/com.hibernalglow.cask-sign-repair  # 卸载
```

日志写在 `~/Library/Logs/cask-sign-repair.log`。**新增带同类缺陷的 cask 时**，要把它对应的 `.app` 路径同时加进 `WatchPaths` 和脚本的 `DEFAULT_APPS` —— 两处都是硬编码的固定列表，不做全 `/Applications` 扫描（那样每次要 `--deep` 校验几十个大应用，太慢，而且会去动本 tap 之外的签名）。

## 已知注意事项

**`splayer-next` 没有设 `auto_updates true`，这是刻意的。** 上游确实带了 `electron-updater`（`app-update.yml` 指向自己的 GitHub Release），但发布的 macOS 包是 **adhoc 签名、没有 Developer ID**（`codesign -dv` 显示 `Signature=adhoc`、`TeamIdentifier=not set`）。未签名的 macOS 应用自更新不可靠，而且一旦标了 `auto_updates true`，`brew outdated` 就不再上报该 cask —— 等于把 tap 唯一的升级提醒也关掉了。所以这里让 Homebrew 作为升级渠道（`brew upgrade --cask splayer-next`）。

**`netcatty` 的签名是正常的，不需要重签名。** `codesign --verify --deep --strict` 与 `codesign -v` 都退 0，`Contents/_CodeSignature` 存在，`spctl -a` 判 `accepted / source=Notarized Developer ID`（`Developer ID Application: Qi Chen (H7WS5L2ML4)`）。所以它既不进 `caveats`，也不进 LaunchAgent 的 `WatchPaths` / `DEFAULT_APPS` 列表 —— 那个列表只收纳带缺陷的 cask。写新 cask 前先按上文验一遍签名，能提前判断要不要走修复流程。

**`netcatty` 同样没有设 `auto_updates true`，理由和 `splayer-next` 不同。** 它是签名 + 公证齐备的 Electron 应用，产物里也确实有 `app-update.yml`（`updaterCacheDirName: netcatty-updater`），但它的更新是「提示模型」：检查更新由界面里的操作触发，代码里写死 `autoInstallOnAppQuit = false`，即后台不会静默换版本。既然应用不会绕过 Homebrew 自行升级，就让 Homebrew 继续当升级渠道，`brew outdated` 才有意义。**判断依据是可执行的，不是看有没有 `electron-updater` 依赖**：查 `codesign -dv` 是否有 Developer ID，再看产物里 updater 的实际行为。

**Electron 应用的 `zap` 路径用应用名，不是 bundle id。** `netcatty` 的数据在 `~/Library/Application Support/netcatty`（`electron-updater` 的缓存在 `~/Library/Caches/netcatty-updater`）；这是 Electron 的规则 —— `userData` 取 `package.json` 的 `productName`，没有则取 `name`。Netcatty 打包后的 `package.json` 没有 `productName`，所以落成应用名 `netcatty`。对照 Tauri 应用（如同机的 `flclash`）走的是 bundle id，形如 `~/Library/Application Support/com.follow.clash`。**写 `zap` 前先确认走的是哪一套**，否则路径全错：

```sh
# 有 app.asar 就是 Electron 系
ls "/Applications/App.app/Contents/Resources/app.asar"

# Electron：取 package.json 里的 productName（没有就是 name）
npx --yes @electron/asar extract-file "/Applications/App.app/Contents/Resources/app.asar" package.json

# 最稳的验证：把应用跑一次，看它实际建了哪个目录
ls -dt ~/Library/Application\ Support/* ~/Library/Caches/* | head
```

**Homebrew 会给 cask 产物打上 quarantine。** 实测 `brew install --cask splayer-next` 之后，`/Applications/SPlayer-Next.app` 上带着 `com.apple.quarantine`，首次启动因此要走 Gatekeeper 检查；上面的修复命令顺带清掉它。另外这两个应用都是 ad-hoc 签名（无 Developer ID、未公证），`spctl -a` 会判 `rejected` —— 这是 ad-hoc 的常态，不代表不能用，前提是签名本身自洽。

**`uninstall` / `zap` 用的是安装时留存的定义。** `brew uninstall --cask --zap <name>` 读的是 `Caskroom/<name>/.metadata/<version>/<时间戳>/` 里那份 cask 定义的副本，不是 tap 里的当前文件。所以改完 `zap` 只 `brew style` 是验不到的，要先 `brew reinstall`（或 `install`）让新定义落盘，再 `uninstall --zap` 才会按新列表执行。

