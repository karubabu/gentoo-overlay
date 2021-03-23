# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit cmake
DESCRIPTION="Qt library and IM module for fcitx5 "
HOMEPAGE="https://github.com/fcitx/fcitx5-qt https://fcitx-im.org"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcitx/fcitx5-qt.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/fcitx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="BSD LGPL-2.1+"
SLOT="5"
IUSE="+qt5 -qt6 -only-plugin -static-plugin +fcitx-plugin-name"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="
x11-libs/libxkbcommon
x11-libs/libXext
sys-devel/gettext
app-i18n/fcitx5
qt5? ( dev-qt/qtgui:5 dev-qt/qtdbus:5 dev-qt/qtwidgets:5 dev-qt/qtcore:5 dev-qt/qtconcurrent:5 dev-qt/qtcore:5 )
qt6? ( dev-qt/qtgui:6 dev-qt/qtdbus:6 dev-qt/qtwidgets:6 dev-qt/qtcore:6 dev-qt/qtconcurrent:6 dev-qt/qtcore:6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
kde-frameworks/extra-cmake-modules:5
virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_INSTALL_FULL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_QT4=NO
		-DENABLE_QT5=$(usex qt5)
		-DENABLE_QT6=$(usex qt6)
		-DBUILD_ONLY_PLUGIN=$(usex only-plugin)
		-DBUILD_STATIC_PLUGIN=$(usex static-plugin)
		-DWITH_FCITX_PLUGIN_NAME=$(usex fcitx-plugin-name)
	)

	cmake_src_configure
}
