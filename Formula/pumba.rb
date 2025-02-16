class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.7.tar.gz"
  sha256 "974f17df36bfdbb510b303db7acf1c3d637d7d50c87f3120b07e1e363792cf87"
  license "Apache-2.0"
  revision 1
  head "https://github.com/alexei-led/pumba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23ea7c27073d54ac360deae32dd52388dcda30a72ca7e3f7c34fd715533d9c45"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab72f222b8eeaadf48320af5f87db33697cafa4a519010d200a377f16f81cef2"
    sha256 cellar: :any_skip_relocation, catalina:      "9aacdeac788678e480042779b159e00f80f06886d89c5a61f601741349a4cefa"
    sha256 cellar: :any_skip_relocation, mojave:        "32e9cf47edec277ec8ec83e8a5536018133ab7ba8d2532dc7fdf8c8e624bafc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6379c35ffa71d79cfb5431ff83ea0b7fb420947dc09cd8a0bd22c3b423840ac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")

    on_macos do
      assert_match "Is the docker daemon running?", output
    end

    on_linux do
      assert_match "no containers to remove", output
    end
  end
end
