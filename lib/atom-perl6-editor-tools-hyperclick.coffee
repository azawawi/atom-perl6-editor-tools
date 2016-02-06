
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
        atom.notifications.addWarning("TODO perl6doc " + text)
        return
    }
