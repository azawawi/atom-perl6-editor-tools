#!/usr/bin/env perl6

use v6;

say "Hello world";

my $fh = "output.cson".IO.open(:w);
$fh.say( q{'.source.perl6':} );
my $body;
my $snippet;
for "snippets/perl6.snippets.txt".IO.lines -> $line {
  next if $line eq "";
  next if $line ~~ / ^ '#' /;

  if $line ~~ / ^ 'snippet' \s+ (.+?) $ / {
    say "=> $0";
    if $snippet.defined {
      $fh.say( sprintf("  '%s':", $snippet) );
      $fh.say( sprintf("    'prefix': '%s'", $snippet) );
      $fh.say( sprintf("    'body': '%s'",   $body.chomp.subst("\n", "\\n", :g).subst("\t", "  ", :g)) );
    }
    $snippet = ~$0;
    $body = '';
  } elsif $line ~~ / ^ \s (.+?) $ / {
    say "body => $0";
    $body ~= $0 ~ "\n" ;
  } else {
    die "Cannot parse snippet here. Please see '$line'"
  }
}

$fh.close;