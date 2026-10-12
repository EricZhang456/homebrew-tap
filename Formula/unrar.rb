class Unrar < Formula
  desc "Unarchiver for .rar files"
  homepage "https://www.rarlab.com/rar_add.htm"
  url "https://www.rarlab.com/rar/unrarsrc-7.3.1.tar.gz"
  sha256 "634900842a3737d9cc15bbcc71d4c74cc713437e0bca296a573424fe5f2660ab"
  license "UnRAR"

  revision 1

  bottle do
    root_url "https://ghcr.io/v2/ericzhang456/tap"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe0056f74aee42ef329add57b7cea9d868fd20f3d62f5694245a6413375e26bb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2af69e730fec3461fd719fe13c9b7c553150df5c0c98cdc16ccf3e06c3bf63a"
    sha256 cellar: :any,                 x86_64_linux:      "b384fb95d0fab4dd195034af2999388ade3fba27af91efbedacc5bea9abd2199"
  end

  depends_on "coreutils" => :build
  conflicts_with cask: "rar", because: "rar also ships with unrar"

  patch :DATA

  deny_network_access!

  def install
    ENV.deparallelize
    system "make", "STRIP=true", "DESTDIR=#{prefix}"
    system "make", "STRIP=true", "DESTDIR=#{prefix}", "install"
  end

  test do
    system bin/"unrar"
  end
end

__END__
diff --git a/makefile b/makefile
index f7fe61a..d8e07e6 100644
--- a/makefile
+++ b/makefile
@@ -66,14 +66,14 @@ lib:	$(OBJECTS) $(LIB_OBJ)
 	$(AR) rcs libunrar.a $(OBJECTS) $(LIB_OBJ)
 
 install-unrar:
-			install -D unrar $(DESTDIR)/bin/unrar
+			ginstall -D unrar $(DESTDIR)/bin/unrar
 
 uninstall-unrar:
 			rm -f $(DESTDIR)/bin/unrar
 
 install-lib:
-		install libunrar.so $(DESTDIR)/lib
-		install libunrar.a $(DESTDIR)/lib
+		ginstall libunrar.so $(DESTDIR)/lib
+		ginstall libunrar.a $(DESTDIR)/lib
 
 uninstall-lib:
 		rm -f $(DESTDIR)/lib/libunrar.so
