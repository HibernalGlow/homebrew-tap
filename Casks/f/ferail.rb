cask "ferail" do
  version "0.7.9"
  sha256 "4ccfbae1d4530a07bc48db3831ff1c1cb40d9fa3a1e1bc178468128774c8ccf4"

  url "https://github.com/jonx/Ferail/releases/download/v#{version}/Ferail-#{version}.dmg"
  name "Ferail"
  desc "Fast, native file manager for advanced users, written in Rust with GPUI"
  homepage "https://www.jkn.me/ferail/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Ferail.app"

  uninstall quit: "me.jkn.ferail"

  # Developer ID signed, stapled and hardened (`codesign -dvvv` gives the
  # three-level Authority chain for John Knipper (C43N3NG7Z5),
  # `xcrun stapler validate` passes), which is what upstream's own table claims,
  # so there is no signing caveat and nothing for the re-signing LaunchAgent.
  #
  # `depends_on :macos` rather than a version symbol: `LSMinimumSystemVersion`
  # and the single Mach-O (`ferail-gpui`, `minos 11.0`) agree on 11.0, and 11 is
  # Homebrew's own floor, so `:big_sur` would be flagged as a redundant minimum.
  # Artifact is Apple silicon only.
  #
  # No `auto_updates`: on macOS the updater downloads the release asset into
  # `~/Downloads` and mounts it, and installing stays the user's job (docs/
  # features/UPDATES.md), so the bundle is never replaced behind Homebrew.
  # Automatic checks are also opt-in and off on a fresh install (PRIVACY.md).
  #
  # One zap entry because upstream documents exactly one principal location for
  # macOS state (PRIVACY.md:121), and states that deleting it removes settings,
  # metadata, cached hashes, history and reports without touching browsed files.
  # Note for anyone who cares: that folder holds folder-icon/Finder-adjacent
  # history ("Ant Trail" visits, Favorites and duplicate-hash caches), so
  # `--zap` erases a record of which paths were visited. Source-derived: no
  # watched launch and clean quit was performed.
  zap trash: "~/Library/Application Support/Ferail"

  caveats do
    <<~EOS
      Ferail is signed and notarized, so it opens without any Gatekeeper step.
      It is not sandboxed, so browsing Desktop, Documents or Downloads prompts
      for macOS permission the first time each is opened.

      Update checks are off by default and, when accepted, only download the DMG
      into "~/Downloads" -- the app never replaces itself, so keep upgrading
      through `brew upgrade --cask ferail`.
    EOS
  end
end
