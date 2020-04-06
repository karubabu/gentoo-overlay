# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="プログラミング用日本語等幅フォント Cica(シカ)"
HOMEPAGE="https://github.com/miiton/Cica"

MY_P="Cica"
SRC_URI="emoji? ( https://github.com/miiton/Cica/releases/download/v${PV}/${MY_P}_v${PV}_with_emoji.zip -> ${MY_P}.zip )
        !emoji? ( https://github.com/miiton/Cica/releases/download/v${PV}/${MY_P}_v${PV}_without_emoji.zip -> ${MY_P}.zip )"

LICENSE="Apache-2.0 custom:OFL-1.1 MIT CC-BY-4.0 BitstreamVera"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+emoji"

RESTRICT="binchecks strip mirror"
S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="COPYRIGHT* LICENSE*"
