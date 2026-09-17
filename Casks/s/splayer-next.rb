cask "splayer-next" do
  arch arm: "arm64", intel: "x64"

  version "1.1.0"
  sha256 arm:   "ebcd25f2dd79b88887b954be40245bd31afebc4ad45f917d4670ea2f6dcfe3a0",
         intel: "73d3c0ffa337f46c2ef872402296cd0970bf112d5b4679d680378a5885ad598c"

  url "https://github.com/SPlayer-Dev/SPlayer-Next/releases/download/v#{version}/SPlayer-Next-#{version}-#{arch}.dmg"
  name "SPlayer-Next"
  desc "Desktop music player with rich lyric support"
  homepage "https://github.com/SPlayer-Dev/SPlayer-Next"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "SPlayer-Next.app"

  zap trash: [
    "~/Library/Application Support/SPlayer-Next",
    "~/Library/Caches/SPlayer-Next",
    "~/Library/Caches/splayer-next-updater",
    "~/Library/Logs/SPlayer-Next",
    "~/Library/Preferences/top.imsyy.splayer-next.plist",
    "~/Library/Saved Application State/top.imsyy.splayer-next.savedState",
  ]
end
