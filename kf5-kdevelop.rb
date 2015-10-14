require "formula"

class Kf5Kdevelop < Formula
  url "http://download.kde.org/stable/kdevelop/4.7.1/src/kdevelop-4.7.1.tar.xz"
  sha1 "9b4cf77b753f6847f10709bb616c55c8e515c53c"
  homepage "http://www.kde.org/"

  head "git://anongit.kde.org/kdevelop.git"
  
  
  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "llvm" => "with-clang"

  depends_on "gettext" => :build
  depends_on "haraldf/kf5/kf5-kdevplatform"
  depends_on "haraldf/kf5/kf5-kded"
  depends_on "haraldf/kf5/kf5-kglobalaccel"
  depends_on "kf5-oxygen-icons"

  conflicts_with "kdevelop"

  def patches
    DATA
  end
  
  def install


    system <<-'FIXUP'

        ## make install dirs KF5
        #git ls-files -z '*CMakeLists.txt' '*.dox' '*.cmake*'  | xargs -0 sed -i.bak \
        #         -e 's/KDE_INSTALL_INCLUDEDIR/KDE_INSTALL_INCLUDEDIR_KF5/g'\
        #         -e 's/KDE_INSTALL_LIBEXECDIR/KDE_INSTALL_LIBEXECDIR_KF5/g'\
        #         -e 's/KDE_INSTALL_DATADIR/KDE_INSTALL_DATADIR_KF5/g'\
        #         -e 's/CMAKE_INSTALL_INCLUDEDIR/KDE_INSTALL_INCLUDEDIR_KF5/g'\
        #         -e 's/CMAKE_INSTALL_LIBEXECDIR/KDE_INSTALL_LIBEXECDIR_KF5/g'\
        #         -e 's/CMAKE_INSTALL_DATADIR/KDE_INSTALL_DATADIR_KF5/g'\
        #         -e 's/INCLUDE_INSTALL_DIR/KDE_INSTALL_INCLUDEDIR_KF5/g'
        #         
        ## make this work as a KF5 cmake module
        #git ls-files -z '*CMakeLists.txt' '*.cmake*' | xargs -0 sed -i.bak \
        #             -e 's/KDevelopConfig/KF5KDevelopConfig/g'\
        #             -e 's/KDE_INSTALL_CMAKEPACKAGEDIR}\/KDevelop/KDE_INSTALL_CMAKEPACKAGEDIR}\/KF5KDevelop/g'
        #
        #git mv cmake/modules/KDevelopConfig.cmake cmake/modules/KF5KDevelopConfig.cmake
        #
        #         
        # make this depend on KF5 KDevPlatform cmake module
        #git ls-files -z '*CMakeLists.txt' '*.cmake*' | xargs -0 sed -i.bak \
        #             -e 's/KDevPlatform/KF5KDevPlatform/g'
        
    FIXUP


    mkdir "build" do
        #LLVM in library_paths breaks linking against sytem libs of the same name
        ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
   
        args = std_cmake_args

        system "cmake", "..", *args
        #interactive_shell
        
        system "make", "install"
        prefix.install "install_manifest.txt"
    end

    # TODO: When (HEAD) QStandardPaths::AppDataLocation points to <kdevelop.app>/Contents/Resources dir in app-bundle
    # --- could try to either install these files there, or at least make a symlink to /usr/local/share/* 

    # Make findable from QStandardPaths:
    support  = "#{Etc.getpwuid.dir}/Library/Application Support"
    prefs    = "#{Etc.getpwuid.dir}/Library/Preferences"
    systemshare    = HOMEBREW_PREFIX/"share"
  
    ln_sf systemshare/"icons", support
    #ln_sf systemshare/"appdata", support
    #ln_sf systemshare/"applications", support
    ln_sf systemshare/"kdevappwizard", support
    ln_sf systemshare/"kdevcodegen", support
    ln_sf systemshare/"kdevelop", support
    ln_sf systemshare/"kdevfiletemplates", support
    ln_sf systemshare/"kdevmanpage", support

    # all prefs
    system "ln -sf /usr/local/etc/xdg/*  #{prefs}"
    
    #fix icons to work as part of 'oxygen' theme
    mv share/"icons/hicolor", share/"icons/oxygen"
    mv share/"kdevelop/icons/hicolor", share/"kdevelop/icons/oxygen"

    # remove icons that conflict with oxygen theme before linking
    Dir.glob(share/"icons/oxygen/**/kdevelop.*") { |icon| File.delete(icon) }

  end
end

__END__
##################
# disable qmljs for now
##################
diff --git a/languages/CMakeLists.txt b/languages/CMakeLists.txt
index 22d29ec..43e8e78 100644
--- a/languages/CMakeLists.txt
+++ b/languages/CMakeLists.txt
@@ -1,5 +1,5 @@
 ecm_optional_add_subdirectory(plugins)
-ecm_optional_add_subdirectory(qmljs)
+#ecm_optional_add_subdirectory(qmljs)
 
 option(LEGACY_CPP_SUPPORT "Enable legacy C++ backend" OFF)
 


##################
# enable hidpi
##################
diff --git a/app/Info.plist.in b/app/Info.plist.in
index ca6c7de..be256f9 100644
--- a/app/Info.plist.in
+++ b/app/Info.plist.in
@@ -34,6 +34,10 @@
     <true/>
     <key>NSSupportsAutomaticTermination</key>
     <false/>
+    <key>NSPrincipalClass</key>
+    <string>NSApplication</string>
+    <key>NSHighResolutionCapable</key>
+    <string>True</string>
     <key>NSHumanReadableCopyright</key>
     <string>${MACOSX_BUNDLE_COPYRIGHT}</string>
 </dict>


##################
# clang issue
##################
diff --git a/languages/cpp/preprocessjob.cpp b/languages/cpp/preprocessjob.cpp
index d84a445..59cf286 100644
--- a/languages/cpp/preprocessjob.cpp
+++ b/languages/cpp/preprocessjob.cpp
@@ -197,7 +197,7 @@ void PreprocessJob::run(ThreadWeaver::JobPointer self, ThreadWeaver::Thread* thr
             }
           } else if (fileFeaturesSatisfied && !slaveFeaturesSatisfied) {
             // This is strange, because importees should not require more features than the importer
-            qCDebug(CPP) << "Slaves require more features than file itself" << parentJob()->slaveMinimumFeatures() << updatingEnvironmentFile->features() << parentJob()->document().toUrl();
+            qCDebug(CPP) << "Slaves require more features than file itself" << (unsigned)parentJob()->slaveMinimumFeatures() << (unsigned)updatingEnvironmentFile->features() << parentJob()->document().toUrl();
           }
         }
     }

