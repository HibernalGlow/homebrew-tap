cask "netcatty" do
  arch arm: "arm64", intel: "x64"

  version "1.1.85"
  sha256 arm:   "45d9c124ab7279e070269f655e20699f259efdd8f438fff97dff421e85867c14",
         intel: "3b96383bc760b8add1ca643c09005d641f8e128755e277f8b979623bc6fa0323"

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
