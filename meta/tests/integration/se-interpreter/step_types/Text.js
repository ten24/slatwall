exports.cmp = 'text';
exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('text', [element], cb, function(err, text) {
      cb({'value': text});
    });
  });
};