cask "arcthumb" do
  arch arm: "arm64", intel: "x86_64"

  version "0.12.0"
  sha256 arm:   "454b1625abd9df21f4be4bbf5b103814abc0514d9b72511c659a31375fc9f1b1",
         intel: "4948018c9d8382aff97cc15c138dc6c81dfc616f9ebec05e06e32d1c34c6320f"

  url "https://github.com/HibernalGlow/ArcThumbX/releases/download/v#{version}/ArcThumb-#{version}-macOS-#{arch}.zip"
  name "ArcThumb"
  desc "Quick Look thumbnail provider for archive and ebook covers"
  homepage "https://github.com/hibernalglow/arcthumbx"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "ArcThumb.app"
  # The same binary is the Slint settings window and a headless switchboard:
  # `arcthumb --get`, `--regenerate`, `--log-on`, `--lang zh|en|ja`. The target
  # name is spelled out because the executable is `ArcThumb`, and linking that
  # verbatim would put a capitalised command on the PATH.
  binary "#{appdir}/ArcThumb.app/Contents/MacOS/ArcThumb", target: "arcthumb"

  uninstall quit: "com.citrussoda.ArcThumb"

  # The Quick Look extension is sandboxed and keeps everything in its own
  # container -- settings included, at Data/Library/Application Support/ArcThumb/
  # settings. It deliberately does not use UserDefaults (an unsandboxed helper
  # cannot write into a sandboxed preference domain), so there is no
  # `Preferences/*.plist` to list and the container is the only state.
  zap trash: "~/Library/Containers/com.citrussoda.ArcThumb.thumbnail"

  caveats do
    <<~EOS
      Builds are ad-hoc signed, so macOS Gatekeeper blocks the first launch
      until the quarantine flag is gone:

        xattr -dr com.apple.quarantine "#{appdir}/ArcThumb.app"

      or right-click the app and choose Open once. The signature itself is
      self-consistent (`codesign --verify --deep --strict` passes for the app
      and the embedded extension), so no re-signing is needed.

      Copying the app is not enough to get thumbnails. Quick Look only sees the
      extension after it is registered and enabled -- and the settings window
      cannot do that by itself:

        pluginkit -a "#{appdir}/ArcThumb.app/Contents/PlugIns/ArcThumbThumbnail.appex"
        pluginkit -e use -i com.citrussoda.ArcThumb.thumbnail
        qlmanage -r cache

      The GUI equivalent is System Settings → Extensions → Thumbnailing
      Extensions. Quick Look keeps the registration per path, so if an older
      copy of the app was ever registered from somewhere else (a build in
      `~/Applications`, for instance) it keeps serving thumbnails and this
      install looks inert: check with `pluginkit -m -v -i
      com.citrussoda.ArcThumb.thumbnail`, then `pluginkit -r` the stale bundle
      before adding this one. After uninstalling, unregister the extension with
      `pluginkit -r` on the path above and clear the cache again.
    EOS
  end
end
