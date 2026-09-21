cask "rawviewer" do
  version "0.1.1"
  sha256 "096fe755337fbc1c8bbb2ab76f845cec8d94631dd4023319ef7ec1719e42bbb6"

  url "https://github.com/stmtc233/RawViewer/releases/download/v#{version}/rawviewer-macos-v#{version}.zip"
  name "Raw Viewer"
  desc "Browse, rate and preview camera RAW files with LibRaw decoding"
  homepage "https://github.com/stmtc233/RawViewer"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "rawviewer.app"

  uninstall quit: "com.example.rawviewer"

  # Sandboxed (com.apple.security.app-sandbox), so everything lands inside the
  # container keyed by its bundle id -- which upstream left at the Flutter
  # placeholder `com.example.rawviewer`. The container root is deliberately not
  # listed: it also holds the redirected Downloads / Documents folders that point
  # at the user's real ones.
  #
  # These are the only two the app actually created, watched across a launch, an
  # image open and a clean quit: no `Caches/com.example.rawviewer`, no
  # `Application Support/com.example.rawviewer` (path_provider is linked but
  # those paths never appeared), no HTTPStorages, no WebKit, no saved state.
  zap trash: [
    "~/Library/Containers/com.example.rawviewer/Data/Library/Caches/flutter_engine",
    "~/Library/Containers/com.example.rawviewer/Data/Library/Preferences/com.example.rawviewer.plist",
  ]

  caveats do
    <<~EOS
      Upstream ships this build ad-hoc signed and not notarized (no Developer
      ID), and Homebrew additionally marks what it installs as quarantined, so
      the first launch is blocked:

        "rawviewer.app" cannot be opened because the developer cannot be verified.

      Clear the quarantine (or right-click the app and choose Open once to add a
      user override):

        xattr -dr com.apple.quarantine "#{appdir}/rawviewer.app"

      The signature is self-consistent -- `codesign --verify --deep --strict`
      passes on upstream's copy -- so this is an artifact property, not an
      install problem, and the step must be repeated after every
      `brew upgrade --cask rawviewer`.

      The app is sandboxed, and upstream kept the stock Flutter bundle
      identifier `com.example.rawviewer`. Everything it stores therefore lives
      under `~/Library/Containers/com.example.rawviewer`, and that placeholder
      identifier is the same one any Flutter app ships with until someone
      customises it.
    EOS
  end
end
