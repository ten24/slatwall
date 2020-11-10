exports.run = function(tr, cb) {
  if (!tr.silencePrints) {
    console.log(tr.p('text'));
  }
  cb({'success': true});
};