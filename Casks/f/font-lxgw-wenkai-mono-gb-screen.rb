cask "font-lxgw-wenkai-mono-gb-screen" do
  version "1.530"
  sha256 "2cda8fb9db28d5b3f8928e464e4a7be9d137fab6e93acd04441b0358ce0c3b26"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiMonoGBScreen.ttf"
  name "LXGW WenKai Mono GB Screen"
  name "霞鹜文楷等宽屏幕阅读版 GB"
  desc "Monospaced screen reading variant of the LXGW WenKai typeface, GB glyphs"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiMonoGBScreen.ttf"

  # No zap stanza required
end
