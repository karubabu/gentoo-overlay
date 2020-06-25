# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Backend-agnostic network configuration in YAML"

HOMEPAGE="https://netplan.io/"

SRC_URI="https://github.com/CanonicalLtd/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64"

IUSE="systemd"
REQUIRED_USE="systemd"

DEPEND="
>=dev-libs/glib-2.64.3
>=dev-libs/libyaml-0.2.5
>=app-text/pandoc-1.19.2.1-r1"

RDEPEND="
>=dev-python/netifaces-0.10.9
>=dev-libs/libyaml-0.2.5
>=dev-python/pyyaml-5.3.1[libyaml(+)]"

src_prepare() {
	if has_version ">=sys-devel/gcc-10.1.0-r1"; then
		eapply "${FILESDIR}/${PV}/0001-Porting-to-GCC-10.patch"
	fi

	sed -i -e "s:\$(DOCDIR)/netplan:\$(DOCDIR)/${PF}:" Makefile || die

	# baselayout-1 compat
	if has_version ">=sys-apps/baselayout-2.0.0"; then
		sed -i -e 's:sbin/wpa_supplicant:usr/sbin/wpa_supplicant:' src/networkd.c || die
	fi

	eapply_user
}

src_install() {
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake DESTDIR="${D}" LIBDIR="\${PREFIX}/$(get_libdir)" install
	fi
	einstalldocs
}
