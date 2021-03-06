# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: psi-plugin.eclass
# @MAINTAINER:
# Rion <rion4ik@gmail.com>
# @BLURB: This eclass provides functions for build all plugin to net-im/psi
# package
# @DESCRIPTION:
# This eclass provides functions build all plugin to net-im/psi
# Original Author: Sergey Ilinykh <rion4ik@gmail.com>
# Purpose:

###
# variable declarations
###

MY_PN="${PN#psi-}plugin"

###
# Use scm or not ?
###


SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	PLUGIN_DIR="${PLUGIN_DIR:-generic}"
	EGIT_REPO_URI="git://github.com/psi-im/plugins.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/plugins"
elif [ "${PV%%.*}" = 1 ] ; then
	REQUIRED_USE="^^ ( qt4 qt5 )"
	IUSE="+qt4 qt5"
fi

inherit qmake-utils ${SCM}

# general common

HOMEPAGE="https://github.com/psi-im/"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	S="${WORKDIR}/plugins/${PLUGIN_DIR}/${MY_PN}"
else
	SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"


DEPEND=">=net-im/psi-9999"
RDEPEND="${DEPEND}"

# Eclass exported functions
EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_install

psi-plugin_src_unpack() {
	if [ -n "$SCM" ]; then
		git-r3_src_unpack
	else
		default
	fi
}

psi-plugin_src_prepare() {
	default
	sed -e 's#\.\./\.\./psiplugin.pri#/usr/share/psi-plus/plugins/psiplugin.pri#' \
               -i "${MY_PN}".pro || die
}

psi-plugin_src_configure() {
	if [ "${PV%%.*}" = 1 ] ; then
		use qt4 && eqmake4 "${MY_PN}".pro
		use qt5 && eqmake5 "${MY_PN}".pro
	else
		eqmake5 "${MY_PN}".pro
	fi
}

psi-plugin_src_install() {
	emake install INSTALL_ROOT="${D}"
}
