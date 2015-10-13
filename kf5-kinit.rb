require "formula"

class Kf5Kinit < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kinit-5.15.0.tar.xz"
  sha1 "c73938dd2e4d2d9011447c534b602f9b3b1c044e"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kinit.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-kio"

  def patches
    DATA
  end


  def install

    system <<-FIXUP
        # Installing into Cellar confuses matters
        #   CMAKE_INSTALL_FULL_LIBEXECDIR_KF5 (Cellar path) is used as a define in source.
        # -- fix that
        git ls-files -z '*.h.cmake'  | xargs -0 sed -i.bak \
            -e 's/${CMAKE_INSTALL_FULL_LIBEXECDIR_KF5}/#{(HOMEBREW_PREFIX/"lib/libexec/kf5").to_s.gsub('/','\\/')}/g'
    FIXUP

    mkdir "build" do 
        args = std_cmake_args

        system "cmake", *args, ".."
        
        #interactive_shell

        system "make", "install"

        prefix.install "install_manifest.txt"
    end
  end
end

__END__

diff --git a/src/kdeinit/CMakeLists.txt b/src/kdeinit/CMakeLists.txt
index f94db71..001396c 100644
--- a/src/kdeinit/CMakeLists.txt
+++ b/src/kdeinit/CMakeLists.txt
@@ -11,14 +11,14 @@ include_directories(${KInit_BINARY_DIR}) # for kinit_version.h
 # on win32 kdeinit5 has to be a console application
 # to be able to catch stderr based --verbose output
 add_executable(kdeinit5 ${kdeinit_SRCS})
-if (APPLE)
-  # this has to be GUI on OSX because it launches GUI apps and need a quartz context
-  set_target_properties(kdeinit5 PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.template)
-  set_target_properties(kdeinit5 PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER "org.kde.kdeinit5")
-  set_target_properties(kdeinit5 PROPERTIES MACOSX_BUNDLE_BUNDLE_NAME "KDE Init")
-else ()
+#if (APPLE)
+#  # this has to be GUI on OSX because it launches GUI apps and need a quartz context
+#  set_target_properties(kdeinit5 PROPERTIES MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.template)
+#  set_target_properties(kdeinit5 PROPERTIES MACOSX_BUNDLE_GUI_IDENTIFIER "org.kde.kdeinit5")
+#  set_target_properties(kdeinit5 PROPERTIES MACOSX_BUNDLE_BUNDLE_NAME "KDE Init")
+#else ()
   ecm_mark_nongui_executable(kdeinit5)
-endif ()
+#endif ()
 
 target_link_libraries(kdeinit5 ${kdeinit_LIBS} ${KINIT_SOCKET_LIBRARY}
     Qt5::Gui #QFont::initialize
@@ -56,6 +56,12 @@ if (NOT WIN32)
 
   target_link_libraries(kdeinit5_wrapper  ${KINIT_SOCKET_LIBRARY} Qt5::Core)
 
+  # kdeinit5_helper
+  add_executable(kdeinit5_helper helper.cpp)
+  ecm_mark_nongui_executable(kdeinit5_helper)
+  target_link_libraries(kdeinit5_helper Qt5::Core)
+  install(TARGETS kdeinit5_helper ${KF5_INSTALL_TARGETS_DEFAULT_ARGS} )
+
   if (NOT X11_FOUND)
     target_compile_definitions(kdeinit5_wrapper PRIVATE -DNO_DISPLAY)
   endif ()
diff --git a/src/kdeinit/helper.cpp b/src/kdeinit/helper.cpp
new file mode 100644
index 0000000..495c5b0
--- /dev/null
+++ b/src/kdeinit/helper.cpp
@@ -0,0 +1,42 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <QFile>
+#include <QLibrary>
+
+typedef int (*handler) (int, char *[]);
+
+int main(int argc, char *argv[])
+{
+    if (argc < 2)
+    {
+        fprintf(stderr, "Too few arguments\n");
+        exit(1);
+    }
+
+    QString libpath = QFile::decodeName(argv[argc-1]);
+    QLibrary l(libpath);
+
+    if (!libpath.isEmpty() && (!l.load() || !l.isLoaded()))
+    {
+        QString ltdlError = l.errorString();
+        fprintf(stderr, "Could not open library %s: %s\n", qPrintable(libpath), qPrintable(ltdlError) );
+        exit(1);
+    }
+
+    QFunctionPointer sym = l.resolve( "kdeinitmain");
+    if (!sym)
+    {
+        sym = l.resolve( "kdemain" );
+        if ( !sym )
+        {
+            QString ltdlError = l.errorString();
+            fprintf(stderr, "Could not find kdemain: %s\n", qPrintable(ltdlError) );
+            exit(1);
+        }
+    }
+
+    handler func = (int (*)(int, char *[])) sym;
+    exit( func(argc - 1, argv)); /* Launch! */
+}
+
diff --git a/src/kdeinit/kinit.cpp b/src/kdeinit/kinit.cpp
index 9e775b6..23fbf38 100644
--- a/src/kdeinit/kinit.cpp
+++ b/src/kdeinit/kinit.cpp
@@ -550,6 +550,12 @@ static pid_t launch(int argc, const char *_name, const char *args,
     const QString bundlepath = QStandardPaths::findExecutable(QFile::decodeName(execpath));
 #endif
 
+    // Don't run this inside the child process, it crashes on OS/X 10.6
+   const QString helperpath = QStandardPaths::findExecutable(QString::fromLatin1("kdeinit5_helper"));
+#ifdef Q_OS_MAC
+   const QString argvexe = QStandardPaths::findExecutable(QString::fromLatin1(_name));
+#endif
+
     d.errorMsg = 0;
     d.fork = fork();
     switch (d.fork) {
@@ -609,10 +615,9 @@ static pid_t launch(int argc, const char *_name, const char *args,
         {
             int r;
             QByteArray procTitle;
-            d.argv = (char **) malloc(sizeof(char *) * (argc + 1));
+            d.argv = (char **) malloc(sizeof(char *) * (argc + 2));
             d.argv[0] = (char *) _name;
 #ifdef Q_OS_MAC
-            QString argvexe = QStandardPaths::findExecutable(QString::fromLatin1(d.argv[0]));
             if (!argvexe.isEmpty()) {
                 QByteArray cstr = argvexe.toLocal8Bit();
                 // qDebug() << "kdeinit5: launch() setting argv: " << cstr.data();
@@ -711,23 +716,9 @@ static pid_t launch(int argc, const char *_name, const char *args,
             exit(255);
         }
 
-        QFunctionPointer sym = l.resolve("kdeinitmain");
-        if (!sym) {
-            sym = l.resolve("kdemain");
-            if (!sym) {
-                QString ltdlError = l.errorString();
-                fprintf(stderr, "Could not find kdemain: %s\n", qPrintable(ltdlError));
-                QString errorMsg = i18n("Could not find 'kdemain' in '%1'.\n%2",
-                                        libpath, ltdlError);
-                exitWithErrorMsg(errorMsg);
-            }
-        }
-
-        d.result = 0; // Success
+        d.result = 2; // Try execing
         write(d.fd[1], &d.result, 1);
-        close(d.fd[1]);
 
-        d.func = (int (*)(int, char *[])) sym;
         if (d.debug_wait) {
             fprintf(stderr, "kdeinit5: Suspending process\n"
                     "kdeinit5: 'gdb kdeinit5 %d' to debug\n"
@@ -738,8 +729,18 @@ static pid_t launch(int argc, const char *_name, const char *args,
             setup_tty(tty);
         }
 
-        exit(d.func(argc, d.argv));  /* Launch! */
+        QByteArray helperexe = QFile::encodeName(helperpath);
+        QByteArray libpathbytes = QFile::encodeName(libpath);
+        d.argv[argc] = libpathbytes.data();
+        d.argv[argc+1] = 0;
+
+        if (!helperexe.isEmpty())
+            execvp(helperexe.constData(), d.argv);
 
+        d.result = 1; // Error
+        write(d.fd[1], &d.result, 1);
+        close(d.fd[1]);
+        exit(255);
         break;
     }
     default:
