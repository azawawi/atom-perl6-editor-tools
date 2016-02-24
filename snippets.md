
#### `test⇥` test
```Perl6
use v6;
use Test;
${1:use lib 'lib';}
plan ${2:$num-tests};```

#### `switch⇥` switch
```Perl6
given ${1:$var} {
  when ${2:condition} {
    ${3:# code block ...}
  }
  ${4}
  default {
    ${5}
  }
}```

#### `tc⇥` tc
```Perl6
${1:condition} ?? ${2:value-if-true} !! ${3:value-if-false};```

#### `eif⇥` eif
```Perl6
elsif ${1) {
  ${2}
}```

#### `ife⇥` ife
```Perl6
if ${1} {
  ${2}
}
else {
  ${3}
}```

#### `mth⇥` mth
```Perl6
method ${1:method_name}(${2:$attr}) {
  ${3}
}```

#### `has⇥` has
```Perl6
has ${1:Type} ${2:$!identifier};```

#### `unless⇥` unless
```Perl6
unless ${1} {
  ${2}
}```

#### `rfile⇥` rfile
```Perl6
for "${1:filename}".IO.lines -> $line {
  ${2}
}```

#### `pmth⇥` pmth
```Perl6
method ${1:!}${2:method_name}(${3:$attr}) {
  ${4}
}```

#### `rp⇥` rp
```Perl6
repeat {
  ${1}
} ${2:while|until} ${3};```

#### `loop⇥` loop
```Perl6
loop (my ${1:$i} = 0; $$1 < ${2:count}; $$1++) {
  ${3}
}```

#### `mul⇥` mul
```Perl6
multi ${1:function_name}(${2:Str $var}) {
  ${3}
}```

#### `slurp⇥` slurp
```Perl6
my ${1:$var} = "${2:filename}".IO.slurp;```

#### `smth⇥` smth
```Perl6
submethod ${1:submethod_name}(${2:$attr}) {
  ${3}
}```

#### `#!⇥` #!
```Perl6
#!/usr/bin/env perl6```

#### `cl⇥` cl
```Perl6
${1:my} class ${2:ClassName} ${3:is|does Parent|Role}{
  ${4}
}```

#### `for⇥` for
```Perl6
for ${1:@array} -> ${2:$variable} {
  ${3}
}```

#### `xif⇥` xif
```Perl6
${1:expression} if ${2:condition};```

#### `sub⇥` sub
```Perl6
sub ${1:function_name}(${2:Str $var}) {
  ${3}
}```

#### `pod⇥` pod
```Perl6
=begin pod
$1
=end pod```

#### `script⇥` script
```Perl6
#!/usr/bin/env perl6

use v6;

say "Hello world";```

#### `wh⇥` wh
```Perl6
while ${1} {
  ${2}
}```

#### `xunless⇥` xunless
```Perl6
${1:expression} unless ${2:condition};```

#### `if⇥` if
```Perl6
if ${1} {
  ${2}
}```
