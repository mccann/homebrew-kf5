require "formula"

class Kf5Kservice < Formula
  url "http://download.kde.org/stable/frameworks/5.14/kservice-5.14.0.tar.xz"
  sha1 "3ff46cd246369e3d050ac2c973c070eaf0917892"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kservice.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-kcrash"
  depends_on "haraldf/kf5/kf5-kdoctools"
  depends_on "haraldf/kf5/kf5-kdbusaddons"
  depends_on "haraldf/kf5/kf5-kconfig"
  depends_on "haraldf/kf5/kf5-ki18n"

  def patches
    DATA
  end

  def install
    args = std_cmake_args

    mkdir "build" do 
        system "cmake", "-DBUILD_TESTING=OFF", *args, ".."
        system "make", "install"
        prefix.install "install_manifest.txt"
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index aa37851..d78811e 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -28,7 +28,7 @@ ecm_setup_version(${KF5_VERSION}
                   PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/KF5ServiceConfigVersion.cmake"
                   SOVERSION 5)
 
-set(APPLICATIONS_MENU_NAME applications.menu
+set(APPLICATIONS_MENU_NAME kf5-applications.menu
     CACHE STRING "Name to install the applications.menu file as.")
 
 # TODO: Remove these

diff --git a/src/sycoca/ksycocautils_p.h b/src/sycoca/ksycocautils_p.h
index caeb0e0..33047de 100644
--- a/src/sycoca/ksycocautils_p.h
+++ b/src/sycoca/ksycocautils_p.h
@@ -70,7 +70,10 @@ bool visitResourceDirectory(const QString &dirname, Visitor visitor)
 
     // Recurse only for services and menus.
     // Apps and servicetypes don't need recursion, so save the directory listing.
-    if (!dirname.contains("/applications") && !dirname.contains("/kservicetypes5")) {
+    if ( !dirname.contains("/applications")
+      && !dirname.contains("/Applications")
+      && !dirname.contains("/kservicetypes5")
+    ) {
         return visitResourceDirectoryHelper(dirname, visitor);
     }

