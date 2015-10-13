require "formula"

class Kf5Kplotting < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kplotting-5.15.0.tar.xz"
  sha1 "d69b9561c0c8ea7f515460944ce6f4c19b94bfa5"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kplotting.git'

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
