# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod eutils git-r3

DESCRIPTION="Updated driver for rtl88x2bu wifi adaptors based on rtl88x2BU_WiFi_linux_v5.2.4.4_26334.20180126_COEX20171012-5044."
HOMEPAGE="https://github.com/cilynx/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/cilynx/rtl88x2BU_WiFi_linux_v5.3.1_27678.20180430_COEX20180427-5959"
	KEYWORDS=""
else
	# Space for future releases
	# SRC_URI=""
	# S=""
	# KEYWORDS=""
	sleep 0
fi

LICENSE="MIT"
SLOT="0"

MODULE_NAMES="88x2bu(kernel/drivers/net/wireless:${S})"
BUILD_TARGETS="modules"

src_prepare() {
	sed -i -e "s:-C \$(KSRC):-C /lib/modules/${KV_FULL}/build:" Makefile || die "Sed faild!"
	eapply_user
}

pkg_setup() {
	linux-mod_pkg_setup
    kernel_is ge 5 0 0 && EGIT_BRANCH="linux-5.0"
}

src_compile() {
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}
