var fs = require('fs');

exports.run = function(tr, cb) {
  tr.do('takeScreenshot', [], cb, function(err, base64Image) {
    var decodedImage = new Buffer(base64Image, 'base64');
    fs.writeFile(tr.name + '-' + Date.now() + '.png', decodedImage, function(err) {
      cb({'success': !err, 'error': err});
    });
  });
};