class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.13.tar.gz"
  sha256 "f7d07bd4fe6fb7561dd177e423e67d7fcfb755d1edc4386d19ce52ec19687bc0"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b23ae9995327ba8227dfa280da1b50c1622fe29addc38ca3d4b33488c6cb83a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4785f57041340319bd9b2c004f83783eb52313b7fec4713b83d034388e32302d"
    sha256 cellar: :any_skip_relocation, catalina:      "e5b5064e097598abdbce5ce69d3799fa163ce96e7a300a8c0a2b8d44614c20ae"
    sha256 cellar: :any_skip_relocation, mojave:        "9351ec252c7e75939985cd71be607601f5fad50be8af3d340e851cdfb3ed51e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae29d89dd981ac11346963493d7882cc7ddb3a5de3f7ff20d816a2be2413649"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
