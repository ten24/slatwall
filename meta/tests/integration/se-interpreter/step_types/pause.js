exports.run = function(tr, cb) {
  setTimeout(function() {
    cb({'success': true});
  }, tr.p('waitTime'));
};