class DiffSoFancy < Formula
  desc "Good-lookin' diffs with diff-highlight and more"
  homepage "https://github.com/so-fancy/diff-so-fancy"
  url "https://github.com/so-fancy/diff-so-fancy/archive/v1.4.0.tar.gz"
  sha256 "71a71a801255badfe9d24d47d8ae7b9d3ed0a889a78b977c39d0c65091078155"
  license "MIT"
  head "https://github.com/so-fancy/diff-so-fancy.git", branch: "next"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f58bb1285efd9d50688341a561dc57089edfeaab57c10747717b43a7abe74b38"
    sha256 cellar: :any_skip_relocation, all:          "f8acbd90272799ae120992873a559f334601c7c04eff118685602688e2b68d0d"
  end

  def install
    libexec.install "diff-so-fancy", "lib"
    bin.install_symlink libexec/"diff-so-fancy"
  end

  test do
    diff = <<~EOS
      diff --git a/hello.c b/hello.c
      index 8c15c31..0a9c78f 100644
      --- a/hello.c
      +++ b/hello.c
      @@ -1,5 +1,5 @@
       #include <stdio.h>

       int main(int argc, char **argv) {
      -    printf("Hello, world!\n");
      +    printf("Hello, Homebrew!\n");
       }
    EOS
    assert_match "modified: hello.c", pipe_output(bin/"diff-so-fancy", diff, 0)
  end
end
