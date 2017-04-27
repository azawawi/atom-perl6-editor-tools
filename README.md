# Atom Perl 6 Editor Tools

[![Dependency Status](https://david-dm.org/azawawi/atom-perl6-editor-tools.svg?style=flat-square)](https://david-dm.org/azawawi/atom-perl6-editor-tools)

This atom plugin provides a collection of useful Perl 6 editor tools that are
shown below:

## Syntax Check Linter

This provides a [linter](https://atom.io/packages/linter) that syntax checks
Perl 6 code and provides error messages. Please note that this will run `BEGIN`
and `CHECK` blocks.

![Syntax Check Linter Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/screenshots/syntax-check-linter.gif)

## Build Support

This provides a [builder](https://atom.io/packages/build) that
provides the following tasks (More build tasks will added in the future):

- Perl 6 test: This will run ``prove -v -e "perl6 -Ilib"`` in your current Perl
6 project and provide the build log

![Test Builder Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/screenshots/test-runner-build-task.gif)

## Context sensitive help

This provides a [hyperclick](https://atom.io/packages/hyperclick) for context
sensitive help.

![Context Sensitive Help Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/screenshots/context_sensitive_help.gif)

## POD Preview (Shortcut: `Alt+Ctrl+O`)

This allows you to preview Perl 6 POD while typing your POD documentation in
near real-time. Please remember to install [`Pod::To::HTML`](
https://github.com/perl6/Pod-To-HTML) via the following command for the POD
Preview pane to work:
```
  $ zef install Pod::To::HTML
```

![POD Preview Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/screenshots/pod-preview.gif)

## Snippets

A collection of useful snippets are now available for Perl 6 files. You can find a complete list of the snippets [here](snippets.md).

* Please use `Alt+Shift+S` to view a scrollable list of them.
* Type the name of the snippet and then press `Tab`. For example, by typing `script` followed by `Tab`, a hello world script is inserted. Please read [Using Atom: Snippets](
http://flight-manual.atom.io/using-atom/sections/snippets) for more information.

## File Icons

Perl 6 file icons are now provided by [file-icons](https://atom.io/packages/file-icons) and is installed
automatically.

## Author

Ahmad M. Zawawi, azawawi on #perl6, https://github.com/azawawi/

## License

[MIT License](LICENSE.md)
