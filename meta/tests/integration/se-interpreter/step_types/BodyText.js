exports.cmp = "text";
exports.run = function(tr, cb) {
  tr.do('elementByTagName', ['html'], cb, function(err, element) {
    tr.do('text', [element], cb, function(err, text) {
      cb({'value': text});
    });
  });
};