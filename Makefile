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

.PHONY: dummy pp_test html_test full_test install

dummy: 

pp_test:
	cd pp;perl Build.PL
	cd pp;./Build realclean
	cd pp;perl Build.PL
	cd pp;./Build
	cd pp;./Build distmeta
	cd pp;./Build test
	cd pp;./Build distcheck
	cd pp;./Build dist

full_test: pp_test html_test

html_test:
	test -d stage && rm -rf stage
	mkdir stage
	cpanm -v --reinstall -l stage ./pp/
	PERL5LIB=$(CURDIR)/noxs/lib:$(CURDIR)/stage:$$PERL5LIB \
	    cpanm -v --reinstall -l stage Marpa::HTML

install:
	cd pp && perl Build.PL
	cd pp && ./Build code
