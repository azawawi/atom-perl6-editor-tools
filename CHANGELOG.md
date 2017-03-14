
## 0.10.2
* Replace ANSI color escaping with disabling environment variable
  `RAKUDO_ERROR_COLOR`. This fixes #30.
* Fix `atom-linter` missing dependency regression.

## 0.10.1
* Remove experimental refactor support.
* Depend on file-icons. Remove atom tree view/css workaround.

## 0.10.0
* Remove App::Mi6 experimental feature
* PR #31: Update package-deps to use the new package for P6 highlighting
* PR #25: Linter fixes
* Fix #21: Capture column number from error message
* Various linter fixes

## 0.9.18
* Fix #16: Standard output in BEGIN {} blocks causes wrong syntax check linter
  failures
* Fix missing library include issue with "Run Tests" via prove
* Add mi6 test build target and check for App::Mi6 and warn if otherwise

## 0.9.17
* Important: Apply workaround to fix Perl 6 file icons not showing up on atom
  startup (This is related to issue #13)
* Add initial experimental plumbing for Perl 6 refactor (Not working)
* Add initial experimental plumbing for "New Perl Script/Project" (Not working)

## 0.9.16
* Fix markdown for snippet. This is a quick patch release for 0.9.15

## 0.9.15
* Fix #5: Document snippets in markdown

## 0.9.14
* Add more animated gif screencasts in README.md

## 0.9.13
* Optimize help index for faster load time

## 0.9.12
* Add more documentation about file icons and its workaround
* Add setting options to toggle the following features (Atom restart needed):
  * Context-senstive help hyperclick
  * Syntax check linter
  * File icons support

## 0.9.11
* Fix issue #12
* Require new versions of dependencies namely q and atom-package-deps
* Activate the plugin once the dependencies are properly installed by
atom-package-deps

## 0.9.10
* Fix syntax check linter ANSI escape sequence removal and error message parsing
* Refactor the remaining CoffeeScript CSON files to JSON. This includes tests,
keymaps, menus and snippets

## 0.9.9
* Fix POD preview double bars
* Handle also .pm and .pl file types for camelia icons in tree view
* Fix syntax check linter error "undefined length"

## 0.9.8
* Add Camelia gray icons for Perl 6 file type in tree view. You need to collapse
and then expand the project tree panel for the first time due to an Atom
environment bug.
* Disable language-perl (core) for a more Perl 6 fun editing experience on
startup
* Improve code quality via refactoring, removing dead code and more delicious
code comments

## 0.9.7
* Fix a regression where linter was not including the project lib folder
* Remove ANSI escape sequences noise from error messages on non-windows
platforms
* Syntax check linter now uses the correct project directory
* Builder now uses the correct project directory for the active editor instead
of using the first one

## 0.9.6
* Merge #7 (linter)
* More robust error parsing in syntax check linter
* Fix a bug where the help text was not displaying the category and url
* Convert source code from [CoffeeScript](http://coffeescript.org/) to ES6
via [Babel](https://babeljs.io)
* Add [eslint](https://github.com/eslint/eslint) and [babel-eslint](
https://github.com/babel/babel-eslint) to development dependencies

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
