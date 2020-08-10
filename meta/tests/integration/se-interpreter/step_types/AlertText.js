exports.cmp = 'text';
exports.run = function(tr, cb) {
  tr.do('alertText', [], cb, function(err, text) {
    cb({'value': text});
  });
};