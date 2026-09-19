cask "reinplayer" do
  version "1.1.0"
  sha256 "bc664f06b7f576b8ba6c5af325fd293c04e43fa94c60770fc54cb0e70a55bbf9"

  url "https://github.com/Ahurein/rein_player/releases/download/v#{version}/ReinPlayer-v#{version}.dmg"
  name "ReinPlayer"
  desc "Cross-platform video and audio player built with Flutter"
  homepage "https://github.com/Ahurein/rein_player"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "rein_player.app"

  uninstall quit: "com.example.reinPlayer"

  zap trash: [
    "~/Library/Application Support/com.example.reinPlayer",
    "~/Library/Caches/com.example.reinPlayer",
    "~/Library/Preferences/com.example.reinPlayer.plist",
    "~/Library/Saved Application State/com.example.reinPlayer.savedState",
  ]

  caveats do
    <<~EOS
      Upstream ships this app with an ad-hoc code signature (no Developer ID,
      bundle identifier left at the default placeholder "com.example.reinPlayer").
      The bundle is not damaged (`codesign -v` passes), but Homebrew attaches a
      quarantine attribute on install and the signature has no Developer ID, so
      macOS Gatekeeper blocks the first launch:

        "rein_player.app" cannot be opened because the developer cannot be verified.

      Clear the quarantine (or right-click the app and choose Open once to add a
      user override):

        xattr -dr com.apple.quarantine "#{appdir}/rein_player.app"

      A stronger fix, if needed, re-signs the bundle ad-hoc:

        codesign --force --deep --sign - "#{appdir}/rein_player.app"

      This is an artifact property, not an install problem: Homebrew unpacks
      upstream's copy verbatim, so repeat the step after each
      `brew upgrade --cask reinplayer` if the block returns.
    EOS
  end
end
