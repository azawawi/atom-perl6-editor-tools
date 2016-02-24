#!/usr/bin/env perl6

use v6;


use JSON::Fast;


my $snippets-json = "snippets/atom-perl6-editor-tools.json".IO.slurp;
my $snippets = from-json($snippets-json);

say $snippets.perl;

my $fh = "snippets.md".IO.open(:w);

$fh.say(q{
### Snippets
This is a list of supported snippets provided by this plugin.
});

my $snippets_perl6 = $snippets{'.source.perl6, .source.perl6fe'};
for $snippets_perl6.kv -> $name, $snippet {
  my $prefix = $snippet<prefix>;
  my $body   = $snippet<body>;
  $fh.say(qq{
#### `$prefix⇥` $name
```Perl6
$body
```});
}