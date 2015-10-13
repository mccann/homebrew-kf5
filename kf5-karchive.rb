require "formula"

class Kf5Karchive < Formula
  url "http://download.kde.org/stable/frameworks/5.15/karchive-5.15.0.tar.xz"
  sha1 "424c602b00bbd76748487ce2014f4f9baf79c723"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/karchive.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
