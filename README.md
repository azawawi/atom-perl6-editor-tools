# Atom Perl 6 Editor Tools

This atom plugin provides a collection of useful Perl 6 editor tools that are
shown below:

## Syntax Check Linter

This provides a [linter](https://atom.io/packages/linter) that syntax checks
Perl 6 code and provides error messages. Please note that this will run `BEGIN`
and `CHECK` blocks.

![Syntax Check Linter Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/syntax-check-linter.png)

## Build Support

This provides a [builder](https://atom.io/packages/build) that
provides the following tasks (More build tasks will added in the future):

- Perl 6 test: This will run ``prove -v -e "perl6 -Ilib"`` in your current Perl
6 project and provide the build log

![Test Builder Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/test-runner-build-task.png)


## Context sensitive help

This provides a [hyperclick](https://atom.io/packages/hyperclick) for context
sensitive help.

![Context Sensitive Help Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/content-sensitive-help.png)

## POD Preview (Shortcut: `Alt+Ctrl+O`)

This allows you to preview Perl 6 POD while typing your POD documentation in
near real-time. Please remember to install [`Pod::To::HTML`](
https://github.com/perl6/Pod-To-HTML) via the following command for the POD
Preview pane to work:
```
  $ panda install Pod::To::HTML
```

![POD Preview Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/pod-preview.png)

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

## Author

Ahmad M. Zawawi, azawawi on #perl6, https://github.com/azawawi/

## License

[MIT License](LICENSE.md)
