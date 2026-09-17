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

  caveats do
    <<~EOS
      Upstream ships this app with an inconsistent code signature: its binaries
      are linker-signed ad-hoc, which claims sealed resources, but the bundle
      never received a Contents/_CodeSignature envelope. macOS reads that
      mismatch as a damaged download and refuses to launch it, then offers to
      move it to the Trash:

        "SPlayer-Next.app" is damaged and can't be opened.

      Repair the installed bundle before the first launch:

        codesign --force --deep --sign - "#{appdir}/SPlayer-Next.app"
        xattr -dr com.apple.quarantine "#{appdir}/SPlayer-Next.app"

      This is a property of the artifact rather than of the installation:
      Homebrew unpacks upstream's copy verbatim, so the repair is lost on every
      upgrade and must be repeated after each `brew upgrade --cask splayer-next`.

      Launching the app while it is still broken makes macOS move it to the
      Trash, so reinstall and repair instead of reusing that copy.
    EOS
  end
end
