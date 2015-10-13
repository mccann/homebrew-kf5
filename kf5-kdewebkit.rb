require "formula"

class Kf5Kdewebkit < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kdewebkit-5.15.0.tar.xz"
  sha1 "6ae17737c4d5fd39e6eda93b624ecf7d8901689d"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kdewebkit.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kparts"
  depends_on "qt5" => "with-d-bus"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"

    prefix.install "install_manifest.txt"

  end
end
