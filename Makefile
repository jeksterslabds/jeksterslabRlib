PREFIX=$(HOME)/scripts/r
PKG=$(PREFIX)/jeksterslabRlib

all :
	rm -rf ${PKG}/docs/*
	rm -rf ${PKG}/man/*
	rm -rf ${PKG}/tests/testthat/*.html
	rm -rf ${PKG}/tests/testthat/*.md
	rm -rf ${PKG}/vignettes/*.html
	rm -rf ${PKG}/vignettes/*.md
	Rscript -e 'jeksterslabRpkg::pkg_build("$(PKG)", data = FALSE, git = TRUE, github = TRUE)'
