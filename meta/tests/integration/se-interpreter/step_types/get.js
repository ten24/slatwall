exports.run = function(tr, cb) {
  tr.do('get', [tr.p('url')], cb);
};