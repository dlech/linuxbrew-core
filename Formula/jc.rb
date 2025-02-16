class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/0d/a3/f06c61d1dbb69e1840c462f9b0e5c94a2e310be2a665d9326b539836616c/jc-1.15.2.tar.gz"
  sha256 "76d1e3c4133d1d4afc5c530dd5208ff51006407c594b4cc93b83cd328feec59d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc97ea004d4df0444d3968e7aabd082888f141e56b87a36969a6385bc86888a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "e239c5ceb2ce14b14bf163291232f028000dc1c8dffdcd0f1bbb5748a24caa5d"
    sha256 cellar: :any_skip_relocation, catalina:      "d792a566fe043957db2cceebe7e25d9394a23512b21f49f404c6523c3c6b8ae0"
    sha256 cellar: :any_skip_relocation, mojave:        "a6378b76d80d0f495d0b6b5019f40608e05d82a5e3038baba5437a46558feaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6301411b049d1fb13949aeecb91407032e39d41c87b870c5e46f70ee94c6f6c8"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jc/man/jc.1.gz"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
