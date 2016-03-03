exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, el) {
    tr.do('clickElement', [el], cb);
  });
};