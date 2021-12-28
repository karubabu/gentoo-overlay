# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7


MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An SRE framework developed by the NSA Research Directorate"
HOMEPAGE="https://ghidra-sre.org"
PUBLIC_DATE="20211221"
#SRC_URI="https://ghidra-sre.org/${MY_P/-/_}_PUBLIC_${PUBLIC_DATE}.zip"
SRC_URI="https://github.com/NationalSecurityAgency/${MY_PN}/releases/download/Ghidra_${PV}_build/${MY_PN}_${PV}_PUBLIC_${PUBLIC_DATE}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+server"
S="${WORKDIR}/${MY_P/-/_}_PUBLIC"
RESTRICT="mirror strip"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}
	|| (
		virtual/jdk
		virtual/jre
	)
	server? ( virtual/pam )
	!dev-util/ghidra
"

QA_PRESTRIPPED="/opt/ghidra/docs/GhidraClass/ExerciseFiles/Advanced/sharedReturn"

src_install(){
	insinto /opt/${MY_PN}
	doins -r *
	fperms -R a+r "${EPREFIX}/opt/${MY_PN}"
	dobin "${FILESDIR}/${MY_PN}"
	BINARIES="
		support/analyzeHeadless
		support/buildGhidraJar
		support/convertStorage
		support/ghidraDebug
		support/launch.sh
		support/pythonRun
		support/sleigh
		ghidraRun
		server/ghidraSvr
		server/svrAdmin
		server/svrInstall
		server/svrUninstall
		Ghidra/Features/Decompiler/os/linux_x86_64/decompile
		GPL/DemanglerGnu/os/linux_x86_64/demangler_gnu_v2_24
		GPL/DemanglerGnu/os/linux_x86_64/demangler_gnu_v2_33_1
	"
	for f in ${BINARIES}; do
		fperms +x "${EPREFIX}/opt/${MY_PN}/${f}"
	done
}
