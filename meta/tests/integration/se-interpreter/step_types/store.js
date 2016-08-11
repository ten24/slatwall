exports.run = function(tr, cb) {
  tr.setVar(tr.p('variable'), tr.p('text'));
  cb({'success': true});
};