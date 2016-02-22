#!/usr/bin/env perl6

use v6;

use JSON::Fast;
use HTTP::UserAgent;

sub MAIN() {
  my $doc-perl6-index = fetch-perl6-index();
  create-perl6-help-index($doc-perl6-index);
}

sub fetch-perl6-index {
  my $ua = HTTP::UserAgent.new;
  $ua.timeout = 10;

  my $url = 'http://doc.perl6.org/js/search.js';
  say "Fetching data from $url";
  my $response = $ua.get($url);

  if $response.is-success {
      if $response.content ~~ /'source: ' ('[' .+ ']') ',' / {
        my Str $json = ~$/[0];
        $json = $json.subst('category:', '"category":', :g);
        $json = $json.subst('value:', '"value":', :g);
        $json = $json.subst('url:', '"url":', :g);
        return from-json( $json );
      }
  } else {
      die $response.status-line;
  }
}

sub create-perl6-help-index($index-data) {

  say "Creating Perl 6 help index...";
  my %help-index;
  for @($index-data) -> $v {
    my $keyword = $v<value>;
    my $values = %help-index{$keyword} // [];

    %help-index{$keyword}.push( %(
      "category" => $v<category>,
      "url"      => $v<url>,
    ));
  }

  my $json = to-json(%help-index);

  my $filename = "data/perl6-help-index.json";
  say "Writing to $filename";
  $filename.IO.spurt($json);
}
