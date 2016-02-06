
# This provides hyperclick support for Perl 6 using hyperclick
# Please see https://atom.io/packages/hyperclick
module.exports =
class Perl6HyperclickProvider

  providerName:  'perl6-hyperclick'

  getSuggestionForWord: (textEditor, text, range) ->
    console.log(textEditor)
    console.log("text = " + text)
    console.log(range)
    return
    #return
    #  # The range(s) to underline as a visual cue for clicking. 
    #  range,
    #  # The function to call when the underlined text is clicked. 
    #  callback() {}
