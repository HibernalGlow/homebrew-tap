cask "netcatty" do
  arch arm: "arm64", intel: "x64"

  version "1.1.89"
  sha256 arm:   "76ae0bf9290ad9a8885f6dc376d9083344eb66681078efc7bd9eb76d917d9279",
         intel: "3ab93e576cc175294a63c03382b18462d52e9b6eae32c91acc538ba90922d0b0"

  url "https://github.com/binaricat/Netcatty/releases/download/v#{version}/Netcatty-#{version}-mac-#{arch}.dmg"
  name "Netcatty"
  desc "SSH and SFTP workspace with split-pane terminals"
  homepage "https://github.com/binaricat/Netcatty"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Netcatty.app"

  uninstall quit: "com.netcatty.app"

  zap trash: [
    "~/Library/Application Support/netcatty",
    "~/Library/Caches/netcatty",
    "~/Library/Caches/netcatty-updater",
    "~/Library/Preferences/com.netcatty.app.plist",
    "~/Library/Saved Application State/com.netcatty.app.savedState",
  ]
end
