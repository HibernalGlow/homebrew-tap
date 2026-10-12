cask "menumate" do
  version "0.3.0-beta.1"
  sha256 "0708753b525a89794b924d2fc520e7ad6aa403cc78b48089840c91aadc90a08d"

  url "https://github.com/Hibrielle/menumate/releases/download/v#{version}/MenuMate-#{version}-universal.dmg"
  name "MenuMate"
  desc "Script-first Finder context-menu manager with editable zsh actions"
  homepage "https://github.com/Hibrielle/menumate"

  livecheck do
    url :url
    # Every release upstream has published is marked prerelease, and GitHub's
    # `/releases/latest` endpoint excludes prereleases (it 404s for this repo
    # today), so `strategy :github_latest` has nothing to read.
    # `strategy :github_releases` walks the whole list but its default block
    # skips prereleases too, so the tag has to be taken back by hand here.
    # Drafts stay out. This keeps tracking betas on purpose: when upstream
    # ships a stable `0.3.0` it outranks `0.3.0-beta.1` in Homebrew's own
    # `Version` ordering (`NULL_TOKEN` beats `BetaToken`), so the cask moves to
    # stable without another edit.
    strategy :github_releases do |releases|
      releases.filter_map do |release|
        next if release["draft"]

        release["tag_name"]&.delete_prefix("v")
      end
    end
  end

  depends_on macos: :ventura

  # `auto_updates` stays off: Sparkle.framework is embedded but wired to
  # nothing -- `SUEnableAutomaticChecks` is false, `SUPublicEDKey` is the
  # literal placeholder `REPLACE_WITH_YOUR_SPARKLE_PUBLIC_KEY`, and the
  # `SUFeedURL` appcast returns 404. Upstream's own BUILD-INFO.txt says
  # "automatic updates: disabled".
  app "MenuMate.app"

  uninstall quit: "com.menumate.app"

  # Measured from a real launch plus a clean quit (SIGTERM run and an
  # `open` + AppleScript `quit` run; the second added nothing). The app is
  # unsandboxed and carries no entitlements at all, so settings land in the
  # plain `~/Library/Preferences/com.menumate.app.plist` (one key,
  # `MMSeededPresetKeys`) and the config root in
  # `~/Library/Application Support/MenuMate` (`config.json`, `.storage.lock`,
  # `Scripts/`, `Templates/`, `Data/`). No `Caches`, `HTTPStorages`, saved
  # state or `Logs` directory appeared in either run, so none is listed.
  #
  # `~/Library/Application Support/MenuMate` is deliberately NOT in `zap`:
  # `Scripts/` holds the user's own zsh actions -- including the seeded
  # presets, which are edited in place by design -- `Data/` holds state that
  # scripts persist (e.g. `cut.sh`'s cut buffer), `Packs/` holds imported
  # community packs, `config.json` is the menu itself, and `pbs.plist.backup`
  # is the app's restore copy of the user's system services database. The
  # command to remove the directory is in the caveats instead.
  #
  # The Finder extension is the sandboxed half (`com.apple.security.app-sandbox`
  # is the only entry in its own entitlements), so its container is listed even
  # though it never appeared here: enabling the extension is a manual step in
  # System Settings and was not performed, and the container only gets created
  # when the extension first loads. It reads nothing from disk -- icon bytes
  # travel base64 inside the menu snapshot -- so that container can only ever
  # hold OS-created caches.
  zap trash: [
    "~/Library/Containers/com.menumate.app.FinderExtension",
    "~/Library/Preferences/com.menumate.app.plist",
  ]

  caveats do
    <<~EOS
      Every upstream release is a prerelease, ad-hoc signed and not notarized
      (upstream's own BUILD-INFO.txt says so), and Homebrew marks what it
      installs as quarantined, so clear that flag before the first launch or
      right-click the app and choose Open once:

        xattr -dr com.apple.quarantine "#{appdir}/MenuMate.app"

      The signature is self-consistent -- `codesign --verify --deep --strict`
      passes on the installed app and on the embedded extension -- so this is an
      artifact property, not a damaged download. Repeat after every
      `brew upgrade --cask menumate`.

      Installing the app does not add anything to Finder's context menu. The
      bundled Finder Sync extension has to be registered and enabled first:

        pluginkit -a "#{appdir}/MenuMate.app/Contents/PlugIns/FinderExtension.appex"

      then System Settings -> General -> Login Items & Extensions -> Finder
      Extensions. Check who is serving the menu with

        pluginkit -m -v -i com.menumate.app.FinderExtension

      and `pluginkit -r` the path of any older copy still registered elsewhere,
      since that keeps supplying the menu and makes this install look inert.

      The "Open With" and Quick Action panels edit the system services database
      at ~/Library/Preferences/pbs.plist. That file is not MenuMate's and
      `--zap` leaves it alone -- and a plain launch does not touch it either
      (measured: same sha256 and mtime before and after). The app keeps its own
      restore copy at ~/Library/Application Support/MenuMate/pbs.plist.backup,
      so look at that before deleting the directory below.

      Settings, your scripts and imported packs all live under
      ~/Library/Application Support/MenuMate, which `--zap` keeps on purpose.
      To drop them too:

        rm -rf ~/Library/Application\\ Support/MenuMate
    EOS
  end
end
