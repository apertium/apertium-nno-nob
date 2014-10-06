#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
# Todo: require vislcg3 >= 0.9.7.5129

AC_PREREQ(2.52)

m4_define([required_apertium_version], [3.3.0])
m4_define([required_lttolbox_version], [3.3.0])

AC_INIT([apertium-nno-nob], [1.0.0], [unhammer+apertium@mm.st])
AM_INIT_AUTOMAKE([apertium-nno-nob], [1.0.0], no-define)
AC_PROG_LN_S
AC_PROG_AWK

PKG_CHECK_MODULES(APERTIUM,   apertium >= required_apertium_version)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= required_lttolbox_version)

AC_PATH_PROG(CGCOMP, cg-comp, no)
if test x$ac_cv_path_CGCOMP = x
then
  AC_MSG_ERROR([You don't have cg-comp installed.])
fi
if test x$ac_cv_path_CGPROC = xno
then
  AC_MSG_ERROR([You don't have cg-comp installed.])
fi

AC_PATH_PROG(CGPROC, cg-proc, no)
if test x$ac_cv_path_CGPROC = x
then
  AC_MSG_ERROR([You don't have cg-proc installed.])
fi
if test x$ac_cv_path_CGPROC = xno
then
  AC_MSG_ERROR([You don't have cg-proc installed.])
fi

m4_ifdef([AP_CHECK_LING],[],[AC_MSG_ERROR([AP_CHECK_LING not defined, is apertium.m4 in ACLOCAL_PATH? See: http://wiki.apertium.org/wiki/Installation_troubleshooting])])

AP_CHECK_LING([1], [apertium-nno])
AP_CHECK_LING([2], [apertium-nob])

AP_MKINCLUDE

AC_OUTPUT([Makefile])
