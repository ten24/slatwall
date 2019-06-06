exports.name = "ElementSelected";
exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('isSelected', [element], cb, function(err, isSelected) {
      cb({'value': isSelected});
    });
  });
};