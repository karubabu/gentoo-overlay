# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1 git-r3 systemd user

DESCRIPTION="A C++ daemon for monero and the i2p network"
HOMEPAGE="https://getkovri.org"
SRC_URI=""
EGIT_REPO_URI="https://github.com/monero-project/kovri.git"

LICENSE="BSD"
SLOT="0"
IUSE="static"

if [[ ${PV} == "9999" ]]; then
	KEYWORDS=""
else
	inherit versionator
	KEYWORDS="~amd64"
	MY_DATE="$(get_version_component_range 5)"
	MY_DATE="${MY_DATE#pre}"
	MY_DATE="${MY_DATE:0:4}-${MY_DATE:4:2}-${MY_DATE:6:2}"
	EGIT_COMMIT_DATE="${MY_DATE}"
fi

# upstream uses dev-libs/crypto++-7.0
# upstream uses dev-libs/cpp-netlib-0.13.x (release branch or rc1.tar.gz)
# make target 'release-static' needs dev-libs/boost[static-libs]
# make target 'release-static' needs openssl[static-libs]
RDEPEND="
	dev-libs/boost
	dev-libs/openssl:0=
	static? (
		dev-libs/boost:0=[static-libs]
		dev-libs/openssl:0=[static-libs,-zlib] )"
if [[ ${PV} == "9999" ]]; then
	RDEPEND+="
		>=dev-libs/crypto++-7.0.0:0=
		static? ( >=dev-libs/crypto++-7.0.0:0=[static-libs] )"
fi
DEPEND="${RDEPEND}
	dev-util/cmake"

KOVRI_USER=kovri
KOVRI_GROUP=kovri
KOVRI_CONF_DIR=/etc/kovri
KOVRI_DATA_DIR=/var/lib/kovri
KOVRI_LOG_DIR=/var/log/kovri

pkg_setup(){
	enewgroup "${KOVRI_GROUP}"
	enewuser "${KOVRI_USER}" -1 -1 /var/lib/run/kovri "${KOVRI_GROUP}"
}

src_prepare(){
	default
	if [[ ${PV} == "9999" ]]; then
		# dev-libs/crypto++ is in dependencies, disable building it
		sed -i 's/^release: release-deps$/release:/' Makefile || die "sed failed"
	fi
}

src_compile(){
	if use static; then
		emake release-static
	else
		emake release
	fi
}

src_install() {
	default

	# bin
	dobin "${HOME}/bin/${PN}"
	dobin "${HOME}/bin/${PN}-util"
	newbashcomp "${HOME}/bin/${PN}-bash.sh" ${PN}

	# config
	insinto ${KOVRI_CONF_DIR}
	doins "${HOME}"/.kovri/config/kovri.conf
	doins "${HOME}"/.kovri/config/tunnels.conf

	# grant kovri group read and write access to config files
	fowners -R "root:${KOVRI_GROUP}"  ${KOVRI_CONF_DIR}
	fperms 660 \
		${KOVRI_CONF_DIR}/kovri.conf \
		${KOVRI_CONF_DIR}/tunnels.conf

	# data directory
	insinto ${KOVRI_DATA_DIR}
	doins -r "${HOME}"/.kovri/client

	# log dir as symlink
	keepdir ${KOVRI_LOG_DIR}
	dosym "${EPREFIX}${KOVRI_LOG_DIR}/" "${EPREFIX}${KOVRI_DATA_DIR}/logs"

	# set owner for kovri data-dir
	# TODO: does not work recursive, why?
	fowners -R "${KOVRI_USER}:${KOVRI_GROUP}" ${KOVRI_DATA_DIR}
	fperms 700 ${KOVRI_DATA_DIR}

	# set owner for kovri log dir
	fowners "${KOVRI_USER}:${KOVRI_GROUP}" ${KOVRI_LOG_DIR}

	# maybe symlink from original location to conf-paths?
	# using --tunnelsconf and --kovriconf, on error, add the symlinks

	# add ${KOVRI_DATA_DIR}/certificates and ${KOVRI_CONF_DIR} files to CONFIG_PROTECT
	doenvd "${FILESDIR}/99kovri"

	# openrc and systemd daemon routines
	newconfd "${FILESDIR}/kovri.confd" kovri
	newinitd "${FILESDIR}/kovri.initd" kovri
	systemd_newunit "${FILESDIR}/kovri.service" kovri.service

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}/kovri.logrotate" kovri

	einstalldocs
}
