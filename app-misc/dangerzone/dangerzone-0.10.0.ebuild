# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1 desktop

DESCRIPTION="Take potentially dangerous PDFs or images and convert them to a safe PDF"
HOMEPAGE="https://github.com/firstlookmedia/dangerzone"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/firstlookmedia/dangerzone"
else
	SRC_URI="https://github.com/firstlookmedia/dangerzone/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="test"
RESTRICT="test"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pymupdf[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/pyside[${PYTHON_USEDEP},svg]
	app-containers/podman
	app-containers/cosign
	dev-python/pytesseract
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	dev-python/poetry-core[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	default
		# Flatpak / bundled runtime references are useless on Gentoo
	sed -i \
		-e '/flatpak/d' \
		-e '/docker build/d' \
		pyproject.toml || die
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/dangerzone
	doins -r share/*
	insinto /usr/share/dangerzone/vendor
	dosym /usr/bin/cosign /usr/share/dangerzone/vendor/cosign
}
