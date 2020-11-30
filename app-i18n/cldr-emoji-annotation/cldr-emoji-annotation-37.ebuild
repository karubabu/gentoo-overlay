# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7
DESCRIPTION="CLDR annotation files."
HOMEPAGE="https://github.com/fujiwarat/cldr-emoji-annotation"

MY_PV="37.0_13.0_0_2"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${MY_PV}/${PN}-${MY_PV}.tar.gz"
LICENSE="unicode"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
!app-i18n/unicode-cldr"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	./configure || die
	eapply_user
}
