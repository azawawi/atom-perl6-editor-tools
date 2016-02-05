# Atom Perl 6 Editor Tools

This atom plugin provides a collection of useful Perl 6 editor tools that are
shown below:

## Syntax Check Linter

This provides a linter than syntax checks Perl 6 code and provides error
messages. Please note that this will run `BEGIN` and `CHECK` blocks.

![Linter Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/atom-perl6-editor-tools-linter-screenshot.png)

## POD Preview (Shortcut: `Alt+Ctrl+O`)

This allows you to preview Perl 6 POD while typing your POD documentation in
near real-time. Please remember to install [`Pod::To::HTML`](
https://github.com/perl6/Pod-To-HTML) via the following command for the POD
Preview pane to work:
```
  $ panda install Pod::To::HTML
```

![POD Preview Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/atom-perl6-editor-tools-screenshot.png)

## Test Runner (Shortcut: `Alt+Ctrl+P`)

This allows you to run tests via ``prove -v -e "perl6 -Ilib"`` in your current
Perl 6 project

![Run Tests (prove) Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/atom-perl6-editor-tools-run-tests-screenshot.png)

## Snippets

A collection of useful snippets are now available for Perl 6 files. Please use
`Alt+Shift+S` to view all of them. Type the name of the snippet and then press
`Tab`. For example, by typing `script` followed by `Tab`, a hello world script
is inserted. Please read [Using Atom: Snippets](
https://atom.io/docs/latest/using-atom-snippets) for more information.

## TODO

- Save user scroll position
- Add custom perl6 path setting
- Less CPU usage when typing fast
- Generate only one temporary file instead of two
