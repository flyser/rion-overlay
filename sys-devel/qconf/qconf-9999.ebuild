# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

case $PV in *9999*) VCS_ECLASS="git-r3" ;; *) VCS_ECLASS="" ;; esac

inherit qmake-utils ${VCS_ECLASS}

DESCRIPTION="./configure like generator for qmake-based projects"
HOMEPAGE="https://github.com/psi-plus/qconf"

if [ -n "${VCS_ECLASS}" ]; then
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/psi-plus/qconf.git"
else
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
	SRC_URI="http://psi-im.org/files/qconf/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="qt4 +qt5"

# There is no one to one match to autotools-based configure
QA_CONFIGURE_OPTIONS=".*"

RDEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtxml:5
	)
"
DEPEND="${RDEPEND}"

REQUIRED_USE="^^ ( qt4 qt5 )"

src_configure() {
	use qt4 && QTVERSION=4
	use qt5 && QTVERSION=5
	econf \
		--qtselect="${QTVERSION}" \
		--extraconf=QMAKE_STRIP= \
		--verbose || die

	# just to set all the Gentoo toolchain flags
	eqmake${QTVERSION}
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	insinto /usr/share/doc/${PF}
	doins -r examples
}
