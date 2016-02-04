# Atom Perl 6 Editor Tools

A collection of useful Perl 6 editor tools

- POD Preview (Shortcut: `Alt+Ctrl+O`)

This allows you to preview Perl 6 POD while typing your POD documentation in
near real-time.

![POD Preview Screenshot](https://raw.githubusercontent.com/azawawi/atom-perl6-editor-tools/master/atom-perl6-editor-tools-screeshot.png)

## Notes

Please remember to install [`Pod::To::HTML`](
  https://github.com/perl6/Pod-To-HTML) via the following command for POD Preview pane to work:

```
  $ panda install Pod::To::HTML
```

- Runs tests via ``prove -v -e "perl6 -Ilib"`` (Shortcut: `Alt+Ctrl-P`)

This allows you to run tests in your current Perl 6 project

## TODO

- Check for `Pod::To::HTML` existance and warn if the command fails
- Save user scroll position
- Respect various editor themes/ custom POD styling
- Add custom perl6 path setting
- Generate temporary files
- Less CPU usage when typing fast
- Open POD Preview only on Perl6 files and warn if otherwise