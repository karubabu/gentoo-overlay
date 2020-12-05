# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit cmake xdg-utils git-r3
DESCRIPTION="xcb-imdkit is an implementation of xim protocol in xcb, comparing with the implementation of IMDkit with Xlib, and xim inside Xlib, it has less memory foot print, better performance, and safer on malformed client."
HOMEPAGE="https://github.com/fcitx/xcb-imdkit"
EGIT_REPO_URI="https://github.com/fcitx/xcb-imdkit.git"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
RDEPEND="
>=x11-libs/xcb-util-0.4.0-r2
>=x11-libs/xcb-util-keysyms-0.4.0-r2"
DEPEND="${RDEPEND}
kde-frameworks/extra-cmake-modules:5
virtual/pkgconfig"

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake_src_configure
}
