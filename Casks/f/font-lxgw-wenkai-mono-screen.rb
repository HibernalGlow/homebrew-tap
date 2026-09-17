cask "font-lxgw-wenkai-mono-screen" do
  version "1.522"
  sha256 "758bf0e7fceddeae425fa3f5b792aa3e80428856b9f37d21355e0e4295135e9d"

  url "https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v#{version}/LXGWWenKaiMonoScreen.ttf"
  name "LXGW WenKai Mono Screen"
  name "霞鹜文楷等宽屏幕阅读版"
  desc "Monospaced screen reading variant of the LXGW WenKai typeface"
  homepage "https://github.com/lxgw/LxgwWenKai-Screen"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "LXGWWenKaiMonoScreen.ttf"

  # No zap stanza required
end
