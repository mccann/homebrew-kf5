require "formula"

class Kf5Kcrash < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kcrash-5.15.0.tar.xz"
  sha1 "6c6351a466afd6652b903f641c23d538be085c22"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kcrash.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  depends_on "haraldf/kf5/kf5-kwindowsystem"
  depends_on "haraldf/kf5/kf5-kcoreaddons"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
