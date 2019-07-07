# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils systemd user

# Keep this in sync with external/{miniupnp,rapidjson,unbound}
MINIUPNP_COMMIT="6a63f9954959119568fbc4af57d7b491b9428d87"
RAPIDJSON_COMMIT="af223d44f4e8d3772cb1ac0ce8bc2a132b51717f"
UNBOUND_COMMIT="193bdc4ee3fe2b0d17e547e86512528c2614483a"
MINIUPNP_P="miniupnp-${MINIUPNP_COMMIT}"
RAPIDJSON_P="rapidjson-${RAPIDJSON_COMMIT}"
UNBOUND_P="unbound-${UNBOUND_COMMIT}"

DESCRIPTION="The secure, private and untraceable cryptocurrency"
HOMEPAGE="https://getmonero.org"
SRC_URI="
	https://github.com/monero-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/monero-project/miniupnp/archive/${MINIUPNP_COMMIT}.tar.gz -> ${MINIUPNP_P}.tar.gz
	https://github.com/Tencent/rapidjson/archive/${RAPIDJSON_COMMIT}.tar.gz -> ${RAPIDJSON_P}.tar.gz
	!system-unbound? ( https://github.com/monero-project/unbound/archive/${UNBOUND_COMMIT}.tar.gz -> ${UNBOUND_P}.tar.gz )
"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+daemon doc dot libressl readline +simplewallet +system-unbound unwind utils"
REQUIRED_USE="dot? ( doc )"

CDEPEND="
	app-arch/xz-utils
	dev-libs/boost:0=[nls,threads(+)]
	dev-libs/expat
	dev-libs/libsodium
	net-libs/cppzmq
	net-libs/ldns
	net-libs/miniupnpc
	sys-apps/pcsc-lite
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	readline? ( sys-libs/readline:0= )
	system-unbound? ( net-dns/unbound:=[threads] )
	unwind? ( sys-libs/libunwind )
"
DEPEND="${CDEPEND}
	doc? ( app-doc/doxygen[dot?] )
"
RDEPEND="${CDEPEND}
	daemon? ( !net-p2p/monero-gui[daemon] )
	simplewallet? ( !net-p2p/monero-gui[simplewallet] )
	utils? ( !net-p2p/monero-gui[utils] )
"

#PATCHES=( "${FILESDIR}/${PN}-0.12.1.0-fix_cmake.patch" )

pkg_setup() {
	if use daemon; then
		enewgroup monero
		enewuser monero -1 -1 /var/lib/monero monero
	fi
}

src_prepare() {
	rmdir external/{miniupnp,rapidjson,unbound} || die

	# Move dependencies
	mv "${WORKDIR}/${MINIUPNP_P}" external/miniupnp || die
	mv "${WORKDIR}/${RAPIDJSON_P}" external/rapidjson || die
	if ! use system-unbound; then
		mv "${WORKDIR}/${UNBOUND_P}" external/unbound || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# shellcheck disable=SC2191,SC2207
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DINSTALL_VENDORED_LIBUNBOUND=$(usex system-unbound OFF ON)
		-DSTACK_TRACE=$(usex unwind ON OFF)
		-DUSE_READLINE=$(usex readline ON OFF)
	)
	cmake-utils_src_configure
}

src_compile() {
	use daemon && emake -C "${BUILD_DIR}"/src/daemon

	if use simplewallet; then
		emake -C "${BUILD_DIR}"/src/simplewallet
		emake -C "${BUILD_DIR}"/src/wallet
	fi

	use utils && emake -C "${BUILD_DIR}"/src/blockchain_utilities

	if use doc; then
		pushd "${CMAKE_USE_DIR}" || die
		HAVE_DOT=$(usex dot) doxygen Doxyfile
		popd || die
	fi
}

src_install() {
	pushd "${BUILD_DIR}"/bin || die
	if use daemon; then
		dobin monerod

		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
		systemd_dounit "${FILESDIR}/${PN}.service"

		insinto /etc/monero
		newins "${S}"/utils/conf/monerod.conf monerod.conf.example

		diropts -o monero -g monero -m 0750
		keepdir /var/log/monero
		keepdir /var/lib/monero
	fi

	if use simplewallet; then
		dobin monero-wallet-cli
		dobin monero-wallet-rpc
	fi

	if use utils; then
		dobin monero-blockchain-export
		dobin monero-blockchain-import
	fi
	popd || die

	if use doc; then
		docinto html
		dodoc -r doc/html/*
	fi
}

pkg_postinst() {
	if use daemon; then
		if [[ $(stat -c %a "${EROOT%/}/var/lib/monero") != "750" ]]; then
			einfo "Fixing ${EROOT%/}/var/lib/monero permissions"
			chown -R monero:monero "${EROOT%/}/var/lib/monero" || die
			chmod 0750 "${EROOT%/}/var/lib/monero" || die
		fi

		if [[ ! -e "${EROOT%/}/etc/monero/monerod.conf" ]]; then
			elog "No monerod.conf found, copying the example over"
			cp "${EROOT%/}"/etc/monero/monerod.conf{.example,} || die
		fi
	fi
}
