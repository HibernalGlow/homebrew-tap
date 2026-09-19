cask "ztools" do
  arch arm: "arm64", intel: "x64"

  version "3.2.0"
  sha256 arm:   "837acc417fe02500a00d3f59f4f1c3630a5414d62c411df1bbb98a6a7913ac78",
         intel: "a382dc4deb7e6154a5fe7f005235ff05d8b85d32822d78247e0c083554a5c852"

  url "https://github.com/ZToolsCenter/ZTools/releases/download/v#{version}/ZTools-#{version}-mac-#{arch}.dmg"
  name "ZTools"
  desc "Application launcher with clipboard history and a plugin marketplace"
  homepage "https://github.com/ZToolsCenter/ZTools"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "ZTools.app"

  uninstall quit: "top.z-tools"

  # 3.x redirects Electron's `userData` to `~/.ztools` (`setPath("userData", ...)`
  # in the main entry), so plugins, clipboard history and the lmdb stores all
  # live there; `Application Support/ZTools` is the pre-3.x location left behind
  # by an upgrade. `~/.ztools` is where installed plugins end up, so `--zap`
  # removes them too.
  zap trash: [
    "~/.ztools",
    "~/Library/Application Support/ZTools",
    "~/Library/Caches/ZTools",
    "~/Library/Caches/ztools-updater",
    "~/Library/HTTPStorages/top.z-tools",
    "~/Library/Logs/ZTools",
    "~/Library/Preferences/top.z-tools.plist",
    "~/Library/Saved Application State/top.z-tools.savedState",
  ]

  caveats do
    <<~EOS
      ZTools needs Accessibility permission to respond to its global shortcuts
      and to drive keyboard / window operations; without it those shortcuts
      simply do nothing. Follow the app's first-launch prompt: System Settings
      → Privacy & Security → Accessibility → ZTools. If an upgrade left a stale
      grant record, its permission screen can reset it ("重置辅助功能权限") and
      re-authorize after a relaunch.
    EOS
  end
end
