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
>=dev-libs/glib-2.52.3
>=dev-libs/libyaml-0.1.7-r1
>=app-text/pandoc-1.19.2.1-r1"

RDEPEND="
>=dev-libs/libyaml-0.1.7-r1
>=dev-python/pyyaml-3.12[libyaml(+)]"

src_prepare() {
	default

	# baselayout-1 compat
	if has_version ">=sys-apps/baselayout-2.0.0"; then
		sed -i -e 's/sbin/usr\/sbin/' src/netplan-wpa@.service || die
	fi
}

src_install() {
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake DESTDIR="${D}" install
	fi
	einstalldocs
}
