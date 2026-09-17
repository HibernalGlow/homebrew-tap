cask "font-lxgw-wenkai-gb-screen" do
  version "1.522"
  sha256 "23ec023913e1851925eb94462c4b0ccd1d78bb89533745aaa8cc682ccd339dc0"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiGBScreen.ttf"
  name "LXGW WenKai GB Screen"
  name "霞鹜文楷屏幕阅读版 GB"
  desc "Screen reading variant of the LXGW WenKai typeface, GB glyphs"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiGBScreen.ttf"

  # No zap stanza required
end
