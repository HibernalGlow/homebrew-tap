cask "scryglass" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.3.0"
  sha256 arm:   "8f9f11d7207e75c30f1eb5f337a66874d617c2ba9ac9707974f15b4b92c438d6",
         intel: "041a6675195c6d45b2fb0ce2f85870a7715a0d95bb2987b3c04a5dde8185241a"

  url "https://github.com/cameronkinsella/scryglass/releases/download/v#{version}/scryglass-v#{version}-#{arch}-apple-darwin.dmg"
  name "scryglass"
  desc "Image viewer with video, AVIF, HEIC, JPEG XL, RAW and comic-archive support"
  homepage "https://github.com/cameronkinsella/scryglass"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Both artifacts agree on 11.0: `LSMinimumSystemVersion` and the single thin
  # Mach-O (`minos 11.0`, sdk 26.5) on arm64 and x86_64 each, so `:big_sur`
  # would be flagged as a redundant minimum -- same position as ferail.
  depends_on :macos

  app "scryglass.app"

  uninstall quit: "com.cameronkinsella.scryglass"

  # Not sandboxed at all (neither signature carries an entitlements section), so
  # state lands directly under the real ~/Library, keyed by the app name
  # `scryglass` rather than by the bundle id -- except the one AppKit-owned file
  # below, which is keyed by the bundle id like every other plist.
  #
  # Measured from the installed bundle. A fresh scratch `HOME`, one launch, one
  # PNG open, ~30 s idle:
  #   `Application Support/scryglass/`          created at startup, empty
  #   `Caches/scryglass/thumbs/<dir>/<img>.sgt` two persisted thumbnails for the
  #                                             folder that was opened
  # The directory is created before anything is saved because the config-reload
  # watcher has to watch a parent that may not exist yet (`notify` cannot watch a
  # missing file), see src/app/subscription.rs.
  #
  # `config.toml` in that directory is a different event: it appeared in the two
  # sessions that ended through the app's own quit path (window close / menu
  # Quit, which persists geometry into `[managed.window]`), and never appeared
  # for a session ended with SIGTERM -- that kill skips the persist, so a killed
  # instance leaves the directory empty. The keys themselves are the three
  # settings tiers, all defaults until something is changed in Settings.
  #
  # `Preferences/com.cameronkinsella.scryglass.plist` came from the one session
  # started through LaunchServices (`open -a`), and holds only two AppKit-owned
  # keys -- `NSNavPanelExpandedSizeForOpenMode` and `NSOSPLastRootDirectory`, the
  # open panel's size and last browsed folder. The direct-exec runs never created
  # it, and nothing in it is app-authored.
  #
  # Swept by a `find ~/Library -maxdepth 4 -iname '*scry*' -o -iname
  # '*cameron*'` after three sessions, and therefore not listed: no
  # `Containers/com.cameronkinsella.scryglass` (not sandboxed), no
  # `Saved Application State`, no `HTTPStorages`, no `Logs`, no `WebKit`, no
  # group container, and no app-authored key inside that plist -- a Rust app that
  # keeps its settings in TOML and never calls UserDefaults.
  #
  # Also not listed: `Caches/scryglass/present-probe.toml`. Upstream does write
  # that file (src/platform/present_probe.rs), but only where a driver probe
  # happens, and macOS has none -- "Off Windows there is no driver probe, so the
  # present mode is applied up front" (src/main.rs). Confirmed absent over three
  # sessions. Don't add it back on the strength of the source alone.
  #
  # Not zapped on purpose: `$TMPDIR/scryglass-video`. AVIF decoding has to hand
  # FFmpeg a real file, so each decode writes one there and unlinks it right
  # after (src/media/decoders/avif.rs); a session killed mid-decode leaves the
  # strays behind -- 4 files, 13 MB after one such kill -- and the next startup
  # does remove them: that directory came back empty on the launch after, so the
  # sweep at src/app/boot.rs (`clean_extraction_dir`) is observed, not just
  # claimed. The OS reclaims `$TMPDIR` anyway.
  #
  # One upstream quirk worth knowing before trusting this list: a `data/` folder
  # beside the executable opts the build into portable mode, and then the config
  # and thumbnail paths move inside the bundle instead of ~/Library
  # (src/config/mod.rs, `data_dir()`). That is opt-in by the user, and a `brew`
  # install does not create it.
  zap trash: [
    "~/Library/Application Support/scryglass",
    "~/Library/Caches/scryglass",
    "~/Library/Preferences/com.cameronkinsella.scryglass.plist",
  ]

  caveats do
    <<~EOS
      Builds are ad-hoc signed and not notarized -- upstream's own packager says
      so (`cargo xtask package` runs `codesign --force --deep --sign -`) -- so the
      first launch is blocked:

        "scryglass.app" can't be opened because Apple cannot check it for
        malicious software.

      Clear the quarantine (right-click then Open once also works):

        xattr -dr com.apple.quarantine "#{appdir}/scryglass.app"

      The signature is self-consistent -- `codesign --verify --deep --strict`
      exits 0 on both artifacts, with `_CodeSignature/CodeResources` present --
      so this is an artifact property, not an install problem, no re-signing is
      needed, and the step must be repeated after every
      `brew upgrade --cask scryglass`.

      Each release ships two macOS downloads. This cask takes the `.dmg`, which
      is the one carrying the `.app`; the slim `.tar.gz` beside it holds just the
      bare binary and has no bundle to install. Both are built
      `--all-features`, so video playback (statically linked FFmpeg), AV1/AVIF
      and HEIC/HEIF are already in here -- nothing to install separately, and
      `otool -L` shows only system frameworks, so the app is self-contained.

      Settings and the thumbnail cache are per-user, under
      "~/Library/Application Support/scryglass" (a TOML file, written when a
      session ends through the app's own quit path -- it stores your settings and
      the last window geometry), "~/Library/Caches/scryglass" (the persisted
      thumbnails the filmstrip reads to skip re-decoding) and
      "~/Library/Preferences/com.cameronkinsella.scryglass.plist" (AppKit's open
      panel state). `brew uninstall --cask --zap scryglass` removes all three;
      without `--zap` they survive a reinstall.

      There is no background updater, so brew stays the only thing touching this
      binary: Settings has a single manual "check for updates" button that GETs
      the GitHub releases API and prints a link. Turn it off at build time and
      no networking code compiles at all, but the shipped artifacts do have it.
    EOS
  end
end
