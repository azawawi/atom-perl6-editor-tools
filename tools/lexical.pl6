#!/usr/bin/env perl6

use v6;

sub bar($fifo) {
  my $foo = 1;
  {
    my $foo = 2;
    say $foo;
  }
  say $foo;
}

sub fee() {
  
}

class Person {
  has $.name;
  method get-salary { 500 }
}