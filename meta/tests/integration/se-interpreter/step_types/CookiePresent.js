exports.name = "CookiePresent";
exports.run = function(tr, cb) {
  tr.do('allCookies', [], cb, function(err, cookies) {
    cb({'value': cookies.some(function(c) { return c.name == tr.p('name'); })});
  });
};