class RbenvDefaultGems < Formula
  desc "Auto-installs gems for Ruby installs"
  homepage "https://github.com/sstephenson/rbenv-default-gems"
  url "https://github.com/sstephenson/rbenv-default-gems/archive/v1.0.0.tar.gz"
  sha256 "8271d58168ab10f0ace285dc4c394e2de8f2d1ccc24032e6ed5924f38dc24822"
  license "MIT"
  revision 1
  head "https://github.com/sstephenson/rbenv-default-gems.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8f8a731667273ee89b150dc4ae831c14cc3549e29aa35dc4fd853083b8db591e"
    sha256 cellar: :any_skip_relocation, all:          "a0d9a36598b96b0762b6bb943ed425f4f87e1d89b020699710d6eaae2592040b"
  end

  depends_on "rbenv"

  # Upstream patch: https://github.com/sstephenson/rbenv-default-gems/pull/3
  patch do
    url "https://github.com/sstephenson/rbenv-default-gems/commit/ead67889c91c53ad967f85f5a89d986fdb98f6fb.patch?full_index=1"
    sha256 "ac6a5654c11d3ef74a97029ed86b8a7b6ae75f4ca7ff4d56df3fb35e7ae0acb8"
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "default-gems.bash", shell_output("rbenv hooks install")
  end
end
