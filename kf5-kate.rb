require "formula"

class Kf5Kate < Formula
  url "http://download.kde.org/stable/applications/15.08.2/src/kate-15.08.2.tar.xz"
  sha256 "c804ee703667960779aabce9d4ede23d66d36e28479f44a1c0f151165c91430f"
  homepage "http://www.kde.org/"

  head "git://anongit.kde.org/kate.git"

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"

  depends_on "haraldf/kf5/kf5-kactivities"
  depends_on "haraldf/kf5/kf5-kconfig"
  depends_on "haraldf/kf5/kf5-kdoctools"
  depends_on "haraldf/kf5/kf5-kguiaddons"
  depends_on "haraldf/kf5/kf5-ki18n"
  depends_on "haraldf/kf5/kf5-kiconthemes"
  depends_on "haraldf/kf5/kf5-kinit"
  depends_on "haraldf/kf5/kf5-kjobwidgets"
  depends_on "haraldf/kf5/kf5-kio"
  depends_on "haraldf/kf5/kf5-kparts"
  depends_on "haraldf/kf5/kf5-ktexteditor"
  depends_on "haraldf/kf5/kf5-kwindowsystem"
  depends_on "haraldf/kf5/kf5-kxmlgui"
  depends_on "haraldf/kf5/kf5-kitemmodels"
  depends_on "haraldf/kf5/kf5-knewstuff"
  depends_on "haraldf/kf5/kf5-kwallet"

  def patches
    DATA
  end

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  
    #fix icons to work as part of 'oxygen' theme
    mv share/"icons/hicolor", share/"icons/oxygen"

    # remove icons that conflict with oxygen theme before linking
    Dir.glob(share/"icons/oxygen/**/kate.*") { |icon| File.delete(icon) }

    # add HiDPI support
    inreplace "/Applications/KDE/kate.app/Contents/Info.plist", "</dict>" ,<<-'EOS'
        <key>NSPrincipalClass</key>
        <string>NSApplication</string>
        <key>NSHighResolutionCapable</key>
        <string>True</string>
    </dict>
    EOS
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index e8f47ed..8de15f1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -38,6 +38,7 @@ find_package(KF5 REQUIRED COMPONENTS
   DocTools
   GuiAddons
   I18n
+  IconThemes
   Init
   JobWidgets
   KIO
