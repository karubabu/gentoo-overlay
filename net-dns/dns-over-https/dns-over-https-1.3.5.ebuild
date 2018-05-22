# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit systemd

DESCRIPTION="Client and server software to query DNS over HTTPS"

HOMEPAGE="https://github.com/m13253/dns-over-https"

SRC_URI="https://github.com/m13253/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"


LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64"

# Comprehensive list of any and all USE flags leveraged in the ebuild,
# with some exceptions, e.g., ARCH specific flags like "amd64" or "ppc".
# Not needed if the ebuild doesn't use any USE flags.
IUSE="client server"
REQUIRED_USE="|| ( client server )"

DEPEND="
>=dev-lang/go-1.10.1
>=dev-vcs/git-2.17.0"

# Run-time dependencies. Must be defined to whatever this depends on to run.
# The below is valid if the same run-time depends are required to compile.
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e 's/usr\/bin/bin/g' NetworkManager/dispatcher.d/doh-client || die
	sed -i -e 's/usr\/bin/bin/g' NetworkManager/dispatcher.d/doh-server || die
}
# The following src_configure function is implemented as default by portage, so
# you only need to call it if you need a different behaviour.
#src_configure() {
	# Most open-source packages use GNU autoconf for configuration.
	# The default, quickest (and preferred) way of running configure is:
	#econf
	#
	# You could use something similar to the following lines to
	# configure your package before compilation.  The "|| die" portion
	# at the end will stop the build process if the command fails.
	# You should use this at the end of critical commands in the build
	# process.  (Hint: Most commands are critical, that is, the build
	# process should abort if they aren't successful.)
	#./configure \
	#	--host=${CHOST} \
	#	--prefix=/usr \
	#	--infodir=/usr/share/info \
	#	--mandir=/usr/share/man || die
	# Note the use of --infodir and --mandir, above. This is to make
	# this package FHS 2.2-compliant.  For more information, see
	#   https://www.pathname.com/fhs/
#}

# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
src_compile() {
	# emake is a script that calls the standard GNU make with parallel
	# building options for speedier builds (especially on SMP systems).
	# Try emake first.  It might not work for some packages, because
	# some makefiles have bugs related to parallelism, in these cases,
	# use emake -j1 to limit make to a single process.  The -j1 is a
	# visual clue to others that the makefiles have bugs that have been
	# worked around.

	if use client ; then
		emake doh-client/doh-client
	fi
	if use server ; then
		emake doh-server/doh-server
	fi
}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
src_install() {
	# You must *personally verify* that this trick doesn't install
	# anything outside of DESTDIR; do this by reading and
	# understanding the install part of the Makefiles.
	# This is the preferred way to install.
	#emake DESTDIR="${D}" install

	# When you hit a failure with emake, do not just use make. It is
	# better to fix the Makefiles to allow proper parallelization.
	# If you fail with that, use "emake -j1", it's still better than make.

	# For Makefiles that don't make proper use of DESTDIR, setting
	# prefix is often an alternative.  However if you do this, then
	# you also need to specify mandir and infodir, since they were
	# passed to ./configure as absolute paths (overriding the prefix
	# setting).
	#emake \
	#	prefix="${D}"/usr \
	#	mandir="${D}"/usr/share/man \
	#	infodir="${D}"/usr/share/info \
	#	libdir="${D}"/usr/$(get_libdir) \
	#	install
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.
	DESTDIR="${D}"
	PREFIX="/usr/local"
	CONFDIR="/etc/dns-over-https"

	mkdir -p "${DESTDIR}${PREFIX}/bin/"
	mkdir -p "${DESTDIR}${CONFDIR}/"

	if use client ; then
		install -m0755 doh-client/doh-client "${DESTDIR}${PREFIX}/bin/doh-client"
		[ -e "${DESTDIR}${CONFDIR}/doh-client.conf" ] || install -m0644 doh-client/doh-client.conf "${DESTDIR}${CONFDIR}/doh-client.conf"
	fi
	if use server ; then
		install -m0755 doh-server/doh-server "${DESTDIR}${PREFIX}/bin/doh-server"
		[ -e "${DESTDIR}${CONFDIR}/doh-server.conf" ] || install -m0644 doh-server/doh-server.conf "${DESTDIR}${CONFDIR}/doh-server.conf"
	fi

	if use client ; then
		systemd_dounit "${S}/systemd/doh-client.service"
	fi
	if use server ; then
		systemd_dounit "${S}/systemd/doh-server.service"
	fi
	emake -C NetworkManager install "DESTDIR=${DESTDIR}"
}
