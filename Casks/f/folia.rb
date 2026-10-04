cask "folia" do
  arch arm: "arm64", intel: "x64"

  version "0.7.12"
  sha256 arm:   "0f5cacbd9514ac33ef9324206e7a85bd4648485f5d3ae05cb779682ac44f89f4",
         intel: "6ceb8eb977d29631c59a020839ff793f14b5224a2ba6bc56843d0682f0a7dd92"

  url "https://github.com/chthollyphile/folia-major/releases/download/v#{version}/Folia-#{version}-#{arch}.dmg"
  name "Folia"
  desc "Music player for local files and Navidrome with animated lyric effects"
  homepage "https://github.com/chthollyphile/folia-major"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "Folia.app"

  uninstall quit: "top.izuna.foliamajor"

  # Electron names its profile after the productName (`Folia`), so the Chromium
  # state lives under Application Support rather than ~/Library/Caches; the
  # updater cache name comes from the bundle's own app-update.yml.
  zap trash: [
    "~/Library/Application Support/Folia",
    "~/Library/Caches/folia-major-updater",
    "~/Library/Preferences/top.izuna.foliamajor.plist",
  ]

  caveats do
    <<~EOS
      Upstream ships this app with an inconsistent code signature: the binaries
      are linker-signed ad-hoc, which claims sealed resources, but the bundle
      never received a Contents/_CodeSignature envelope. macOS reads that
      mismatch as a damaged download and refuses to launch it, then offers to
      move it to the Trash:

        "Folia.app" is damaged and can't be opened.

      Upstream documents this itself (docs/desktop/macos-app-damaged.md): the
      release workflow sets CSC_IDENTITY_AUTO_DISCOVERY=false, so no Developer ID
      signing or notarization happens at all.

      Repair the installed bundle before the first launch:

        codesign --force --deep --sign - "#{appdir}/Folia.app"
        xattr -dr com.apple.quarantine "#{appdir}/Folia.app"

      This is a property of the artifact rather than of the installation:
      Homebrew unpacks upstream's copy verbatim, so the repair is lost on every
      upgrade and must be repeated after each `brew upgrade --cask folia`.

      Leave the app's own "auto update" switch off and upgrade through Homebrew.
      electron-updater is wired up (the bundle carries app-update.yml with
      `channel: latest`, plus beta/alpha nightlies on separate tags), but
      Squirrel.Mac installs updates by relaunching a bundle whose signature has
      to match what it shipped with -- which an ad-hoc, un-notarized build does
      not satisfy. Treat in-app updates here as broken by construction, not as a
      convenience. The updater also follows prerelease tags such as `limo` and
      `cielo`; Homebrew tracks the stable releases only.
    EOS
  end
end
