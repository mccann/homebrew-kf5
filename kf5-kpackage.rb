require "formula"

class Kf5Kpackage < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kpackage-5.15.0.tar.xz"
  sha1 "00c3f8837a39b03946883999a7d43534b4ca2e5a"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kpackage.git'

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-karchive"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
