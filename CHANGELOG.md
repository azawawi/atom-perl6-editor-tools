## 0.9.6
* Convert source code from [CoffeeScript](http://coffeescript.org/) to ES6
via [Babel](https://babeljs.io)
* Fix a bug where the help text was not displaying the category and url
* Add  [eslint](https://github.com/eslint/eslint) and [babel-eslint](https://github.com/babel/babel-eslint) to development dependencies

## 0.9.5
* No changes to code. This only add an animated GIF to explain context-senstive
help operation

## 0.9.4
* Implement #4

## 0.9.3
* Shorten long screenshot names and move them into their own directory
* Show not-found help popup as a warning
* Refactor module names to be shorter

## 0.9.2
* Add Perl 6 [hyperclick](https://atom.io/packages/hyperclick) support for
context-sensitive help
* Remove old prove option since Perl 6 builder is more generic
* add lib path to linter - #1 (MadcapJake++)
* Support perl6fe and perl6 editors in snippets

## 0.8.4
* Add Perl 6 [builder](https://atom.io/packages/build) support
* Better documentation

## 0.8.3
* Better documentation
* Auto-install [Atom Perl 6 Support - Fun Edition! - perl6fe](
  https://github.com/MadcapJake/language-perl6fe)
* Warn when language-perl core module is enabled

## 0.8.2
* Install package-deps section in package.json without user intervention. This
  is a patch release to v0.8.1.

## 0.8.1
* Install linter dependency automatically using [atom-package-deps](
https://github.com/steelbrain/package-deps)

## 0.8.0
* Use current theme in POD Preview
* Add Perl 6 syntax checking [linter](https://atom.io/packages/linter) support
* Fix documentation

## 0.7.0
* Open POD Preview on a valid Perl6 editor and warn if otherwise
* Open POD Preview when `Pod::To::HTML` is installed and warn if otherwise
* Generate temporary files via [tmp](https://github.com/raszi/node-tmp)
* Generated more snippets from [vim-snipmate default snippets](
https://github.com/honza/vim-snippets/blob/master/snippets/perl6.snippets)
* Fix context menu labels and add more documentation

## 0.6.0
* Minor fix to usability of run tests
* Add a screenshot for run tests feature

## 0.5.0
* Add run tests via prove (Alt-Ctrl-P)

## 0.4.0
* More documentation in README.md
* Fix menu name

## 0.3.0
* Various documentation fixes

## 0.2.0
* First Release with POD Preview (Alt-Ctrl-O)
