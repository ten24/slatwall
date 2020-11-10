exports.cmp = 'value';
exports.run = function(tr, cb) {
  tr.do('allCookies', [], cb, function(err, cookies) {
    var cs = cookies.filter(function(c) { return c.name == tr.p('name'); });
    if (cs.length == 0) {
      cb({'error': new Error('No cookie with name ' + tr.p('name') + ' found.')});
    } else {
      cb({'value': cs[0].value});
    }
  });
};