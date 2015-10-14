require "formula"

class Kf5Kiconthemes < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kiconthemes-5.15.0.tar.xz"
  sha1 "18ba5a1a1d9fa478c976bca1c78619af0d3a43f4"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kiconthemes.git'

  def patches
    DATA
  end

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "haraldf/kf5/kf5-kconfigwidgets"
  depends_on "haraldf/kf5/kf5-kitemviews"
  depends_on "qt5" => "with-d-bus"

  def install
    args = std_cmake_args


    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"
  end
end

__END__

diff --git a/src/kicontheme.cpp b/src/kicontheme.cpp
index d0ab4b9..535956b 100644
--- a/src/kicontheme.cpp
+++ b/src/kicontheme.cpp
@@ -171,6 +171,50 @@ KIconTheme::KIconTheme(const QString &name, const QString &appName, const QStrin
         return;
     }
 
+#ifdef Q_OS_MAC
+    // make QIcon aware of the theme & paths 
+
+    // only update search paths once.
+    auto paths = QIcon::themeSearchPaths();
+    // assume count()==1 is the default {":/icons"} case
+    if (paths.count()==1) {
+
+        // app overloads first
+        paths += QStandardPaths::locateAll(QStandardPaths::AppDataLocation, "icons", QStandardPaths::LocateDirectory);
+        // generics after
+        paths += icnlibs;
+
+        QIcon::setThemeSearchPaths( paths );
+        qWarning() << "QIcon::setThemeSearchPaths" << paths ;
+
+
+        // warn about 'inherited' themes that will not be seen
+        {
+            auto getWarnings = [&](const QString& str) {
+                QStringList ret;
+                if (name != str) {
+                    ret = QStandardPaths::locateAll(QStandardPaths::AppDataLocation, "icons/" + str, QStandardPaths::LocateDirectory);
+                }
+                return ret;
+            };
+
+            QStringList warning_paths;
+            warning_paths += getWarnings(defaultThemeName());
+            warning_paths += getWarnings(QLatin1String("hicolor"));
+            warning_paths += getWarnings(QLatin1String("locolor"));
+
+            for ( auto&& warning_path : warning_paths ) {
+                qWarning() << "OSX only: Unsupported inheriting icon theme found at '" <<  warning_path << "'"
+                              "\n\tTry renaming or merging to/into '" << name << "'";
+            }
+        }
+    }
+    if (QIcon::themeName() != name) {
+        QIcon::setThemeName(name);
+        qWarning() << "QIcon::themeName(): " << QIcon::themeName();
+    }
+#endif
+
     // Use KSharedConfig to avoid parsing the file many times, from each component.
     // Need to keep a ref to it to make this useful
     d->sharedConfig = KSharedConfig::openConfig(fileName, KConfig::NoGlobals);
