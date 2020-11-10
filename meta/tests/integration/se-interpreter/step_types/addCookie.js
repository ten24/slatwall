exports.run = function(tr, cb) {
  var data = {value: tr.p('value'), name: tr.p('name')};
  tr.p('options').split('/').forEach(function(entry) {
    var entryArr = entry.split('=');
    data[entryArr[0]] = data[entryArr[1]];
  });
  tr.do('setCookie', [data], cb);
};