exports.name = "AlertPresent";
exports.run = function(tr, cb) {
  tr.do('alertText', [], cb, function() {
    cb({'value': true});
  }, function() {
    cb({'value': false});
  });
};