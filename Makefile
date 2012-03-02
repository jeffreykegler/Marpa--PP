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

.PHONY: libs dummy full html_test pp_etc_make 

dummy: 

html_blib:
	(cd html && ./Build code)

pp_etc_make:
	(cd pp/etc && make)

pp_full_test: pplib pp_etc_make pp_html_test

full_test: pp_full_test

html_test:
	test -d stage && rm -rf stage
	mkdir stage
	cpanm -v --reinstall -l stage ./pp/
	PERL5LIB=$(CURDIR)/noxs/lib:$(CURDIR)/stage:$$PERL5LIB \
	    cpanm -v --reinstall -l stage Marpa::HTML

install:
	(cd pp && perl Build.PL)
	(cd pp && ./Build code)
	(cd html && perl Build.PL)
	(cd html && ./Build code)
