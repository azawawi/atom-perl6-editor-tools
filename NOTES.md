This is just a document to store development related notes and TODOs

## Notes
To start developing this plugin, please use the following
```
npm i --save-dev eslint
npm i --save-dev babel-eslint
```

## Stuff TODO

- Use [App::Mi6](https://github.com/skaji/mi6/blob/master/README.md) to do the
  following:
  ```
  > mi6 new Foo::Bar # create Foo-Bar distribution
  > cd Foo-Bar
  > mi6 test         # run tests
  ```
- Add POD snippets
- Add a Perl6 POD Cheatsheet
- Listen to configuration events and issue a Atom environment restart?
Please see https://atom.io/docs/api/v1.5.3/Config#instance-observe
- Add custom perl6 path setting (Settings)
- Generate only one temporary file instead of two (POD Preview)
- Bundle Pod::To::HTML inside our package and provide an option to override
- Create Perl6 script menu shortcut (Create a new editor with Perl 6 FE syntax
  and script<tab>)
- Create Perl6 module menu shortcut (with travis CI and appveyor YAML files)
- Open example from Perl 6 examples github repo (through a pregenerated index)
- Borrow from Padre Outline: Perl 6 class/method/subs/...etc outline
- On opening a new file editor. Read the first few lines and determine the correct Perl/Perl 6 grammar using `use v6`. Slurping the whole file and then matching is a very bad idea for large files.
- Add Profiling support
