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
  depends_on :macos

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
    <<~EOS
      Upstream ships this app with an inconsistent code signature: its binaries
      are linker-signed ad-hoc, which claims sealed resources, but the bundle
      never received a Contents/_CodeSignature envelope. macOS reads that
      mismatch as a damaged download and refuses to launch it, then offers to
      move it to the Trash:

        "MicYou.app" is damaged and can't be opened.

      Repair the installed bundle before the first launch:

        codesign --force --deep --sign - "#{appdir}/MicYou.app"
        xattr -dr com.apple.quarantine "#{appdir}/MicYou.app"

      This is a property of the artifact rather than of the installation:
      Homebrew unpacks upstream's copy verbatim, so the repair is lost on every
      upgrade and must be repeated after each `brew upgrade --cask micyou`.

      MicYou also needs a virtual audio device to expose the phone audio as a
      system input. With BlackHole installed, pick it in System Settings →
      Sound → Input:

        brew install --cask blackhole-2ch
    EOS
  end
end
