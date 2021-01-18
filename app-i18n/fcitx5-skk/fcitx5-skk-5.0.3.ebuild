# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit cmake
DESCRIPTION="fcitx-skk is an input method engine for Fcitx, which uses libskk as its backend."
HOMEPAGE="https://github.com/fcitx/fcitx5-skk"
SRC_URI="https://github.com/fcitx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE=""
SLOT="5"
KEYWORDS="~amd64"

IUSE="+qt"

RDEPEND="
app-i18n/libskk
app-i18n/fcitx5
sys-devel/gettext
dev-libs/glib
qt? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 )"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig
kde-frameworks/extra-cmake-modules:5"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_INSTALL_FULL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_QT=$(usex qt)
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
