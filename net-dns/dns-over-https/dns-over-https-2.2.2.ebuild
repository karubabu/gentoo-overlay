# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Client and server software to query DNS over HTTPS"

HOMEPAGE="https://github.com/m13253/dns-over-https"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64"

IUSE="client server"
REQUIRED_USE="|| ( client server )"

DEPEND="
>=dev-lang/go-1.13.7
>=dev-vcs/git-1.13.7"

RDEPEND="${DEPEND}"
EGO_PN="github.com/m13253/${PN}"

EGO_VENDOR=(
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/gorilla/handlers v1.4.0"
	"github.com/miekg/dns v1.1.27"
	"golang.org/x/crypto 87dc89f01550 github.com/golang/crypto"
	"golang.org/x/net 83d349e8ac1a github.com/golang/net"
	"golang.org/x/sys 33540a1f6037 github.com/golang/sys"
	"golang.org/x/text v0.3.2 github.com/golang/text"
)
inherit golang-vcs-snapshot

SRC_URI="https://github.com/m13253/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

src_prepare() {
	default

	sed -i -e 's/usr\/bin/bin/g' src/"${EGO_PN}"/NetworkManager/dispatcher.d/doh-client || die
	sed -i -e 's/usr\/bin/bin/g' src/"${EGO_PN}"/NetworkManager/dispatcher.d/doh-server || die
	sed -i -e 's:/usr/local:/usr:g' src/"${EGO_PN}"/systemd/doh-client.service || die
	sed -i -e 's:/usr/local:/usr:g' src/"${EGO_PN}"/systemd/doh-server.service || die
}

src_compile() {
	if use client ; then
		cd src/${EGO_PN}/doh-client || die
		go build -mod=vendor || die
	fi
	if use server ; then
		cd src/${EGO_PN}/doh-server || die
		go build -mod=vendor || die
	fi
}

src_install() {
	DESTDIR="${D}"
	PREFIX="/usr/bin"
	CONFDIR="/etc/dns-over-https"

	mkdir -p "${DESTDIR}${PREFIX}/"
	mkdir -p "${DESTDIR}${CONFDIR}/"

	if use client ; then
		install -m0755 src/${EGO_PN}/doh-client/doh-client "${DESTDIR}${PREFIX}/doh-client"
		[ -e "${DESTDIR}${CONFDIR}/doh-client.conf" ] || install -m0644 src/${EGO_PN}/doh-client/doh-client.conf "${DESTDIR}${CONFDIR}/doh-client.conf"
	fi
	if use server ; then
		install -m0755 src/${EGO_PN}/doh-server/doh-server "${DESTDIR}${PREFIX}/doh-server"
		[ -e "${DESTDIR}${CONFDIR}/doh-server.conf" ] || install -m0644 src/${EGO_PN}/doh-server/doh-server.conf "${DESTDIR}${CONFDIR}/doh-server.conf"
	fi

	if use client ; then
		systemd_dounit "${S}/src/${EGO_PN}/systemd/doh-client.service"
	fi
	if use server ; then
		systemd_dounit "${S}/src/${EGO_PN}/systemd/doh-server.service"
	fi
	emake -C src/"${EGO_PN}"/NetworkManager install "DESTDIR=${DESTDIR}"
}
