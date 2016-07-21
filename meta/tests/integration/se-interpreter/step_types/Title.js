exports.cmp = "title";
exports.run = function(tr, cb) {
  tr.do('title', [], cb, function(err, title) {
    cb({'value': title});
  });
};