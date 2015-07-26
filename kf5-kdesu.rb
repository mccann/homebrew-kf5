require "formula"

class Kf5Kdesu < Formula
  url "http://download.kde.org/stable/frameworks/5.10/kdesu-5.10.0.tar.xz"
  sha1 "7c29d3ee0d5c55fb4e5aac62ec88cdd77350aac8"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kdesu.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kpty"
  depends_on "qt5" => "with-d-bus"
  depends_on "gettext" => :build

  def patches
    DATA
  end

  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end

__END__
diff -Nu a/CMakeLists.txt a/CMakeLists.txt.new
--- a/CMakeLists.txt	2015-03-07 22:41:59.000000000 +0800
+++ a/CMakeLists.txt.new	2015-03-14 23:08:17.000000000 +0800
@@ -18,10 +18,6 @@
 find_package(KF5Service ${KF5_DEP_VERSION} REQUIRED)
 find_package(KF5Pty ${KF5_DEP_VERSION} REQUIRED)
 
-#optional features
-find_package(X11)
-set(HAVE_X11 ${X11_FOUND})
-
 include(FeatureSummary)
 include(GenerateExportHeader)
 include(ECMSetupVersion)
