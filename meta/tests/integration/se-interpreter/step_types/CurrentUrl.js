exports.cmp = "url";
exports.run = function(tr, cb) {
  tr.do('url', [], cb, function(err, url) {
    cb({'value': url});
  });
};