AC_PREREQ(2.52)

AC_INIT([Apertium Nynorsk-Bokmål], [1.6.0], [apertium-stuff@lists.sourceforge.net], [apertium-nno-nob], [https://wiki.apertium.org/wiki/Apertium-nno-nob])
AM_INIT_AUTOMAKE
AC_PROG_AWK

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.9.12)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= 3.8.0)
PKG_CHECK_MODULES(CG3, cg3 >= 1.5.1)
PKG_CHECK_MODULES(APERTIUM_LEX_TOOLS, apertium-lex-tools >= 0.5.0)
PKG_CHECK_MODULES(APERTIUM_SEPARABLE, apertium-separable >= 0.7.1)

m4_ifdef([AP_CHECK_LING],[],[AC_MSG_ERROR([AP_CHECK_LING not defined, is apertium.m4 in ACLOCAL_PATH? See: https://wiki.apertium.org/wiki/Installation_troubleshooting])])

AP_CHECK_LING([1], [apertium-nno], [1.5.0])
AP_CHECK_LING([2], [apertium-nob], [1.5.0])

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.0.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

AP_MKINCLUDE

AC_OUTPUT([Makefile])
