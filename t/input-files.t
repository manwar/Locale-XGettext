#! /usr/bin/env perl

# Copyright (C) 2016-2017 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.

# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

use strict;

use Test::More tests => 9;

use Locale::XGettext::Text;

BEGIN {
    my $test_dir = __FILE__;
    $test_dir =~ s/[-a-z0-9]+\.t$//i;
    chdir $test_dir or die "cannot chdir to $test_dir: $!";
    unshift @INC, '.';
}

use TestLib qw(find_entries);

my @po = Locale::XGettext::Text->new({}, 
                                     'files/hello.txt', 
                                     'files/additional.txt')
                               ->run->po;
is((scalar find_entries \@po, msgid => qq{"Hello, world!"}), 1);
is((scalar find_entries \@po, msgid => qq{"Hello, Mars!"}), 1);
is((scalar find_entries \@po, msgid => qq{"Hello, extraterrestrials!"}), 0);

@po = Locale::XGettext::Text->new({files_from => ['POTFILES1']}, 
                                  'files/extra.txt')
                            ->run->po;
is((scalar find_entries \@po, msgid => qq{"Hello, world!"}), 1);
is((scalar find_entries \@po, msgid => qq{"Hello, Mars!"}), 1);
is((scalar find_entries \@po, msgid => qq{"Hello, extraterrestrials!"}), 1);

# Test that we can read from multiple files and that the entries are merged.
@po = Locale::XGettext::Text->new({files_from => ['POTFILES1', 'POTFILES2']})
                            ->run->po;
is((scalar find_entries \@po, msgid => qq{"Hello, world!"}), 1);
is((scalar find_entries \@po, msgid => qq{"Hello, Mars!"}), 1);
is((scalar find_entries \@po, msgid => qq{"Hello, extraterrestrials!"}), 1);
