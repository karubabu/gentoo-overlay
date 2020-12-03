# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
DESCRIPTION="GTK+ GUI configuration tool for Fcitx"

HOMEPAGE="https://github.com/fcitx/fcitx5-configtool/"

SRC_URI="https://github.com/fcitx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"

SLOT="5"

KEYWORDS="~amd64"

IUSE="+kcm +qt -test"

RDEPEND="
sys-devel/gettext
x11-libs/libX11
x11-libs/libXext
x11-misc/xkeyboard-config
x11-libs/libxkbfile
app-text/iso-codes
app-i18n/fcitx5
app-i18n/fcitx5-qt
dev-qt/qtx11extras:5
dev-qt/qtgui:5
dev-qt/qtwidgets:5
dev-qt/qtcore:5
dev-qt/qtconcurrent:5
dev-qt/qtcore:5
qt? ( kde-frameworks/kitemviews:5 )
kcm? ( kde-frameworks/kcoreaddons:5 kde-frameworks/ki18n:5 kde-frameworks/kpackage:5 kde-frameworks/kdeclarative:5 kde-frameworks/kirigami:5 x11-libs/libxkbcommon )
"

DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig
kde-frameworks/extra-cmake-modules:5"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_INSTALL_FULL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_KCM=$(usex kcm)
		-DENABLE_CONFIG_QT=$(usex qt)
		-DENABLE_TEST=$(usex test)
	)

	cmake_src_configure
}
