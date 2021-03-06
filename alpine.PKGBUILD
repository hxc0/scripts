# -*- shell-script -*-
#
# Contributor: Adrian C. <anrxc..sysphere.org>

pkgname=alpine
pkgver=2.21
pkgrel=1
arch=("i686" "x86_64")
pkgdesc="Apache licensed PINE mail user agent"
url="http://alpine.freeiz.com"
license=("APACHE")
depends=("libldap" "krb5" "gettext")
optdepends=("aspell: for spell-checking support"
	    "hunspell: for spell-checking support"
            "topal: glue program that links GnuPG and alpine")
provides=("pine")
conflicts=("pine" "re-alpine")
replaces=("pine")
options=("!makeflags")
source=(http://alpine.freeiz.com/${pkgname}/release/src/${pkgname}-${pkgver}.tar.xz
        #ftp://ftp.cac.washington.edu/${pkgname}/${pkgname}.tar.bz2
        http://alpine.freeiz.com/${pkgname}/patches/${pkgname}-${pkgver}/all.patch.gz)
        #topal-1.patch
        #topal-2.patch)
md5sums=("02dad85c1be80ce020206f222ecf5ac8"
	 "0f44e09742442f7aa7c50b40bb957f8b")

build() {
  cd "${srcdir}/${pkgname}-${pkgver}"

# User compile time patches
# - Eduardo Chappa patches
  patch -p1 < ../all.patch
# - Phil Brooke patches (optional topal support)
  #patch -p1 < ../topal-1.patch
  #patch -p1 < ../topal-2.patch


# Configure Alpine
  LIBS+="-lpam -lkrb5 -lcrypto" ./configure --prefix=/usr \
  --with-passfile=.config/${pkgname}/.passfile \
  --without-tcl --disable-shared \
  --with-system-pinerc=/etc/${pkgname}.d/pine.conf \
  --with-system-fixed-pinerc=/etc/${pkgname}.d/pine.conf.fixed \
  --with-smime-public-cert-directory=.config/${pkgname}/.alpine-smime/public \
  --with-smime-private-key-directory=.config/${pkgname}/.alpine-smime/private \
  --with-smime-cacert-directory=.config/${pkgname}/.alpine-smime/ca

# Build Alpine
  make
}


package() {
  cd "${srcdir}/${pkgname}-${pkgver}"

# Install Alpine
  make DESTDIR="${pkgdir}" install
}
