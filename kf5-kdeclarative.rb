require "formula"

class Kf5Kdeclarative < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kdeclarative-5.15.0.tar.xz"
  sha1 "71dfbf6f72f49d68343a00f52b463854d670aa74"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kdeclarative.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "libepoxy"
  depends_on "haraldf/kf5/kf5-kio"
  depends_on "haraldf/kf5/kf5-kpackage"

  patch :DATA

  def install
    args = std_cmake_args

    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end

__END__
diff --git a/src/qmlcontrols/kquickcontrolsaddons/plotter.cpp b/src/qmlcontrols/kquickcontrolsaddons
index 67ce63a..22934ad 100644
--- a/src/qmlcontrols/kquickcontrolsaddons/plotter.cpp
+++ b/src/qmlcontrols/kquickcontrolsaddons/plotter.cpp
@@ -47,6 +47,8 @@
 
 #include <QuickAddons/ManagedTextureNode>
 
+#include <cmath>
+
 //completely arbitrary
 static int s_defaultSampleSize = 40;

