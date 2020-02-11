# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An SRE framework developed by the NSA Research Directorate"
HOMEPAGE="https://ghidra-sre.org"
PUBLIC_DATE="20191218"
SRC_URI="https://ghidra-sre.org/${MY_P/-/_}_PUBLIC_${PUBLIC_DATE}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+python +server"
S="${WORKDIR}/${MY_P/-/_}_PUBLIC"
RESTRICT="mirror strip"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}
	|| (
		virtual/jdk
		virtual/jre
	)
	python? ( ${PYTHON_DEPS} )
	server? ( virtual/pam )
	!dev-util/ghidra
"

QA_PRESTRIPPED="/opt/ghidra/docs/GhidraClass/ExerciseFiles/Advanced/sharedReturn"

pkg_setup(){
	python-any-r1_pkg_setup
}

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
		Ghidra/Features/Decompiler/os/linux64/decompile
		GPL/DemanglerGnu/os/linux64/demangler_gnu
		GPL/DemanglerGnu/src/demangler_gnu
		GPL/CabExtract/os/linux64/cabextract

	"
	for f in ${BINARIES}; do
		fperms +x "${EPREFIX}/opt/${MY_PN}/${f}"
	done
}
