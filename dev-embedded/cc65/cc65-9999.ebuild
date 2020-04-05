# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Aa freeware C compiler for 6502 based systems"
HOMEPAGE="https://cc65.github.io/cc65/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/V${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="zlib"
SLOT="0"
IUSE="doc"

DEPEND="doc? ( app-text/linuxdoc-tools )"
RDEPEND=""

src_compile() {
    PREFIX=/usr emake
    use doc && emake -C doc
}

src_install() {
    PREFIX=/usr DESTDIR=${D} emake install
}
