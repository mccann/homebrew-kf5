require "formula"

class Kf5Threadweaver < Formula
  url "http://download.kde.org/stable/frameworks/5.15/threadweaver-5.15.0.tar.xz"
  sha1 "042c13fbe8bed08e4b057ea503868ad93a80a46d"
  homepage "http://www.kde.org/"

  head "git://anongit.kde.org/threadweaver.git"
 
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
