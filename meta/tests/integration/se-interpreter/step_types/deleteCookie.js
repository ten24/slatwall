exports.run = function(tr, cb) {
  tr.do('deleteCookie', [tr.p('name')], cb);
};