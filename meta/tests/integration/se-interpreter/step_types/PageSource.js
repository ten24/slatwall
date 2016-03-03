exports.cmp = "source";
exports.run = function(tr, cb) {
  tr.do('source', [], cb, function(err, source) {
    cb({'value': source});
  });
};