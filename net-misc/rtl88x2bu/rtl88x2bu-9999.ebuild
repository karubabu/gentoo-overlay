# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info linux-mod

DESCRIPTION="Updated driver for rtl88x2bu wifi adaptors based on Realtek's source distributed with myriad adapters."
HOMEPAGE="https://github.com/cilynx/rtl88x2bu"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cilynx/rtl88x2bu"
	#EGIT_REPO_URI="https://github.com/karubabu/rtl88x2bu"
	#EGIT_BRANCH="5.6.1.6_35492.20191025_COEX20180928-6a6a"
	EGIT_BRANCH="5.8.7.1_35809.20191129_COEX20191120-7777"
	#EGIT_BRANCH="resolve-gcc11-warning-Werror=misleading-indentation"
	KEYWORDS=""
else
	# Space for future releases
	# SRC_URI=""
	# S=""
	# KEYWORDS=""
	sleep 0
fi

LICENSE="GPL-2"
SLOT="0"

MODULE_NAMES="88x2bu(kernel/drivers/net/wireless:${S})"
BUILD_TARGETS="modules"

src_prepare() {
	sed -i -e "s:-C \$(KSRC):-C /lib/modules/${KV_FULL}/build:" Makefile || die "Sed failed!"
	eapply_user
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_compile() {
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}
