require "formula"

class Kf5Kcoreaddons < Formula
  url "http://download.kde.org/stable/frameworks/5.15/kcoreaddons-5.15.0.tar.xz"
  sha1 "8975d23a57714051d893b72733d8a45b3ed93dda"
  homepage "http://www.kde.org/"

  head 'git://anongit.kde.org/kcoreaddons.git'

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt5" => "with-d-bus"
  depends_on "shared-mime-info"

  def install

    # don't create mime-databae in Keg -- do this later
    inreplace "src/mimetypes/CMakeLists.txt", 
        'update_xdg_mimetypes(',
        '#update_xdg_mimetypes('


    args = std_cmake_args
    system "cmake", ".", *args
    system "make", "install"
    prefix.install "install_manifest.txt"

  end

  def post_install
    #create/update mime-database in homebrew system
    system "update-mime-database", HOMEBREW_PREFIX/"share/mime"  
  end

end
