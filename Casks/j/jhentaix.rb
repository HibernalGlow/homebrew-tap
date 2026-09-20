cask "jhentaix" do
  version "8.0.16+337"
  sha256 "1831034e2c531ec82c211d7e51abc41911d364a57a4d59c116ddbb36708bf595"

  url "https://github.com/HibernalGlow/JHenTai/releases/download/v#{version}/JHenTaiX-#{version}.dmg"
  name "JHenTaiX"
  desc "E-Hentai/ExHentai reader, HibernalGlow's fork with magnet-link tooling"
  homepage "https://github.com/HibernalGlow/JHenTai"

  livecheck do
    url :url
    # The tag carries a `+<build>` suffix that the default release regex drops,
    # and the asset name needs it, so match the whole tag here.
    regex(/v(\d+(?:\.\d+)+\+\d+)/)
    strategy :github_latest
  end

  depends_on macos: :monterey

  app "JHenTaiX.app"

  uninstall quit: "top.jtmonster.jhentaix"

  # Independent of the `jhentai` cask from 8.0.16+337 on: the fork moved to its own
  # bundle id, so the two apps no longer fight over jhentai.app or share a container.
  #
  # The container is keyed by bundle id, so the paths below follow the fork's own
  # `top.jtmonster.jhentaix`. The `Application Support` entry is derived from that id
  # by path_provider; the remaining names come from the app's own hard-coded file and
  # cache directory names, which did not change with the rename. Unlike the `jhentai`
  # cask, this list has not been confirmed against a real launch -- correct it if a
  # path turns out to differ.
  # As upstream: only regenerable state is listed; `Data/Documents/download`,
  # `local_gallery`, `save` and `db.sqlite` hold galleries the user downloaded.
  zap trash: [
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Documents/jhentai.bak",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Documents/jhentai.gs",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Documents/jhentai.version",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Documents/logs",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Library/Application Support/top.jtmonster.jhentaix",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Library/Caches/cacheimage",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Library/Caches/flutter_engine",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Library/Caches/JHenTai",
    "~/Library/Containers/top.jtmonster.jhentaix/Data/Library/Caches/WebKit",
  ]

  caveats do
    <<~EOS
      Built ad-hoc signed: no Developer ID and no notarization (`codesign -dv` reports
      "Signature=adhoc", "TeamIdentifier=not set" on this very dmg), and Homebrew
      additionally marks what it installs as quarantined, so macOS Gatekeeper blocks the
      first launch:

        "JHenTaiX.app" cannot be opened because the developer cannot be verified.

      Clear the quarantine (or right-click the app and choose Open once to add a user
      override):

        xattr -dr com.apple.quarantine "#{appdir}/JHenTaiX.app"

      The bundle is not damaged, so this is an artifact property rather than an install
      problem, and the step must be repeated after every `brew upgrade --cask jhentaix`.

      This is the fork build: it keeps upstream's data file names inside its own sandbox
      container, so your upstream `jhentai` login and gallery database are NOT shared and
      you will need to sign in once here.
    EOS
  end
end
