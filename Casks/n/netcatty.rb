cask "netcatty" do
  arch arm: "arm64", intel: "x64"

  version "1.1.86"
  sha256 arm:   "5589c5d12147f151b6d6e9818791cf5cd21a0823450fbd06fa787becf6ddf839",
         intel: "6f8b70be8f8268ec08e4eed9eddb0afdadc04b573a255d0c0c40f4f259cc8122"

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
