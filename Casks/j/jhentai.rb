cask "jhentai" do
  version "8.0.16+334"
  sha256 "9726958c5a64d03cd9e62509adc2f73c029e963dc918a7dfbd04985433219c96"

  url "https://github.com/jiangtian616/JHenTai/releases/download/v#{version}/JHenTai-#{version}.dmg"
  name "JHenTai"
  desc "Browse, download and read E-Hentai and ExHentai galleries"
  homepage "https://github.com/jiangtian616/JHenTai"

  livecheck do
    url :url
    # The tag carries a `+<build>` suffix that the default release regex drops,
    # and the asset name needs it, so match the whole tag here.
    regex(/v(\d+(?:\.\d+)+\+\d+)/)
    strategy :github_latest
  end

  depends_on :macos

  app "jhentai.app"

  uninstall quit: "top.jtmonster.jhentai"

  # The app is sandboxed (com.apple.security.app-sandbox), so everything lands
  # inside its container -- including what a non-sandboxed Flutter app would put
  # in ~/Documents: the SQLite library, the GetStorage settings file, the version
  # marker and the logs. `path_provider` appends the bundle id to Application
  # Support and Caches but not to Documents, and this app names its own cache
  # directories `JHenTai` / `cacheimage` / `flutter_engine` / `WebKit` rather
  # than by bundle id -- all of the above observed after a real launch, which is
  # also why no `Data/Library/Preferences/<bundle id>.plist` is listed: the app
  # keeps its settings in `Documents/jhentai.gs`.
  #
  # Only regenerable state is listed. `Data/Documents/download`,
  # `local_gallery`, `save` and `db.sqlite` are deliberately absent: those hold
  # galleries the user downloaded, and deleting the database would orphan them
  # without freeing the files.
  zap trash: [
    "~/Library/Containers/top.jtmonster.jhentai/Data/Documents/jhentai.bak",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Documents/jhentai.gs",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Documents/jhentai.version",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Documents/logs",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Library/Application Support/top.jtmonster.jhentai",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Library/Caches/cacheimage",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Library/Caches/flutter_engine",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Library/Caches/JHenTai",
    "~/Library/Containers/top.jtmonster.jhentai/Data/Library/Caches/WebKit",
  ]

  caveats do
    <<~EOS
      Upstream ships this app ad-hoc signed: no Developer ID, no notarization
      (`codesign -dv` reports "Signature=adhoc", "TeamIdentifier=not set"), and
      Homebrew additionally marks what it installs as quarantined, so macOS
      Gatekeeper blocks the first launch:

        "jhentai.app" cannot be opened because the developer cannot be verified.

      Clear the quarantine (or right-click the app and choose Open once to add a
      user override):

        xattr -dr com.apple.quarantine "#{appdir}/jhentai.app"

      The bundle is not damaged -- `codesign --verify --deep --strict` passes on
      upstream's copy -- so this is an artifact property, not an install problem,
      and the step must be repeated after every `brew upgrade --cask jhentai`.

      The app is sandboxed, so its settings, gallery database and downloads all
      live under ~/Library/Containers/top.jtmonster.jhentai/Data/Documents.
      `--zap` leaves that directory alone on purpose; to also drop downloaded
      galleries and the saved E-Hentai login, remove it yourself.
    EOS
  end
end
