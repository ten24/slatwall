exports.cmp = 'value';
exports.run = function(tr, cb) {
  tr.do('execute', [tr.p('script'), []], cb, function(err, value) {
    cb({'value': value});
  });
};