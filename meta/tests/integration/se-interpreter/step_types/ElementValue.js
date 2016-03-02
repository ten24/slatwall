exports.cmp = 'value';
exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('getAttribute', [element, 'value'], cb, function(err, value) {
      cb({'value': value});
    });
  });
};