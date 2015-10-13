require "formula"

class Kf5ExtraCmakeModules < Formula
  url "http://download.kde.org/stable/frameworks/5.15/extra-cmake-modules-5.15.0.tar.xz"
  sha1 "fcb1131ba404d573065a56a7b406830b216c15d3"
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
