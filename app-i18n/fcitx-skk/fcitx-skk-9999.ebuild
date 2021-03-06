# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/karubabu/fcitx-skk.git"
else
	SRC_URI="https://github.com/fcitx/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="fcitx-skk is an input method engine for Fcitx, which uses libskk as its backend."
HOMEPAGE="https://gitlab.com/fcitx/fcitx-skk"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
>=app-i18n/fcitx-qt5-1.2.3
>=app-i18n/libskk-1.0.1
>=app-i18n/skk-jisyo-201905
>=dev-libs/json-glib-1.4.4
>=x11-libs/gtk+-3.24.14"
DEPEND="${RDEPEND}"

DOCS=()

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
