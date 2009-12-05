#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
# Todo: require vislcg3 >= 0.9.7.5129

AC_PREREQ(2.52)

m4_define([required_apertium_version], [3.0.0])
m4_define([required_lttolbox_version], [3.1.2])

AC_INIT([apertium-nn-nb], [0.6.1], [unhammer@gmail.com])
AM_INIT_AUTOMAKE([apertium-nn-nb], [0.6.1], no-define)
AC_PROG_LN_S
AC_PROG_AWK
# todo: needed?
# AC_CONFIG_HEADER([config])

AC_DEFUN([PKG_CHECK_APERTIUM], [
  APERTIUM_VER=0
  PKG_CHECK_MODULES(APERTIUM, apertium-3.0 >= 3.0.0,
  [
    APERTIUM_VER=30
  ],
  [
    PKG_CHECK_MODULES(APERTIUM, apertium-3.1 >= 3.1.0,
    [
      APERTIUM_VER=31
    ],
    [
      PKG_CHECK_MODULES(APERTIUM, apertium-3.2 >= 3.2.0)
      APERTIUM_VER=32
    ])
  ])
  AC_SUBST(APERTIUM_VER)
])

AC_DEFUN([PKG_CHECK_LTTOOLBOX], [
  LTTOOLBOX_VER=0
  PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox-3.0 >= 3.0.0,
  [
    LTTOOLBOX_VER=30
  ],
  [
    PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox-3.1 >= 3.1.0,
    [
      LTTOOLBOX_VER=31
    ],
    [
      PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox-3.2 >= 3.2.0)
      LTTOOLBOX_VER=32
    ])
  ])
  AC_SUBST(LTTOOLBOX_VER)
])

PKG_CHECK_APERTIUM
PKG_CHECK_LTTOOLBOX


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


AC_OUTPUT([Makefile])
