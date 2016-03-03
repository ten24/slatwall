exports.run = function(tr, cb) {
  tr.locate('locator', cb, function(err, element) {
    tr.do('isSelected', [element], cb, function(err, isSelected) {
      if (isSelected) {
        cb({'success': true});
      } else {
        tr.do('clickElement', [element], cb);
      }
    });
  });
};