# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils

DESCRIPTION="fcitx-skk is an input method engine for Fcitx, which uses libskk as its backend."
HOMEPAGE="https://gitlab.com/fcitx/fcitx-skk"

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/karubabu/fcitx-skk.git"
else
	SRC_URI="https://github.com/fcitx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
>=app-i18n/fcitx-qt5-1.2.3
>=app-i18n/libskk-1.0.1"
DEPEND="${RDEPEND}"

DOCS=()

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
