# Atom Perl 6 Editor Tools

A collection of useful Perl 6 editor tools

## POD Preview (Shortcut: `Alt+Ctrl+O`)

This allows you to preview Perl 6 POD while typing your POD documentation in
near real-time.

![POD Preview Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/atom-perl6-editor-tools-screenshot.png)

### Notes

Please remember to install [`Pod::To::HTML`](
  https://github.com/perl6/Pod-To-HTML) via the following command for POD Preview pane to work:

```
  $ panda install Pod::To::HTML
```

## Test Runner (Shortcut: `Alt+Ctrl+P`)

This allows you to run tests via ``prove -v -e "perl6 -Ilib"`` in your current
Perl 6 project

![Run Tests (prove) Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/atom-perl6-editor-tools-run-tests-screenshot.png)

## TODO

- Save user scroll position
- Respect various editor themes/ custom POD styling
- Add custom perl6 path setting
- Less CPU usage when typing fast
- Generate only one temporary file instead of two
