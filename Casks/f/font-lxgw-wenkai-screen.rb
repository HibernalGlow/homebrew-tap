cask "font-lxgw-wenkai-screen" do
  version "1.530"
  sha256 "abd13364163e3cd84372b333f2fdcee9efb848634668f1c0ce5788dcd059ee61"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiScreen.ttf"
  name "LXGW WenKai Screen"
  name "霞鹜文楷屏幕阅读版"
  desc "Screen reading variant of the LXGW WenKai typeface"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiScreen.ttf"

  # No zap stanza required
end
