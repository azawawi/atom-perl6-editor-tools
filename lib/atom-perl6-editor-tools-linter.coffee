
class Perl6Linter
  name: 'Perl 6 Linter',
  grammarScopes: ['source.perl6', 'source.perl6fe'],
  scope: 'file',
  lintOnFly: true,
  lint: (textEditor) ->
    atom.notifications.addInfo("Started linter!")
    #return new Promise( (resolve, reject) ->
    return [
      type: 'Error',
      text: 'Something went wrong',
      range:[[0,0], [0,1]],
      filePath: textEditor.getPath()
    ]

module.exports = Perl6Linter
