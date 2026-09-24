cask "lume-app" do
  version "1.3.0"
  sha256 "51df00d539c024603f5ee15723df4fbdcfc8e9d05867012d9f76750062a1bcaf"

  url "https://github.com/hugomyb/Lume/releases/download/v#{version}/Lume_#{version}_universal.dmg"
  name "Lume"
  desc "Lightweight virtual machine manager"
  homepage "https://github.com/hugomyb/Lume"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Lume.app"

  uninstall quit: "com.lume.app"

  # Lume keeps its virtual machines under ~/Library/Application Support/lume.
  # That is user data, so it is intentionally excluded here: `brew uninstall
  # --zap` must never delete user VMs. Only app-generated support files remain.
  zap trash: [
    "~/Library/Caches/com.lume.app",
    "~/Library/HTTPStorages/com.lume.app",
    "~/Library/HTTPStorages/com.lume.app.binarycookies",
    "~/Library/Logs/com.lume.app",
    "~/Library/Preferences/com.lume.app.plist",
    "~/Library/Saved Application State/com.lume.app.savedState",
    "~/Library/WebKit/com.lume.app",
  ]

  caveats do
    <<~EOS
      Upstream ships this app with an inconsistent code signature: its binary
      is linker-signed ad-hoc, which claims sealed resources, but the bundle
      never received a Contents/_CodeSignature envelope. macOS reads that
      mismatch as a damaged download and refuses to launch it, then offers to
      move it to the Trash:

        "Lume.app" is damaged and can't be opened.

      Repair the installed bundle before the first launch:

        codesign --force --deep --sign - "#{appdir}/Lume.app"
        xattr -dr com.apple.quarantine "#{appdir}/Lume.app"

      This is a property of the artifact rather than of the installation:
      Homebrew unpacks upstream's copy verbatim, so the repair is lost on every
      upgrade and must be repeated after each `brew upgrade --cask lume-app`.

      Launching the app while it is still broken makes macOS move it to the
      Trash, so reinstall and repair instead of reusing that copy.
    EOS
  end
end
