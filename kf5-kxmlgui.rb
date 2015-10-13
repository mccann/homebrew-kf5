require "formula"

class Kf5Kxmlgui < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kxmlgui-5.15.0.tar.xz"
  sha1 "ecd47940d3548ce7a61350d6e7dbd41380ef9213"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kxmlgui.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kglobalaccel"
  depends_on "haraldf/kf5/kf5-ktextwidgets"
  depends_on "haraldf/kf5/kf5-attica"
  depends_on "qt5" => "with-d-bus"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"

    # Make findable from QStandardPaths:
    support  = "#{Etc.getpwuid.dir}/Library/Application Support"
    share    = HOMEBREW_PREFIX/"share"
  
    ln_sf share/"kxmlgui5", support


  end
end
