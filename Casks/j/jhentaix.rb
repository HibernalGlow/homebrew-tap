cask "jhentaix" do
  version "8.0.16+336"
  sha256 "530d397befa58c315358df5419816d275b7a920ae0d74cd10e08d3a9602f6ae2"

  url "https://github.com/HibernalGlow/JHenTai/releases/download/v#{version}/JHenTai-#{version}.dmg"
  name "JHenTai"
  desc "E-Hentai/ExHentai reader, HibernalGlow's fork with magnet-link tooling"
  homepage "https://github.com/HibernalGlow/JHenTai"

  livecheck do
    url :url
    # The tag carries a `+<build>` suffix that the default release regex drops,
    # and the asset name needs it, so match the whole tag here.
    regex(/v(\d+(?:\.\d+)+\+\d+)/)
    strategy :github_latest
  end

  # This fork keeps upstream's bundle id and app name, so it installs the very same
  # `jhentai.app` into the same place as the `jhentai` cask. The two are alternatives,
  # not a stack: uninstall one before installing the other.
  conflicts_with cask: "jhentai"
  depends_on macos: :monterey

  app "jhentai.app"

  uninstall quit: "top.jtmonster.jhentai"

  # Mirrors the `jhentai` cask verbatim on purpose: same bundle id means the same
  # sandbox container, and that container is shared with upstream's build rather than
  # private to this one. So `--zap` here also clears what a `jhentai` install reads.
  # As upstream: only regenerable state is listed; `Data/Documents/download`,
  # `local_gallery`, `save` and `db.sqlite` hold galleries the user downloaded and are
  # left alone.
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
      Built ad-hoc signed: no Developer ID and no notarization (`codesign -dv` reports
      "Signature=adhoc", "TeamIdentifier=not set"), and Homebrew additionally marks what
      it installs as quarantined, so macOS Gatekeeper blocks the first launch:

        "jhentai.app" cannot be opened because the developer cannot be verified.

      Clear the quarantine (or right-click the app and choose Open once to add a user
      override):

        xattr -dr com.apple.quarantine "#{appdir}/jhentai.app"

      The bundle is not damaged -- `codesign --verify --deep --strict` passes on this
      dmg -- so this is an artifact property, not an install problem, and the step must
      be repeated after every `brew upgrade --cask jhentaix`.

      This build shares ~/Library/Containers/top.jtmonster.jhentai with the `jhentai`
      cask, so the E-Hentai login, the gallery database and `jhentai.version` are the
      same files for both. Running them alternately lets each one migrate a store the
      other then reads.
    EOS
  end
end
