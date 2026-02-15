# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_13 )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1
inherit toolchain-funcs distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pymupdf/${PN}.git"
else
	SRC_URI="https://github.com/pymupdf/PyMuPDF/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/PyMuPDF-${PV}"
fi

DESCRIPTION="A Python library for manipulation of PDF documents"
HOMEPAGE="https://pymupdf.readthedocs.io"

LICENSE="AGPL-3"
SLOT="0"

DEPEND="
	dev-python/mupdf
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig
"
distutils_enable_tests pytest

python_compile() {
	PYMUPDF_SETUP_FLAVOUR='p' \
	PYMUPDF_SETUP_MUPDF_BUILD= \
	PYMUPDF_SETUP_MUPDF_THIRD=0 \
	PYMUPDF_SETUP_MUPDF_REBUILD=0 \
	PYMUPDF_INCLUDES="${EPREFIX}/usr/include/mupdf" \
	PYMUPDF_MUPDF_LIB="${EPREFIX}/usr/$(get_libdir)" \
		distutils-r1_python_compile
}
