require "formula"

class Kf5Kio < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kio-5.15.0.tar.xz"
  sha1 "8bc58e83f9a8bac99899e3e383044d6d1eb05d13"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kio.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "haraldf/kf5/kf5-karchive"
  depends_on "haraldf/kf5/kf5-kbookmarks"
  depends_on "haraldf/kf5/kf5-kjobwidgets"
  depends_on "haraldf/kf5/kf5-kwallet"
  depends_on "haraldf/kf5/kf5-solid"


  def install

    system <<-FIXUP

        ###################
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

        # Make findable from QStandardPaths:
        support  = "#{Etc.getpwuid.dir}/Library/Application Support"
        share    = HOMEBREW_PREFIX/"share"
      
        ln_sf share/"kservices5", support
    end
  end
end

