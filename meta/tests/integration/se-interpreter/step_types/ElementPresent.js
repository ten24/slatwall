exports.name = "ElementPresent";
exports.run = function(tr, cb) {
  tr.locate('locator', cb, function() {
    cb({'value': true});
  }, function() {
    cb({'value': false});
  });
};