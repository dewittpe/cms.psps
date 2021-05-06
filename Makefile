PKG_ROOT    = .
PKG_VERSION = $(shell gawk '/^Version:/{print $$2}' $(PKG_ROOT)/DESCRIPTION)
PKG_NAME    = $(shell gawk '/^Package:/{print $$2}' $(PKG_ROOT)/DESCRIPTION)

CRAN = "https://cran.rstudio.com"

RFILES    = $(wildcard $(PKG_ROOT)/R/*.R)
TESTS     = $(wildcard $(PKG_ROOT)/tests/testthat/*.R)
VIGNETTES = $(PKG_ROOT)/vignettes/cms.psps-introduction.html

.PHONY: all check install clean

all: $(PKG_NAME)_$(PKG_VERSION).tar.gz

.document.Rout: $(RFILES) $(SRC) $(EXAMPLES) $(RAWDATAR) $(VIGNETTES) $(PKG_ROOT)/DESCRIPTION
	Rscript --vanilla --quiet -e "options(repo = c('$(CRAN)'))" \
		-e "options(warn = 2)" \
		-e "devtools::document('$(PKG_ROOT)')"
	@touch $@

$(PKG_ROOT)/vignettes/cms.psps-introduction.html : vignette-spinners/cms.psps-introduction.R
	R --vanilla --quiet -e "knitr::spin(hair = '$<', knit = FALSE)"\
		-e "rmarkdown::render('$(basename $<).Rmd')"
	mv $(basename $<).html $@

$(PKG_NAME)_$(PKG_VERSION).tar.gz: .document.Rout $(TESTS) $(PKG_ROOT)/DESCRIPTION
	R CMD build --no-resave-data --md5 $(build-options) $(PKG_ROOT)

check: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check $(PKG_NAME)_$(PKG_VERSION).tar.gz

install: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD INSTALL $(PKG_NAME)_$(PKG_VERSION).tar.gz

clean:
	$(RM)  $(PKG_NAME)_$(PKG_VERSION).tar.gz
	$(RM) -r $(PKG_NAME).Rcheck
	$(RM) .document.Rout

