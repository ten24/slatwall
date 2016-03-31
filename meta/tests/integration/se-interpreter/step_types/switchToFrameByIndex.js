exports.run = function(tr, cb) {
  tr.do('frame', [parseInt(tr.p('index'))], cb);
};