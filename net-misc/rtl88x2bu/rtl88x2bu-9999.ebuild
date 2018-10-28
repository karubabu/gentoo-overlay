# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info linux-mod eutils

DESCRIPTION="Updated driver for rtl88x2bu wifi adaptors based on rtl88x2BU_WiFi_linux_v5.2.4.4_26334.20180126_COEX20171012-5044."
HOMEPAGE="https://github.com/cilynx/rtl88x2BU_WiFi_linux_v5.2.4.4_26334.20180126_COEX20171012-5044"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cilynx/rtl88x2BU_WiFi_linux_v5.2.4.4_26334.20180126_COEX20171012-5044"
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

# CONFIG_CHECK="!R8169"
# ERROR_R8169="${P} requires Realtek 8169 PCI Gigabit Ethernet adapter (CONFIG_R8169) to be DISABLED"

# PATCHES=(
# 	"${FILESDIR}"/linux-4.15-2.patch
# )

src_prepare() {
	sed -i -e "s:EXTRA_CFLAGS += -Werror:EXTRA_CFLAGS += -Wno-error=incompatible-pointer-types:" Makefile || die "Sed failed!"
	sed -i -e "s:-C \$(KSRC):-C /lib/modules/${KV_FULL}/build:" Makefile || die "Sed faild!"
	eapply_user
}

pkg_setup() {
	linux-mod_pkg_setup
#	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
}

src_compile() {
#	BUILD_PARAMS="KERNELDIR=${KV_DIR}"
	BUILD_PARAMS="KERNELDIR=${KERNEL_DIR}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}
