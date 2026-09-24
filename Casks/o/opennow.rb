cask "opennow" do
  version "1.0.1"
  sha256 "8afb1ab9f20240993b289cc9195e9a4c2e67bea7be5c24b76f233da37b1b08c7"

  url "https://github.com/OpenCloudGaming/OpenNOW/releases/download/v#{version}/OpenNOW-Qt-#{version}-Darwin-arm64.dmg"
  name "OpenNOW"
  desc "Open-source GeForce NOW client with native streaming and gamepad support"
  homepage "https://opennow.zortos.me/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "OpenNOW.app"

  uninstall quit: "io.github.opencloudgaming.OpenNOW"

  # Developer ID + stapled notarization + hardened runtime (`codesign -dvvv`
  # gives the full three-level Authority chain for MUHAMMED EMIN YILMAZER
  # (VR766AGP7G), `stapler validate` passes), so there is no signing caveat and
  # nothing for the re-signing LaunchAgent to repair. Upstream's README claims
  # "The macOS app is not notarized", but that sentence sits in its nightly
  # paragraph; RELEASE-INFO.json for this tag says `Developer ID; notarized;
  # stapled` and the bundle agrees.
  #
  # No `LSMinimumSystemVersion` in Info.plist, so Homebrew's minimum-OS audit
  # falls through to the Mach-O, and `minos 13.0` there matches upstream's "macOS
  # 13+" floor -- the :ventura below is both the true value and the one audit
  # derives. Artifact is arm64-only ("Intel Macs are not included").
  #
  # `auto_updates` because the updater swaps the bundle in place: it mounts the
  # DMG beside the installation (`/Applications/.opennow-update-<hex>`,
  # update_apply/mod.rs:240-254), requires the new bundle's TeamIdentifier to
  # match the installed one, then replaces it (update_apply/bundle.rs). Only the
  # Rust core's data directory is zapped -- `settings.json` and the staged
  # update state (opennow-core/src/settings.rs:828-830). Deliberately *not*
  # zapped: `~/Pictures/OpenNOW/{Screenshots,Recordings}`, where the app writes
  # gameplay captures (opennow-core/src/media.rs:18-20) -- that is user content.
  # Paths are source-derived; a watched launch and clean quit is still owed.
  zap trash: "~/Library/Application Support/OpenNOW"

  caveats do
    <<~EOS
      This build carries its own updater, which replaces
      "#{appdir}/OpenNOW.app" in place after checking the signing identity
      matches. `auto_updates` is therefore set and `brew outdated` will stop
      reporting it: once the app has updated itself, run
      `brew upgrade --cask opennow` to realign Homebrew's metadata, or leave
      update checks off. An interrupted update can leave a hidden
      `/Applications/.opennow-update-*` staging directory behind; `brew
      uninstall --cask` does not remove it.

      Microphone access is only used when "Open microphone" is enabled in audio
      settings, and the gamepad/streaming path prompts for its own device
      permissions on first session.

      `brew uninstall --cask --zap opennow` clears settings and the account
      store but keeps gameplay captures: screenshots and recordings live under
      "~/Pictures/OpenNOW", delete those yourself if you want them gone.
    EOS
  end
end
