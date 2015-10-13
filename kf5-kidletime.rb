require "formula"

class Kf5Kidletime < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kidletime-5.15.0.tar.xz"
  sha1 "70a8fce8557cd761dff6c73956bfaf8be589fdd1"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kidletime.git'

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
