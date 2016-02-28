#!/usr/bin/env perl6

use v6;
use nqp;

my $comp := nqp::getcomp('perl6');
#say $comp;
my $source = 'tools/lexical.pl6'.IO.slurp;
say $source;
say "-" x 80;
my $ast := $comp.eval($source, :target<ast>);
"ast.txt".IO.spurt($ast.dump());

