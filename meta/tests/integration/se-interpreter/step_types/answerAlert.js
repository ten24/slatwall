exports.run = function(tr, cb) {
  tr.do('alertKeys', [tr.p('text')], cb, function() {
    tr.do('acceptAlert', [], cb);
  });
};