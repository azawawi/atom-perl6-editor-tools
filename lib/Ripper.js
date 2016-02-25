let { Range, Point } = require('atom')

class Ripper {
  constructor() {
    console.log("Ripper!")
    this.scopeNames = ['source.perl6', 'source.perl6fe']
  }

  parse(code, callback) {
    console.log(`parse called! on the following code ${code}`)
    // parse code
    range = new Range()
    callback([{
      //range = new Range(),
      //message: 'foo'
    }])
  }
  
  find(point) {
    console.log(`find called on ${point}`)
    // find references
    return [
      //new Range()
    ]
  }
}