cask "nigate" do
  arch arm: "arm64", intel: "x64"

  version "1.4.5"
  sha256 arm:   "25b71aee047d9b4af488a44bb8beb744966ad81640f62f5d0cd2ac8d98d4390d",
         intel: "c31ca15bc758570fcdfe50372229df45be356c11d4b246a6ec95e694271e3246"

  url "https://github.com/hoochanlon/Free-NTFS-for-Mac/releases/download/v#{version}/Nigate-#{version}-#{arch}.dmg"
  name "Nigate"
  desc "Mount and manage NTFS volumes with read-write support"
  homepage "https://hoochanlon.github.io/Free-NTFS-for-Mac/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "Nigate.app"

  uninstall quit: "io.hoochanlon.github"

  # Electron names its profile after package.json `name` (there is no
  # `productName`), and the whole Chromium profile -- cache, cookies, local
  # storage, its own `Preferences` -- sits inside that directory, so it is the
  # only entry the app actually creates. The updater cache name is what the
  # bundle's own app-update.yml declares; it appears once the updater
  # downloads. Observed across two launches with clean quits: no
  # `~/Library/Caches/free-ntfs-for-mac`, no `Logs`, no
  # `Preferences/io.hoochanlon.github.plist` and no saved state.
  zap trash: [
    "~/Library/Application Support/free-ntfs-for-mac",
    "~/Library/Caches/free-ntfs-for-mac-updater",
  ]

  caveats do
    <<~EOS
      Upstream ships this app with an inconsistent code signature: its binaries
      are linker-signed ad-hoc, which claims sealed resources, but the bundle
      never received a Contents/_CodeSignature envelope. macOS reads that
      mismatch as a damaged download and refuses to launch it, then offers to
      move it to the Trash:

        "Nigate.app" is damaged and can't be opened.

      Repair the installed bundle before the first launch:

        codesign --force --deep --sign - "#{appdir}/Nigate.app"
        xattr -dr com.apple.quarantine "#{appdir}/Nigate.app"

      This is a property of the artifact rather than of the installation:
      Homebrew unpacks upstream's copy verbatim, so the repair is lost on every
      upgrade and must be repeated after each `brew upgrade --cask nigate`.

      NTFS write support does not come from this app: it needs macFUSE and
      ntfs-3g. Its "one-click" dependency setup fetches shell scripts from a CDN
      and runs them in a bundled terminal (node-pty) with administrator
      privileges, and the matching "uninstall dependencies" action removes
      macFUSE system-wide. If macFUSE or ntfs-3g are already on this Mac for
      something else, read what those buttons do before using them. On Apple
      Silicon, loading the macFUSE driver additionally needs a Security Policy
      change in Recovery, so treat this as a system-level install, not just an
      app.
    EOS
  end
end
