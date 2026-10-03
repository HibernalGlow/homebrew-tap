cask "maaend" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.31.0"
  sha256 arm:   "fda91db14065526af023a9a3e35a39f13a417176b13654f4a0d2f63063347ba4",
         intel: "957c3ffcf87104ee53b5b1fe72c8f33b4df4049c87b553599cf3d10135638382"

  url "https://github.com/MaaEnd/MaaEnd/releases/download/v#{version}/MaaEnd-macos-#{arch}-v#{version}.dmg"
  name "MaaEnd"
  desc "Vision AI automation assistant for Arknights: Endfield"
  homepage "https://maaend.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # `auto_updates`: upstream's own updater replaces files inside the bundle, see
  # the note above `zap`.
  #
  # `depends_on`: three-way disagreement, resolved towards what actually loads:
  # `LSMinimumSystemVersion` says 10.13 and the two main executables differ from
  # each other (arm64 `LC_BUILD_VERSION minos 11.0`, x86_64 the legacy
  # `LC_VERSION_MIN_MACOSX 10.13`), but 14 of the bundle's Mach-O images -- the
  # eleven `maafw/libMaa*.dylib`, `maafw/MaaPiCli`,
  # `maafw/plugins/libMaaPluginDemo.dylib` and `agent/cpp-algo` -- declare
  # `minos 13.3`, and dyld refuses an image built for a newer system than the one
  # it runs on. (The outliers are lower, not higher: `libfastdeploy_ppocr` /
  # `libonnxruntime` / `libopencv_world4` and the main executable are 11.0,
  # `agent/go-service` is 12.0, and the five files a magic-byte scan leaves
  # unclassified are Android `minitouch` ELFs that never load here.) `:ventura`
  # is the coarsest symbol at or below that 13.3, so macOS 13.0-13.2 still gets
  # an install that fails to launch; the alternative (`:sonoma`) would instead
  # shut out 13.3+ users, and only the ScreenCaptureKit window controller (see
  # the caveats) actually needs 14 -- the ADB controllers do not. `brew audit`
  # cannot see
  # any of this: its `audit_min_os` reads only the plist, gets 10.13, and returns
  # early because that is below `HOMEBREW_MACOS_OLDEST_ALLOWED` (11).
  auto_updates true
  depends_on macos: :ventura

  app "MaaEnd.app"

  uninstall quit: "com.maaend.app"

  # Runtime-observed footprint (one launch, then quit over AppleScript):
  # everything lands under `~/Library/Application Support/MXU/`, i.e. MXU's
  # shared data directory, not an app-named one -- `get_app_data_dir()` in
  # MistEO/MXU `src-tauri/src/commands/utils.rs` hardcodes
  # `Application Support/MXU`, and MaaEnd's own file inside it is named after the
  # interface (`config/mxu-MaaEnd.json`, 40 KB of instances and task options).
  # So `zap` deliberately lists only the two MaaEnd-named paths: the framework's
  # own `maa_option.json` (global MaaFramework runtime options), the announcement
  # cache index, `debug/*.log` and `~/Library/Caches/com.misteo.mxu` are all
  # shared with any other MXU-based app and stay put. No preference plist, no
  # saved state and no HTTPStorages appeared, and the bundle itself is never
  # written to -- except by the updater below.
  #
  # `auto_updates true` is from MXU's update flow, not from the presence of an
  # updater: `InstallConfirmModal.tsx` passes `targetDir: basePath`, and
  # `basePath` is `get_exe_dir()` -- `/Applications/MaaEnd.app/Contents/MacOS` --
  # so `apply_full_update()` copies the downloaded package over the installed
  # bundle in place and parks superseded files in `Contents/MacOS/cache/old`.
  # Once that has run, the tap's `version` is stale, hence the caveat.
  zap trash: [
    "~/Library/Application Support/MXU/cache/config_backup/mxu-MaaEnd-*.json",
    "~/Library/Application Support/MXU/config/mxu-MaaEnd.json",
  ]

  caveats do
    <<~EOS
      This release is ad-hoc signed (no Developer ID), has no notarization
      ticket, and its own resource seal does not match the bundle: two copies of
      one template image are sealed under an NFC filename ("Se" + U+0161) while
      the released bundle stores the same name decomposed (NFD, "s" + U+030C), so
      `codesign --verify --deep --strict` fails on both architectures with "a
      sealed resource is missing or invalid". Repair before the first launch:

        codesign --force --deep --sign - "#{appdir}/MaaEnd.app"
        xattr -dr com.apple.quarantine "#{appdir}/MaaEnd.app"

      Homebrew unpacks upstream verbatim, so repeat both lines after every
      `brew upgrade --cask maaend`.

      The app updates itself in place from its own settings page (MirrorChyan or
      GitHub releases). Once it has, Homebrew's metadata is behind: run
      `brew upgrade --cask maaend` to realign it, or don't use the in-app
      updater at all.

      The "macOS window" controller captures through ScreenCaptureKit, which
      needs the Screen Recording permission (and macOS 14 at runtime, even
      though the bundle loads on 13.3); ADB controllers do not.
    EOS
  end
end
