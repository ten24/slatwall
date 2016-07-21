exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('moveTo', [element, 0, 0], cb, function() {
      tr.do('doubleclick', [], cb);
    });
  });
};