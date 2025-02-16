class Bpytop < Formula
  include Language::Python::Virtualenv

  desc "Linux/OSX/FreeBSD resource monitor"
  homepage "https://github.com/aristocratos/bpytop"
  url "https://files.pythonhosted.org/packages/c1/fe/25709a8103a6e2d0fc7dc79d919f541156c2c1a758ed5231965c3433588d/bpytop-1.0.64.tar.gz"
  sha256 "758fa894d6147bbdaba51b7bd1c5bf878b7f742c59ac10c1bfac5c974e2ca20a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a948efb8575563dfa4e58feab665989003e043602c32c780647c3ee0b1405c6c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4734b7a4876f2ce8fcab0e7e4dde25e55c574cb5054dc5b8094e499ae20e5deb"
    sha256 cellar: :any_skip_relocation, catalina:      "af52fe4d6d3ff458572a9fd39507e33ad0bad4f1fb15a6d6eb06f3e6b4965d0a"
    sha256 cellar: :any_skip_relocation, mojave:        "d0a896d093dd71505646544947c5b1b9160556764a407ea2f9fc7bee9f133192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fabc4181e77ebd6d40321076b60307bf16ed87f7db7adc469ecdaf6cdcbb99c"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.9"
  on_macos do
    depends_on "osx-cpu-temp"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "bpytop-themes" => "themes"
  end

  test do
    config = (testpath/".config/bpytop")
    mkdir config/"themes"
    (config/"bpytop.conf").write <<~EOS
      #? Config file for bpytop v. #{version}

      update_ms=2000
      log_level=DEBUG
    EOS

    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/bpytop")
    r.winsize = [80, 130]
    sleep 5
    w.write "\cC"

    log = (config/"error.log").read
    assert_match "bpytop version #{version} started with pid #{pid}", log
    refute_match(/ERROR:/, log)
  ensure
    Process.kill("TERM", pid)
  end
end
