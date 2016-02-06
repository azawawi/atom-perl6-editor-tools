
# This provides hyperclick support for Perl 6 using hyperclick
# Please see https://atom.io/packages/hyperclick
module.exports =
class Perl6HyperclickProvider

  providerName:  'perl6-hyperclick'

  getSuggestionForWord: (editor, text, range) ->
    # Make sure the editor are valid Perl 6 editors
    return unless editor?
    grammar = editor.getGrammar()
    return unless grammar? && grammar.scopeName? && grammar.scopeName.startsWith("source.perl6")

    return {
      range: range,
      callback: () ->
        options =
          detail: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          dismissable: true
        atom.notifications.addInfo("p6doc #{text}", options)
        return
    }
