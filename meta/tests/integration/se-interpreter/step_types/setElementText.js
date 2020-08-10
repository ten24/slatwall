exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('clear', [element], cb, function() {
      tr.do('type', [element, tr.p('text')], cb);
    });
  });
};