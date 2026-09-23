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
| `lume-app` | 1.2.0 | [hugomyb/Lume](https://github.com/hugomyb/Lume) | 轻量虚拟机管理器（macOS / Linux 客户机），universal 二进制。⚠️ 装完需重签名，见「已知上游问题」 |
| `reinplayer` | 1.1.0 | [Ahurein/rein_player](https://github.com/Ahurein/rein_player) | 跨平台影音播放器（Flutter + mpv / media_kit），universal 二进制。上游 ad-hoc 签名（无 Developer ID，bundle id 仍是占位 `com.example.reinPlayer`）；Homebrew 会给产物打 quarantine、首次启动会被 Gatekeeper 拦「无法验证的开发者」，按 Caveats 清 quarantine 即可，见「已知注意事项 → reinplayer」 |
| `ztools` | 3.2.0 | [ZToolsCenter/ZTools](https://github.com/ZToolsCenter/ZTools) | 应用启动器 + 插件平台（类 uTools，Electron 41），arm64 / intel 双架构，需 macOS ≥ 12。签名与公证正常，装完即用；全局快捷键要单独授「辅助功能」权限 |
| `clipp` | 1.5.0.160 | [martona/clipp](https://github.com/martona/clipp) | 局域网 P2P 剪贴板同步（文本 / 图片），同一个二进制兼作 `clipp copy` / `paste` CLI。**仅 arm64**，需 macOS ≥ 14。签名与公证正常，装完即用。上游自己有 tap（`martona/tap`），本 tap 这份补了 `quit` 和寄存器快照的 `zap` 路径，理由见「已知注意事项 → clipp」 |
| `my-window-pip` | 0.1.7 | [ljzxzxl/my-window-pip](https://github.com/ljzxzxl/my-window-pip) | 任意窗口 / 屏幕区域画中画置顶浮窗（ScreenCaptureKit，通用二进制，CPU 近零），需 macOS ≥ 14，必需「屏幕录制」权限。⚠️ 自签证书、未经 Apple 公证，首启会被 Gatekeeper 拦「无法验证的开发者」，按 Caveats 清 quarantine，见「已知注意事项 → my-window-pip」 |
| `jhentai` | 8.0.16+334 | [jiangtian616/JHenTai](https://github.com/jiangtian616/JHenTai) | E-Hentai / ExHentai 漫画客户端（Flutter），通用二进制，下载与本地书库齐全。**上游标明 macOS 构建「无维护」**。⚠️ ad-hoc 签名、未公证，首启被 Gatekeeper 拦；且它是沙箱应用，数据全在容器里，`zap` 只清可再生的部分，见「已知注意事项 → jhentai」 |
| `nigate` | 1.4.5 | [hoochanlon/Free-NTFS-for-Mac](https://github.com/hoochanlon/Free-NTFS-for-Mac) | NTFS 读写挂载管理器（Electron），arm64 / intel 双架构。⚠️ 装完必须重签名（与 `splayer-next` 同族）；它的「一键装依赖」会用管理员权限从 CDN 拉脚本装 / **删 macFUSE**，本机已有 macFUSE / ntfs-3g 方案的先看「已知注意事项 → nigate」再按那两个按钮 |
| `rawviewer` | 0.1.1 | [stmtc233/RawViewer](https://github.com/stmtc233/RawViewer) | RAW 照片浏览器（Flutter + LibRaw），通用二进制，需 macOS ≥ 12。⚠️ ad-hoc 签名、未公证，首启被 Gatekeeper 拦；沙箱应用且 bundle id 还是 Flutter 占位 `com.example.rawviewer`，见「已知注意事项 → rawviewer」 |
| `folia` | 0.7.7 | [chthollyphile/folia-major](https://github.com/chthollyphile/folia-major) | 本地 / Navidrome 音乐播放器，主打歌词动画（Electron），arm64 / intel 双架构，需 macOS ≥ 12。⚠️ 装完必须重签名（与 `micyou` 同族）；**应用内那个「自动更新」别开**，见「已知注意事项 → folia」 |
| `arcthumb` | 0.12.0 | [HibernalGlow/ArcThumbX](https://github.com/HibernalGlow/ArcThumbX) | 压缩包 / 电子书封面的 Quick Look 缩略图扩展（Rust + Slint），arm64 / intel 双包，同一个二进制兼作 CLI（`arcthumb --get` / `--regenerate`）。⚠️ ad-hoc 签名、未公证，首启要清 quarantine；**光装不生效**，还要用 `pluginkit` 注册并启用，见「已知注意事项 → arcthumb」
| `status-trio` | 1.3.1 | [lingyired/status-trio](https://github.com/lingyired/status-trio) | 把 Wi-Fi / 电池 / 音量合成一个菜单栏（或程序坞）图标的原生 Swift 应用，通用二进制，需 macOS ≥ 15。⚠️ ad-hoc 签名、未公证，首启要清 quarantine；**本 tap 第一个设 `auto_updates` 的 cask**，理由见「已知注意事项 → status-trio」
| `font-lxgw-wenkai-screen` | 1.522 | [lxgw/LxgwWenKai-Screen](https://github.com/lxgw/LxgwWenKai-Screen) | 霞鹜文楷屏幕阅读版，半陆标字形，Roboto 打底补字 |
| `font-lxgw-wenkai-gb-screen` | 1.522 | 同上 | 屏幕阅读版 GB 版，**陆标（简体）字形 —— 简体用户装这个** |
| `font-lxgw-wenkai-mono-screen` | 1.522 | 同上 | 等宽屏幕阅读版，Inconsolata 打底补字 |
| `font-lxgw-wenkai-mono-gb-screen` | 1.522 | 同上 | 等宽屏幕阅读版 GB 版 |

> `micyou` / `splayer-next` / `lume-app` / `nigate` / `folia` 装完**必须重签名才能启动**（上游打包缺陷，不是安装出错）。命令见下文「已知上游问题 → 签名不一致」。`brew info --cask <name>` 的 Caveats 段里也会打出来；机器上已配了 LaunchAgent 自动做这件事，见「签名不一致 → 自动修复」。


> 屏幕阅读版与主版「霞鹜文楷」的区别：字重由 Medium 改为 Regular 并调整度量数据，PC / 手机屏幕上更清晰。上游只提供裸 `.ttf`（没有压缩包），所以 4 个变体各自一个 cask —— 一个 cask 只能带一组 `url` / `sha256`。只想要其中一个的话装对应的即可。

## 目录结构

```
.
├── Casks/
│   ├── a/
│   │   └── arcthumb.rb
│   ├── c/
│   │   └── clipp.rb
│   ├── f/
│   │   ├── folia.rb
│   │   └── font-lxgw-wenkai-*.rb   # 4 个字体变体各一个 cask
│   ├── j/
│   │   └── jhentai.rb
│   ├── l/
│   │   └── lume-app.rb
│   ├── m/
│   │   ├── micyou.rb
│   │   └── my-window-pip.rb
│   ├── n/
│   │   ├── netcatty.rb
│   │   └── nigate.rb
│   ├── r/
│   │   ├── rawviewer.rb
│   │   └── reinplayer.rb
│   ├── s/
│   │   ├── splayer-next.rb
│   │   └── status-trio.rb
│   └── z/
│       └── ztools.rb           # 按 token 首字母分子目录（对齐 homebrew/cask 布局）
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
- `depends_on macos:` **别照抄 `Info.plist` 的 `LSMinimumSystemVersion`** —— Tauri / Electron 常统一写 `10.13`，不代表真实下限。以二进制为准：`otool -l <exe> | grep -A5 LC_BUILD_VERSION` 里的 `minos`（例：MicYou 的 plist 写 10.13，实际 `minos 11.0`）。但**低于 Homebrew 自身支持下限的版本号写了也白写**：`depends_on macos: :catalina` / `:big_sur` 会被 `Homebrew/OSDependsOn` 判 redundant minimum、`brew style` 直接红，这种就改写成 `depends_on :macos`（`micyou` / `jhentai` / `nigate` 都是这样；别为了凑一个版本号去写更低的系统支持）
- `desc` 不重复包名、结尾不加句号、不超过 80 字符，**也不要出现平台名**（写了 `macOS` 会被 `Cask/Desc` 判 `Description shouldn't contain the platform`）
- **不要写 `verified:`** —— Homebrew 已废弃该参数，写了会持续报 deprecation 警告
- **签名判定别只看 `spctl -a`**：本机 Gatekeeper 评估是关着的（`spctl --status` → `assessments disabled`），任何包都回 `accepted`。要读 `codesign -dvvv` 的 `Authority` / `TeamIdentifier`，并在 `spctl -a -vvv` 里确认出现 `source=Notarized Developer ID`。分三类：签名自洽 + 公证（netcatty / ztools / clipp，装完即用）、自洽但没有 Developer ID（reinplayer / jhentai / arcthumb 是 ad-hoc，my-window-pip 是自签证书，quarantine + 无 Developer ID → 首启被拦，给清 quarantine 的 Caveats）、声明有资源却没有 `_CodeSignature`（micyou / splayer-next / lume-app / nigate / folia，判「已损坏」，必须重签）
- `zap trash:` 只列应用自己产生的数据；用户的下载内容 / 音乐库不要列入（`--zap` 会真删）
- **`zap` 要「启动 + 退出」之后才算验过**：`Caches/<bundle id>`、`HTTPStorages/<bundle id>` 这类常常是**退出时**才建的（my-window-pip 就是启动时看不见、退出后才出现）；反过来，被重定向走的 profile 会让某些标准路径**永远不出现**（ztools 把 Electron 的 userData 挪到 `~/.ztools`，于是 `~/Library/Caches/ZTools` 不存在）。目录名也别说成 bundle id 的定值：jhentai 的缓存叫 `Caches/JHenTai` / `Caches/cacheimage`。验完把「实测存在」和「按上游声明保留」两类在注释里分开写
- **装上不等于生效的那类（扩展 / 驱动）只写 Caveats**：需要 `pluginkit -a` / `-e use`、`systemextensionsctl` 之类激活的 cask，把命令原样放进 Caveats 并给出「谁在供这个功能」的查法（`arcthumb` 的实测教训：旧路径的注册会盖住新装的这份），不要为了省事改成 `postflight`
- **先判沙箱再写 `zap`**：`codesign -d --entitlements :- <app>` 里有 `com.apple.security.app-sandbox` 的话，`~/Library/...` 全部要换成 `~/Library/Containers/<bundle id>/Data/Library/...` 前缀。沙箱应用常常把用户内容也放进容器里的 `Documents`（Flutter + `path_provider` 就是这样，见「已知注意事项 → jhentai」），这时**不要整容器列入**，只列可再生项，把「连书库一起清」留成 Caveats 里给用户的命令
- **sha256 尽量找第二来源**：上游若随包发校验文件（`SHA256SUMS.txt`、`<artifact>.sha256`），拿它对一遍再写进 cask，别只靠自己下载算一次 —— 那是单一来源，撞上上游原地重传就无声了。**上游不发的也没关系：GitHub 自己为每个 asset 存了 sha256**，`gh api repos/<owner>/<repo>/releases/latest --jq '.assets[] | .name + " " + (.digest // "no-digest")'` 直接给（值带 `sha256:` 前缀；clipp / rawviewer 实测对得上）。注意它只证明「这个 URL 拿到的字节就是 GitHub 上挂的那个 asset」，不能替上游发布环节背书；两处都拿不到的（如 JHenTai）就照实说明只有一个来源
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

**大产物反复下不完时，可以直接喂 Homebrew 的下载缓存**（`folia` 的 172 MB 包今天被 GitHub 掐断三次：`curl` 报 exit 18，`brew install` 两次 `Download failed`）。文件名规则是 `$(brew --cache)/downloads/<sha256(URL)>--<产物名>` —— 注意是 **`downloads/` 子目录**，放 cache 根目录 Homebrew 不认（会当没缓存、继续重下）：

```sh
U=https://…/Folia-0.7.7-arm64.dmg
K=$(printf '%s' "$U" | shasum -a 256 | cut -d' ' -f1)
curl -sSL -C - --retry 8 --retry-all-errors -o /tmp/x.dmg "$U"   # 断点续传先把包拿全
mkdir -p "$(brew --cache)/downloads"
cp /tmp/x.dmg "$(brew --cache)/downloads/${K}--Folia-0.7.7-arm64.dmg"
brew install --cask hibernalglow/tap/folia                       # 仍然会按 cask 的 sha256 校验
```

拿全文件后先跟 GitHub 的 asset digest 对一次再放进去，别拿一个没校验过的半截文件污染缓存。

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

**tag 带 `+build` 后缀时，`strategy :github_latest` 会自己把后缀吃掉。** JHenTai 的 tag 是 `v8.0.16+334`、产物叫 `JHenTai-8.0.16+334.dmg`，但 `github_latest` 走的是 `GithubReleases::DEFAULT_REGEX`（`v?(\d+(?:\.\d+)+)`），到 `+` 就停，于是 livecheck 报 `8.0.16`。cask 里若照 tag 写全 `version "8.0.16+334"`，`brew audit` 直接失败：

```text
Version '8.0.16+334' differs from '8.0.16' retrieved by livecheck.
```

URL 又必须带后缀才拼得出产物，所以别把 `version` 缩成 `8.0.16`（那样 autobump 会把 URL 拼坏）。给 livecheck 自己那条正则，把整段 tag 抓回来：

```ruby
livecheck do
  url :url
  regex(/v(\d+(?:\.\d+)+\+\d+)/)
  strategy :github_latest
end
```

改完要两头验：`brew livecheck --cask <name>` 在版本号正确时报等值（`8.0.16+334 ==> 8.0.16+334`），把 `version` 临时改成上一个发布（`8.0.15+333`）时要报出升级（`==> 8.0.16+334`）—— 只验前者不够，等值可能只是「两边都被截断成同一个数」。`Version` 认 `+` 为修订号，所以 `8.0.16+333 < 8.0.16+334` 的比较是对的。

## 已知上游问题

### 签名不一致：`splayer-next` / `micyou` / `lume-app` / `nigate` / `folia` 装完必须重签名

这几个应用带的是**同一类上游打包缺陷**：可执行文件是链接期 ad-hoc 签名（`codesign -dv` 显示 `Signature=adhoc` + `flags=0x2(adhoc,linker-signed)`；`nigate` 是同一件事，只是多了 hardened runtime 位 `0x20002`），签名声明了「有密封资源」，但 `.app` 包体从未生成 `Contents/_CodeSignature`。macOS 读到这个自相矛盾就判定为损坏：

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
  <string>/Applications/Nigate.app</string>
  <string>/Applications/Folia.app</string>
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

**`ztools` 的签名也是正常的，`auto_updates` 同样按上面这条判断没设。** `spctl -a` 判 `accepted / source=Notarized Developer ID`（`Developer ID Application: Zhengzhou Zhongsen Yunke Information Technology Co., Ltd. (4S4HH8375U)`），`codesign --verify --deep --strict` 退 0，所以不进 Caveats 的修复流程、也不进 LaunchAgent 列表。updater 是 `electron-updater` 6.8.9（`updaterCacheDirName: ztools-updater`），但代码里 `autoDownload = false` 且 `autoInstallOnAppQuit = false` —— 和 netcatty 一样的「提示模型」，因此升级渠道留给 Homebrew。`depends_on macos: :monterey` 取自二进制的 `LC_BUILD_VERSION`（`minos 12.0`），与 `Info.plist` 的 `LSMinimumSystemVersion` 恰好一致。Caveats 里只有辅助功能权限这一条：它靠 `uiohook-napi` 监听全局快捷键，未授权时快捷键没有反应（上游文案原话是「需要辅助功能权限来响应快捷键并完成键盘与窗口操作」）。应用自己有引导页，也有「重置辅助功能权限」入口，用于升级后 macOS 留着过期授权记录的情况。

**`clipp` 的两点特殊性。** 一是**上游自己就发 cask**（README 里写 `brew install martona/tap/clipp`），本 tap 仍收一份：token 各自独立、装了互不冲突，代价只是多一份被 autobump / CI 跟踪的对象，换的是「一个 tap 装齐」的顺手 —— 但要清楚这是在替上游维护，上游那份少列了 `~/Library/Application Support/net.clipp.ios`（`keyvend.sock` 所在，实测启动后就有）与 `~/Library/Application Support/Clipp`（`DataPaths.mm` 定死的加密寄存器快照，装好组之后才出现），也少了 `uninstall quit:`（菜单栏应用）。抄上游文件前先跑 `brew style`：它的 `homepage "https://clipp.net"` 会被 `Cask/HomepageUrlStyling` 判 offense（域名后必须带 `/`）。二是**产物名里没有版本号**（`clipp-macos-arm64.zip`，上游 README 明说链接永远指向最新），看着违反上面「产物文件名带版本号」的前提，其实没有：URL 把版本放在 release tag 那一段（`download/v#{version}/…`），`strategy :github_latest` 读的也是 tag 而非文件名，livecheck / autobump 照常工作。`version` 因此取 tag 的四段式 `1.5.0.160`（= `CFBundleVersion`），不是 `CFBundleShortVersionString` 的 `1.5.0`。残余风险只有一个：上游原地重传同 tag 产物时 sha 会变而版本号不动 —— 该项目每个产物都有 Sigstore attestation，且 `SHA256SUMS.txt` 与 cask 里的 sha 实测对得上。macOS 14 是上游的测试口径而非功能需求（脚注原话「The 14 floor is arbitrary; I just don't have older Macs」），`LSMinimumSystemVersion` 与二进制 `minos` 都写 14.0，所以 `depends_on macos: :sonoma` 照 14 报，别猜更低。

**`my-window-pip` 属于 reinplayer 那一类：签名自洽，但没公证。** `codesign -dvvv` 给的是 `Authority=MyWindowPip Release Signing`、`TeamIdentifier=not set`、`flags=0x0(none)` —— 上游 README 自己写明是**自签证书、未经 Apple 公证**。但 `Contents/_CodeSignature` 在、`codesign --verify --deep --strict` 退 0，所以它不是「损坏」，macOS 报的是「无法验证的开发者」而不是「已损坏」；同理它的判定门能过，**不进 LaunchAgent 的 `WatchPaths` / `DEFAULT_APPS`**（那里只收必须重签的坏包），Caveats 给的是清 quarantine（或右键 → 打开 一次）。另外它必需的「屏幕录制」授权按**固定路径 + 固定签名身份**存活，cask 装进 `appdir` 正好对上，上游那句「别从 DMG / 下载目录直接跑」正是这个原因。

> **别拿本机的 `spctl -a` 当公证证据。** 这台机器 `spctl --status` 是 `assessments disabled`，所以任何包都会回 `accepted` —— my-window-pip 就是这样，`accepted` 但 `origin=` 后面跟的是自签身份、**没有** `source=Notarized Developer ID` 那一行。判断顺序应该是：先 `codesign -dvvv` 读 `Authority` / `TeamIdentifier`，再看 `spctl -a -vvv` 有没有 `source=Notarized Developer ID`；只有后者出现才谈得上公证，netcatty / ztools 那份 accepted 才是真证据。

**`my-window-pip` 也没设 `auto_updates`，这次是读了实现才确定的。** `Sources/my-window-pip/Updater.swift` 是手写的（`URLSession` + `CryptoKit` 校验上游随包发的 `.dmg.sha256`，无第三方依赖）：`checkSilently` 启动时只查询、回调里也只弹提示，下载要点「下载并安装」才开始，下完**打开挂载好的安装窗，由用户自己把 app 拖进 Applications** —— 典型的提示模型，后台不会静默换版本，所以升级渠道留给 Homebrew。`zap` 那四条的依据：应用自己写的只有 `Preferences.swift`（`UserDefaults.standard` 封装）和 `Log.swift`（`~/Library/Logs/MyWindowPip/MyWindowPip.log`，2 MB 滚动），`Caches` / `HTTPStorages` 两条是系统替它建的，四条都在**启动 + 退出**之后实测存在；上游 README 亦称捕获帧只在内存与显存、正常路径一个字都不写，所以这里没有任何用户内容。

**`jhentai` 是沙箱应用，`zap` 的写法因此和别的都不一样。** `codesign -d --entitlements :- <app>` 里有 `com.apple.security.app-sandbox`（**判断沙箱只认这个，别猜**），于是 Flutter 的 `path_provider` 拿到的都是容器内路径：一切都落在 `~/Library/Containers/top.jtmonster.jhentai/Data/`。更要紧的是 `PathService.getVisibleDir()` 在 macOS 上返回 `getApplicationDocumentsDirectory()`，而 `path_provider_foundation` 只对 Application Support / Caches 追加 bundle id 子目录、**Documents 不追加**（见其 `_getDirectoryPath`）—— 所以 `db.sqlite`（书库）、`jhentai.gs`（设置）、`logs/`、`download/`（下载的作品）是平铺在 `Data/Documents/` 里的。整容器删就等于删用户下载，违反「`--zap` 不碰用户内容」这条（同 `lume-app` 不列 VM 镜像），所以这里只列可再生项，连登录态一起清的口子留给用户自己（Caveats 里给了容器目录）。以上跑过真机：启动 + 退出后 `Data/Documents/` 里确实是 `jhentai.gs` / `jhentai.bak` / `jhentai.version` / `db.sqlite` / `logs` / `download` / `local_gallery` / `save` 平铺；`Data/Library/Preferences/` 下**没有**应用自己的 plist（设置不走 UserDefaults），图片缓存则在 `Data/Library/Caches/` 下叫 `JHenTai` / `cacheimage` / `flutter_engine` / `WebKit` —— **容器里的缓存目录名不一定等于 bundle id**，照 bundle id 猜会全部落空。另外上游 README 把 macOS / Linux 构建标成 **No maintenance**，autobump 提的升级 PR 要额外留意：新版本可能压根没人在 mac 上验过。

`jhentai` 的签名与 `reinplayer` 同类（`Signature=adhoc`、`TeamIdentifier=not set`，还带 `com.apple.security.get-task-allow`，这条本身就与公证冲突），Caveats 给清 quarantine，不进 LaunchAgent 列表。两点附带提醒：它的 tag 带 `+334` 这种构建号，livecheck 要按上文「tag 带 `+build` 后缀」那条补正则，否则 `brew audit` 会因版本号被截断而失败；`depends_on` 也别照二进制直写 —— 两片 minos 不同（x86_64 `10.15`、arm64 `11.0`），写 `depends_on macos: :catalina` 会被 `Homebrew/OSDependsOn` 判 redundant minimum 让 `brew style` 变红，正确写法就是 `depends_on :macos`。

**Electron 应用的 `zap` 路径用应用名，不是 bundle id。** `netcatty` 的数据在 `~/Library/Application Support/netcatty`（`electron-updater` 的缓存在 `~/Library/Caches/netcatty-updater`）；这是 Electron 的规则 —— `userData` 取 `package.json` 的 `productName`，没有则取 `name`。Netcatty 打包后的 `package.json` 没有 `productName`，所以落成应用名 `netcatty`。对照 Tauri 应用（如同机的 `flclash`）走的是 bundle id，形如 `~/Library/Application Support/com.follow.clash`。**写 `zap` 前先确认走的是哪一套**，否则路径全错：

```sh
# 有 app.asar 就是 Electron 系
ls "/Applications/App.app/Contents/Resources/app.asar"

# Electron：取 package.json 里的 productName（没有就是 name）
npx --yes @electron/asar extract-file "/Applications/App.app/Contents/Resources/app.asar" package.json

# 最稳的验证：把应用跑一次，看它实际建了哪个目录
ls -dt ~/Library/Application\ Support/* ~/Library/Caches/* | head
```

**上面这条规则只对「没改过 `userData`」的 Electron 应用成立。** `ztools` 就是反例：主进程入口一启动就调 `app.setPath("userData", ~/.ztools)`（可用 `ZTOOLS_DATA_ROOT` 覆盖），Chromium 的整套 profile、插件、剪贴板历史、lmdb 索引全落在家目录那个隐藏文件夹里，所以 `~/Library/Caches/ZTools` 这类路径**根本不会出现**（启动并退出后实测：不存在）。`~/Library/Application Support/ZTools` 会建，但是个空目录 —— 那是 Electron 在重定向生效前先算默认路径时留下的，不是老版本升级遗留（本 tap 早先的判断，实测后改掉）。判断方法：在 `app.asar` 里搜 `setPath("userData"`，命中就不能照抄应用名。

> 代价是 `brew uninstall --cask --zap ztools` 会连用户自己装的插件（`~/.ztools/plugins`）和剪贴板历史一起删 —— 这符合 `--zap` 的语义，但想保住插件就别加 `--zap`。同一类取舍的另一个方向见 `lume-app`：那里刻意没把用户的 VM 镜像列进 `zap`。

**Homebrew 会给 cask 产物打上 quarantine.** 实测 `brew install --cask splayer-next` 之后，`/Applications/SPlayer-Next.app` 上带着 `com.apple.quarantine`，首次启动因此要走 Gatekeeper 检查；上面的修复命令顺带清掉它。另外这两个应用都是 ad-hoc 签名（无 Developer ID、未公证），`spctl -a` 会判 `rejected` —— 这是 ad-hoc 的常态，不代表不能用，前提是签名本身自洽。

**`reinplayer` 是 ad-hoc 签名，但签名本身自洽，不算「损坏」类缺陷。** 它是 Flutter 应用（带 FlutterMacOS / media_kit / mpv 等 30+ 框架），`codesign -v` 与 `codesign --verify --deep --strict` 都对全包退 0、`Contents/_CodeSignature` 存在 —— 但它**不进 LaunchAgent 的 `WatchPaths` / `DEFAULT_APPS`**（那个列表只收「启动前必须重签」的坏签名 cask），因为 LaunchAgent 的判定门是 `codesign --verify --deep --strict`、而 reinplayer 这个门能过，修了也修不到 quarantine。真正的坑有两层：上游 `CFBundleIdentifier` 没改、停留在占位 `com.example.reinPlayer`；且整体 ad-hoc（无 Developer ID、未公证），而 Homebrew 装完会给 `.app` 打上 `com.apple.quarantine`（实测 `/Applications/rein_player.app` 装完确实带着）。quarantine + 无 Developer ID → 首次启动被 Gatekeeper 拦「无法验证的开发者」。Caveats 里给了 `xattr -dr com.apple.quarantine` 清隔离属性（或更省事：右键 → 打开 一次加入用户豁免；需要的话再 `codesign --force --deep --sign -` 重签），不设 `auto_updates`（ad-hoc 自更新不可靠，让 Homebrew 当升级渠道）。

**`nigate` 属于「启动前必须重签」那一族**（micyou / splayer-next / lume-app）：可执行文件是 `flags=0x20002(adhoc,linker-signed)`，签名声明有密封资源，包里却没有 `Contents/_CodeSignature`，`codesign --verify` 直接报 `code has no resources but signature indicates they must be present`。`/Applications/Nigate.app` 已经同时加进 LaunchAgent 的 `WatchPaths` 和脚本的 `DEFAULT_APPS`，`repair.sh` 对它实测有效（重签后 `--verify --deep --strict` 退 0、quarantine 清掉）。另外它的 bundle id 是 `io.hoochanlon.github`（和 reinplayer 那个占位 id 一个味道），Electron 的 profile 目录用 `package.json` 的 `free-ntfs-for-mac`（没有 `productName`）—— 注意**整套 Chromium 状态都在这个目录里**（`Cache` / `Code Cache` / `Cookies` / `Local Storage` / 它自己的 `Preferences` 都在下面），所以 `~/Library/Caches/free-ntfs-for-mac`、`~/Library/Logs/...`、`~/Library/Preferences/io.hoochanlon.github.plist`、savedState 一个都不会生成（两次启动 + 正常退出实测皆无），`zap` 因此只有两条；第二条 `Caches/free-ntfs-for-mac-updater` 是包内 `app-update.yml` 的 `updaterCacheDirName` 声明的，要等更新器真下载东西才出现，与 `ztools` 同理保留。两片 minos 也不同（arm64 `11.0`、x86_64 `10.15`，`LSMinimumSystemVersion` 写 10.15）—— 都低于 Homebrew 自己支持的下限，所以 `depends_on macos: :big_sur` 和 `:catalina` 都会被判 redundant，只能写 `depends_on :macos`。

**`nigate` 的依赖是系统级的，这点和别的 cask 不是一回事。** NTFS 读写不来自它本体，而是 macFUSE + ntfs-3g：它的「一键安装 / 卸载依赖」是在打包进来的 `node-pty` 终端里跑 jsdelivr 上的 `ninja/kunai.sh` / `ninja/ninpo.sh`（`curl | bash`），要管理员权限。两件事要注意 —— 一是 **`ninpo.sh` 会把 macFUSE 从系统里摘掉**，本机那条 SwiftBar + ntfs-3g 的路线还依赖 macFUSE，别顺手点卸载；二是 Apple Silicon 上装 macFUSE 还要进 Recovery 改安全策略。也就是说 cask 只解决「app 本体 + 重签名」，驱动那一层是它自己在跑脚本装。上游也不随包发校验文件，两个架构的 sha 只有各自下载实测这一个来源（Intel 包已确认是 x86_64 thin、同为 1.4.5）。最后：v1.4.5 发布于 2026-01-23，上游 README 让人去 `/tags` 下载，但 `releases/latest` 指的就是它，livecheck 与 autobump 不受影响。

**`rawviewer` 把「沙箱里缓存目录名不等于 bundle id」这条推到了极端：全程只留下两个路径。** 容器 `~/Library/Containers/com.example.rawviewer/` 在启动时创建；从启动 → 打开一张图 → 正常退出一路看着，`Data/Library/Caches/` 里只有 `flutter_engine`，`Data/Library/Preferences/com.example.rawviewer.plist` 真实写入（`shared_preferences` 的 `flutter.*` 键）—— 而 `path_provider` 虽然挂在依赖里，`Caches/<bundle id>` 和 `Application Support/<bundle id>` **一次都没出现**，HTTPStorages / WebKit / saved state 也没有。所以 `zap` 只有两条，比按惯例写的五条少三条 —— 多出来的那三条正是 jhentai 那轮被实测推翻的同一种形状。顺带一条隐私向的观察：plist 里 `flutter.recent_open_items` 存的是**用户照片的真实完整路径**（还有 `NSNavLastRootDirectory`），`--zap` 会把它一起清掉。

上游缺陷与判定：bundle id 停在 Flutter 占位值 `com.example.rawviewer`（和 `reinplayer` 的 `com.example.reinPlayer` 同一类），容器目录与文件关联全挂在它上面，值得去开 issue；签名是 ad-hoc、未公证，但 `Contents/_CodeSignature` 在、`--verify --deep --strict` 退 0 → 属清 quarantine 那一类，**不进** LaunchAgent 列表。`auto_updates` 没设的依据：`lib/core/update_checker.dart` 只 `GET api.github.com/repos/stmtc233/rawviewer/releases/latest`（10 秒超时，fetcher 可注入便于测试），整个文件没有下载 / 安装 / `Process` 调用 —— 连提示模型都算不上，只是告知有新版本。

**`folia` 是「上游根本没打算签名」的典型。** 三个 mac workflow 全设 `CSC_IDENTITY_AUTO_DISCOVERY: false`（连找身份都不找），产物就是 linker-signed ad-hoc + 没有 `Contents/_CodeSignature`，`codesign --verify --deep --strict` 报 `code has no resources but signature indicates they must be present` —— 与 micyou / lume-app 同族，`/Applications/Folia.app` 已加进 LaunchAgent 的 `WatchPaths` 与 `DEFAULT_APPS`。上游自己有一篇 `docs/desktop/macos-app-damaged.md`，给的三招是右键打开 / 「仍要打开」/ 清 quarantine，但那台机器上 Gatekeeper 是关着的，**「只清隔离属性够不够」在这边复现不了**，所以按本仓口径仍归到必须重签那一类。`zap` 三条是看着进程验过的：`Application Support/Folia` 里是整套 Chromium profile（`Cache` / `Cookies` / `Local Storage` / `IndexedDB` / 自己的 `Preferences`），而 `Caches/Folia`、`Logs/Folia`、`HTTPStorages/<bundle id>`、saved state 从启动到正常退出全没出现；`Caches/folia-major-updater` 是包内 `app-update.yml` 声明的 `updaterCacheDirName`，只有更新器真下载才会出现，照 `ztools` 的先例保留。注意 `--zap` 会把本地音乐库的索引清掉（存的是曲目路径，音乐文件本身不动）。

`auto_updates` 依旧没设，两层理由：`electron/main.cjs` 里 `autoDownload = false`、`autoInstallOnAppQuit = false`、应用内自动更新是 `ENABLE_AUTO_UPDATE_SETTING_KEY` 的 opt-in、`quitAndInstall` 由界面点出来 —— 形态上是 netcatty 那种提示模型；而**真把那个开关打开也不会成功**：Squirrel.Mac 靠签名一致性装更新，ad-hoc 包不满足，所以 Caveats 里直接写「别开应用内更新，升级走 brew」。发布通道这块是本仓第一种「latest 与 prerelease 混排」的形状：稳定版是 `v0.7.7` 这种 semver tag，而 `limo` / `cielo` / `cielo-wip-…` 全是 **prerelease**（nightly / canary，各自带 `beta.yml` / `alpha.yml`），`strategy :github_latest` 只认非 prerelease 的 latest，所以 autobump 不会被 nightly 带走 —— 与「tag 不带版本号」那类问题不同，不用加 `regex`。

**`arcthumb` 是本仓第一个「装上 ≠ 生效」的 cask。** 它是 Quick Look 缩略图扩展（`com.apple.quicklook.thumbnail`），扩展必须被注册并启用才会出现在 Finder 里：上游自己的 `macos/README.md` 就写明 `lsregister` 单独用不够，要 `pluginkit -a <appex>` + `pluginkit -e use -i com.citrussoda.ArcThumb.thumbnail` + `qlmanage -r cache`。这两条**只进 Caveats**，不做成 `postflight` —— 理由就是上面「不要用 install steps 给上游打补丁」那节（沙箱套不上时会把刚解包的 app 删掉）。实测还抓到一个真实坑：**Quick Look 的注册是按路径记的**，这台机器上留有一条指向 `~/Applications/ArcThumb.app` 的 0.11.0 旧注册（`+` = 已启用），于是新装进 `/Applications` 的 0.12.0 看起来完全没作用；只有 `pluginkit -m -v -i <id>` 能看出是谁在供缩略图。查法与 `pluginkit -r` 的解法已写进 Caveats（本次没替机器清旧注册，那是开发者自己的工作副本）。

数据面与校验：扩展是沙箱的，设置**只写一个文件** —— `~/Library/Containers/com.citrussoda.ArcThumb.thumbnail/Data/Library/Application Support/ArcThumb/settings`，上游明确说不用 `UserDefaults`（非沙箱的 helper 写不进沙箱的偏好域），实测 `~/Library/Preferences/com.citrussoda.ArcThumb.plist` 与 `~/Library/Application Support/ArcThumb` 都不存在，所以 `zap` 就容器那一条，和上游 uninstall 里的 `rm -rf` 完全一致。两个架构各做了**三重对照**：上游随包发的 `.sha256` + GitHub asset digest + 本地 `shasum` 全等，且分别挂包核对内层 Mach-O 是 arm64 / x86_64 thin、两片 `minos` 都是 11.0 并与 `LSMinimumSystemVersion` 一致 —— 11.0 恰好等于 Homebrew 自己的支持下限，于是 `depends_on macos: :big_sur` 会被判 redundant、`audit_min_os` 也提前返回，这里就写 `depends_on :macos`。签名是 ad-hoc 但自洽（app 与 appex 的 `--verify --deep --strict` 都退 0），属清 quarantine 那一类，不进 LaunchAgent 列表。`homepage` 暂用仓库地址：产品页 `https://citrussoda.com/en/arcthumb` 从本机 TLS 直接 `SSL_ERROR_SYSCALL`，`brew audit --online` 会因为不可达失败；等接入 Developer ID + 公证（仓库有 `MACOS_SIGN_IDENTITY` 这个开关，没设）之后可以换回去。

**`status-trio` 是本 tap 第一个写 `auto_updates true` 的 cask，判据要跟前面几条对齐清楚。** 前面 netcatty / ztools / clipp 都**没**设，依据是「应用不会绕过 Homebrew 把自己换掉」：它们的 `electron-updater` 都是 `autoDownload = false` + `autoInstallOnAppQuit = false`，走到最后一步是把挂载好的安装窗丢给你、由人拖进 `/Applications`，等同手动安装。Status Trio 不一样，它带的是完整 Sparkle 2（`SUFeedURL` 指向仓库里的 `appcast.xml`、`SUPublicEDKey` 有值、`SUEnableInstallerLauncherService` 开着），用户在更新窗点一下 Install Update 就是**原地替换 bundle**：那时 tap 里的 `version` 还指着旧号，`brew outdated` 会一直报一个已经装不存在的升级。所以判据是同一句 —— **会不会自己换掉 bundle** —— 只是这里的答案是「会」，于是设标记、并在 Caveats 里写清副作用：设了 `auto_updates` 之后 brew 不再提醒升级，应用自己升过一轮后要跑 `brew upgrade --cask status-trio` 把元数据对齐，或者干脆在设置里关掉更新检查。

其余都按老规矩验过：两片 `minos` 都是 15.0、与 `LSMinimumSystemVersion` 一致（`depends_on macos: :sequoia`，`audit_min_os` 不会挑刺）；sha256 三重对照（上游随包发的 `.dmg.sha256` + GitHub asset digest + 本地 `shasum`）；签名 ad-hoc 但自洽（`_CodeSignature` 在、strict verify 退 0）→ 清 quarantine 那一类，不进 LaunchAgent。`zap` 两条是**启动 + 退出之后**才成立的：运行期间 `~/Library/Preferences/` 一个文件都不出现（cfprefsd 攒着），退出才落 `com.lingsmbp.StatusTrio.plist`，里面同时有应用设置和 Sparkle 的 `SUHasLaunchedBefore` —— 也就是说 **Sparkle 的偏好写在应用自己的域里**，我先前按惯例加的 `org.sparkle-project.Sparkle.plist` 是个不存在的猜测，已删。上游文档另外给了两条边界值得记：它不读也不存 Wi-Fi 密码（macOS 没有用已存密码连接的公开 API），也不为「立即充满」写 SMC 或塞特权 helper。

**`uninstall` / `zap` 用的是安装时留存的定义。** `brew uninstall --cask --zap <name>` 读的是 `Caskroom/<name>/.metadata/<version>/<时间戳>/` 里那份 cask 定义的副本，不是 tap 里的当前文件。所以改完 `zap` 只 `brew style` 是验不到的，要先 `brew reinstall`（或 `install`）让新定义落盘，再 `uninstall --zap` 才会按新列表执行。

