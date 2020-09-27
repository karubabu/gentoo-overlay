# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A temporary email right from your terminal by 1secmail."
HOMEPAGE="https://github.com/sdushantha/tmpmail"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sdushantha/tmpmail.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	SRC_URI=""
	sleep 0
fi

LICENSE="MIT"
SLOT="0"
RDEPEND=">=net-misc/curl-7.72.0
>=app-misc/jq-1.6-r3
virtual/awk
>=www-client/w3m-0.5.3_p20190105"

src_install() {
	dobin tmpmail || die "Install failed."
}
