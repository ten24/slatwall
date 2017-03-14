exports.run = function(tr, cb) {
  tr.do('frame', [tr.p('identifier')], cb);
};