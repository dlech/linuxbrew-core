class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.5.tar.xz"
  sha256 "261663db21bcc1cc232b07ea683252ee6992982276536924271535875f5b0556"
  license "MIT"
  revision 1

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f4b0803937d1fa962e698890caa1ec96d7ba1847a4df990ad07db5ed480d8821"
    sha256 cellar: :any, big_sur:       "70c98f994735bd0cd3c23286460c06fcbe324294f97b61ea91dc72303132c64d"
    sha256 cellar: :any, catalina:      "f410ca0d9f4d101901beec178b22f4e65facdad58d496c7b2b5f9a56ec241852"
    sha256 cellar: :any, mojave:        "4ca20871fe9fd9bf37cebd4dc3b7f081406dc08d60c404d970132cb48f26900b"
    sha256 cellar: :any, x86_64_linux:  "0395b23b90b636a1071832e60f25f8139e3eae25fbdf0616f50a381e4b5475c7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  depends_on "freeglut" unless OS.mac?

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #include <OpenGL/OpenGL.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
