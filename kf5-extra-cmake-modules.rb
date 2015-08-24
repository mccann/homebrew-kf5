require "formula"

class Kf5ExtraCmakeModules < Formula
  url "http://download.kde.org/stable/frameworks/5.14/extra-cmake-modules-5.14.0.tar.xz"
  sha1 "6e88ebe4acea14d7b8a0eaadcc3f2892d6a9b304"
  homepage "http://www.kde.org/"

  keg_only "Only required for building KDE frameworks"

  head 'git://anongit.kde.org/extra-cmake-modules'

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "install_manifest.txt"

    # Make findable from QStandardPaths:
    support  = "#{Etc.getpwuid.dir}/Library/Application Support"
    share    = HOMEBREW_PREFIX/"share"
  
    ln_sf share/"kf5", support
  end
end
