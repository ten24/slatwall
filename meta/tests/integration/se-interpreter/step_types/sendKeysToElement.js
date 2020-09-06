exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('type', [element, tr.p('text')], cb);
  });
};