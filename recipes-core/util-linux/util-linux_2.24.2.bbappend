FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

DEPENDS_class-target += "niacctbase"

RDEPENDS_util-linux-hwclock += "niacctbase"

SRC_URI =+ " file://removeSetUIDCheck.patch"

group = "${LVRT_GROUP}"

do_install_append() {
	chmod 4550 ${D}${base_sbindir}/hwclock
	chown 0:${group} ${D}${base_sbindir}/hwclock
}

# To delay the execution of the postinst to first boot, check $D and error
# if empty. Process explained in the Yocto Manual Post-Installation Scripts
# section.
pkg_postinst_util-linux-hwclock () {
	if [ x"$D" = "x" ]; then
		setcap CAP_SYS_TIME+ep ${base_sbindir}/hwclock.util-linux
	else
		exit 1
	fi
}