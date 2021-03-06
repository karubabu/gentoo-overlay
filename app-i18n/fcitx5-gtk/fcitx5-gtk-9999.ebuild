# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

inherit cmake git-r3
DESCRIPTION="gtk im module and glib based dbus client library "
HOMEPAGE="https://github.com/fcitx/fcitx5-gtk"

EGIT_REPO_URI="https://github.com/fcitx/fcitx5-gtk.git"

LICENSE="LGPL-2.1+"
SLOT="5"
IUSE="+introspection +gtk2 +gtk3 +snooper"
RDEPEND="
dev-libs/glib:2
dev-libs/gobject-introspection
x11-libs/libXext
x11-libs/libX11
gtk2? ( x11-libs/gtk+:2 )
gtk3? ( x11-libs/gtk+:3 )
x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}"

BDEPEND="virtual/pkgconfig
kde-frameworks/extra-cmake-modules:5"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_FULL_LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		-DCMAKE_INSTALL_FULL_SYSCONFDIR="${EPREFIX}/etc"
		-DENABLE_GIR=$(usex introspection)
		-DENABLE_GTK2_IM_MODULE=$(usex gtk2)
		-DENABLE_GTK3_IM_MODULE=$(usex gtk3)
		-DENABLE_SNOOPER=$(usex snooper)
	)

	cmake_src_configure
}
