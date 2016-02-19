#!/usr/bin/env perl6

use v6;


use JSON::Fast;

my $json = "data/perl6-help-index.json".IO.slurp;

my $index-data = from-json($json);

my %help-index;
for @($index-data) -> $v {
  my $keyword = $v<value>;
  my $values = %help-index{$keyword} // [];

  %help-index{$keyword}.push( %(
    "category" => $v<category>,
    "url"      => $v<url>,
  ));
}

my $pretty-json = to-json(%help-index);

"data/pretty.json".IO.spurt($pretty-json);
