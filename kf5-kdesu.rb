require "formula"

class Kf5Kdesu < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kdesu-5.15.0.tar.xz"
  sha1 "6c93c088cc5734a7a30728fbace720f775ec8706"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kdesu.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kpty"
  depends_on "qt5" => "with-d-bus"
  depends_on "gettext" => :build

  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
