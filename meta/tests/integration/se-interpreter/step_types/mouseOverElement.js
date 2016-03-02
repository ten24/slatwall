exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, el) {
    tr.do('moveTo', [el, null, null], cb);
  });
};