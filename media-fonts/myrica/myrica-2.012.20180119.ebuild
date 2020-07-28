# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_P="Myrica"
DESCRIPTION="Japanese font family for developers obtained by mixing Inconsolata and Genshin Gothic"
HOMEPAGE="http://myrica.estable.jp/"
SRC_URI="https://github.com/tomokuni/Myrica/blob/master/product/Myrica.zip?raw=true -> ${MY_P}_${PV}.zip"

LICENSE="Apache custom:OFL"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="binchecks strip"
S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="TTC"
DOCS="README* LICENSE*"
