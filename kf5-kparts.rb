require "formula"

class Kf5Kparts < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kparts-5.15.0.tar.xz"
  sha1 "4574330518129b284d7e17ecb9ee4e994a83f140"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kparts.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kio"

  depends_on "qt5" => "with-d-bus"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
