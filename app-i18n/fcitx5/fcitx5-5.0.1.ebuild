# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit cmake xdg-utils
DESCRIPTION="Fcitx 5 is a generic input method framework released under LGPL-2.1+."
HOMEPAGE="https://github.com/fcitx/fcitx5 https://fcitx-im.org/"

if [[ "${PV}" =~ (^|\.)9999$ ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcitx/fcitx5.git"
	SRC_URI="https://download.fcitx-im.org/data/en_dict-20121020.tar.gz -> fcitx-data-en_dict-20121020.tar.gz"
	KEYWORDS=""
else
	SRC_URI="https://download.fcitx-im.org/data/en_dict-20121020.tar.gz -> fcitx-data-en_dict-20121020.tar.gz
	https://github.com/fcitx/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="5"
IUSE="systemd test coverage +enchant presage wayland doc +xdgautostart"
RDEPEND="
systemd? ( >=sys-apps/systemd-247_rc2 )
!systemd? ( sys-apps/dbus )
!systemd? ( >=dev-libs/libevent-2.1.12 )
doc? ( >=app-doc/doxygen-1.8.17 )
coverage? ( >=dev-util/lcov-1.15 )
>=sys-devel/gettext-0.21
>=dev-libs/libfmt-7.1.2
>=x11-libs/libxcb-1.14
>=x11-libs/xcb-util-0.4.0-r2
>=x11-libs/xcb-util-wm-0.4.1-r3
>=x11-libs/xcb-util-keysyms-0.4.0-r2
>=x11-libs/libxkbcommon-1.0.1-r1
>=x11-libs/xcb-imdkit-1.0.0
>=app-text/iso-codes-4.5.0
>=dev-libs/expat-2.2.10
>=x11-misc/xkeyboard-config-2.31
>=dev-libs/json-c-0.15
>=x11-libs/libxkbfile-1.1.0
>=x11-libs/cairo-1.16.0-r4
>=x11-libs/pango-1.42.4-r2
>=x11-libs/gdk-pixbuf-2.40.0
>=dev-libs/glib-2.66.2
>=app-i18n/cldr-emoji-annotation-37
wayland? ( dev-libs/wayland-protocols )
wayland? ( dev-libs/wayland )
enchant? ( >=app-text/enchant-2.2.8:2= )
"

DEPEND="${RDEPEND}"
BDEPEND="
kde-frameworks/extra-cmake-modules:5
virtual/pkgconfig
virtual/libintl"

REQUIRED_USE="coverage? ( test )"
RESTRICT="!test? ( test )"

src_prepare() {
	ln -s "${DISTDIR}/fcitx-data-en_dict-20121020.tar.gz" src/modules/spell/dict/en_dict-20121020.tar.gz || die

	cmake_src_prepare
	xdg_environment_reset
}
src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_INSTALL_FULL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_TEST=$(usex test)
		-DENABLE_COVERAGE=$(usex coverage)
		-DENABLE_ENCHANT=$(usex enchant)
		-DENABLE_PRESAGE=$(usex presage)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_DOC=$(usex doc)
		-DUSE_SYSTEMD=$(usex systemd)
		-DENABLE_XDGAUTOSTART=$(usex xdgautostart)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
