require "formula"

class Kf5ExtraCmakeModules < Formula
  url "http://download.kde.org/stable/frameworks/5.15/extra-cmake-modules-5.15.0.tar.xz"
  sha1 "fcb1131ba404d573065a56a7b406830b216c15d3"
  homepage "http://www.kde.org/"

  keg_only "Only required for building KDE frameworks"

  head 'git://anongit.kde.org/extra-cmake-modules'

  depends_on "cmake" => :build

  def install
    
    mkdir "build" do 
        system "cmake", *std_cmake_args, ".."
        system "make", "install"
        prefix.install "install_manifest.txt"
    end

    # Make Bundle/GUI apps install inside the Cellar,  use linkapps to link into system
    inreplace prefix/"share/ECM/kde-modules/KDEInstallDirs.cmake", 
        '_define_absolute(BUNDLEDIR "/Applications/KDE"',
        '_define_absolute(BUNDLEDIR ${CMAKE_INSTALL_PREFIX}'
            
    
    # Make findable from QStandardPaths:
    ln_sf HOMEBREW_PREFIX/"share/kf5", "#{Etc.getpwuid.dir}/Library/Application Support"
  end
end
