require "formula"

class Kf5Kwallet < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kwallet-5.15.0.tar.xz"
  sha1 "9e10aabbd27e35380d44d179ec42016d2cb53d27"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kwallet.git'

  depends_on "libgcrypt"

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-knotifications"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end
