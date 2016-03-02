exports.run = function(tr, cb) {
  tr.do('window', [tr.p('name')], cb);
};