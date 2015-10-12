require "formula"

class Kf5Kpackage < Formula
  url "http://download.kde.org/stable/frameworks/5.14/kpackage-5.14.0.tar.xz"
  sha1 "e93d2a29b68d66138816e234fbb8fcbd45e5f982"
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
