cask "micyou" do
  version "2.0.3"
  sha256 "4ae817abd9e55a258ea5468e0dbb2c5cfd300081805231c93a83f03dcccfe8ba"

  url "https://github.com/LanRhyme/MicYou/releases/download/v#{version}/MicYou-macOS-#{version}-arm64.dmg"
  name "MicYou"
  desc "Virtual microphone backed by an Android device"
  homepage "https://github.com/LanRhyme/MicYou"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "MicYou.app"
  binary "#{appdir}/MicYou.app/Contents/MacOS/micyou-cli", target: "micyou-cli"
  binary "#{appdir}/MicYou.app/Contents/MacOS/micyou-tui", target: "micyou-tui"

  zap trash: [
    "~/Library/Application Support/com.lanrhyme.micyou",
    "~/Library/Caches/com.lanrhyme.micyou",
    "~/Library/HTTPStorages/com.lanrhyme.micyou",
    "~/Library/HTTPStorages/com.lanrhyme.micyou.binarycookies",
    "~/Library/Preferences/com.lanrhyme.micyou.plist",
    "~/Library/WebKit/com.lanrhyme.micyou",
  ]

  caveats do
    puts <<~EOS
      MicYou needs a virtual audio device to expose the phone audio as a system
      input. With BlackHole installed, select it in System Settings → Sound → Input:

        brew install --cask blackhole-2ch
    EOS
  end
end
