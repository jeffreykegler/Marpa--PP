# Copyright 2012 Jeffrey Kegler
# This file is part of Marpa::PP.  Marpa::PP is free software: you can
# redistribute it and/or modify it under the terms of the GNU Lesser
# General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Marpa::PP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser
# General Public License along with Marpa::PP.  If not, see
# http://www.gnu.org/licenses/.

.PHONY: libs dummy full pp_html_test pp_etc_make \
    pplib libs

dummy: 

libs: pplib

# PERL_MB_OPT unset to work around bug in Module::Build --
# if install_base is specified twice it turns into an array
# and the install breaks.
# Anyway, it may be good practice to unset it.
pplib:
	-mkdir dpplib
	-rm -rf dpplib/lib dpplib/man dpplib/html
	(cd pp && PERL_MB_OPT= ./Build install --install_base ../dpplib)

html_blib:
	(cd html && ./Build code)

pp_html_test: html_blib pplib
	(cd html && \
	PERL5LIB=$(CURDIR)/noxs/lib:$(CURDIR)/dpplib/lib/perl5:$$PERL5LIB prove -Ilib t )

pp_etc_make:
	(cd pp/etc && make)

pp_full_test: pplib pp_etc_make pp_html_test

full_test: pp_full_test

html_full_test:
	(cd html/etc && \
	    PERL5LIB=$(CURDIR)/noxs/lib:$(CURDIR)/dpplib/lib/perl5:$$PERL5LIB make )
	
install:
	(cd pp && perl Build.PL)
	(cd pp && ./Build code)
	(cd html && perl Build.PL)
	(cd html && ./Build code)
