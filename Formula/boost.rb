class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2"
  sha256 "953db31e016db7bb207f11432bef7df100516eeb746843fa0486a222e3fd49cb"
  license "BSL-1.0"
  revision OS.mac? ? 3 : 4
  head "https://github.com/boostorg/boost.git"

  livecheck do
    url "https://www.boost.org/feed/downloads.rss"
    regex(/>Version v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "df216d9ac1aada2283fc5cca14b57381b9243a0743208a2a59201b10ac706bfb"
    sha256 cellar: :any,                 big_sur:       "9198af08180876d70b16decb22aa3237272a156b40a4f57e83840a3d30d2ca70"
    sha256 cellar: :any,                 catalina:      "3cea2aeddabbdb531b0db467d8d1661ec87a36ddc61a35f6b7dab5b9c75a4ed5"
    sha256 cellar: :any,                 mojave:        "705f06d5ac7c2615ae42158816eb3a738a4bff05b0ac18f8ef7d223fdcf9e75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac19f7acb73cce71ace98f645817ef455075ee50424364686e50a978f8baa3e4"
  end

  depends_on "icu4c"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Reduce INTERFACE_LINK_LIBRARIES exposure for shared libraries. Remove with the next release.
  patch do
    url "https://github.com/boostorg/boost_install/commit/7b3fc734242eea9af734d6cd8ccb3d8f6b64c5b2.patch?full_index=1"
    sha256 "cd96f5c51fa510fa6cd194eb011c0a6f9beb377fa2e78821133372f76a3be349"
    directory "tools/boost_install"
  end

  # Fix build on 64-bit arm
  patch do
    url "https://github.com/boostorg/build/commit/456be0b7ecca065fbccf380c2f51e0985e608ba0.patch?full_index=1"
    sha256 "e7a78145452fc145ea5d6e5f61e72df7dcab3a6eebb2cade6b4cfae815687f3a"
    directory "tools/build"
  end

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      on_macos do
        file.write "using darwin : : #{ENV.cxx} ;\n"
      end
      on_linux do
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula["icu4c"].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-icu=#{icu4c_prefix}
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      -sNO_LZMA=1
      -sNO_ZSTD=1
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end
