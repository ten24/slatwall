/**
 * Step to change the size of the current window
 * Implementaion of  JSONWire Proctocol:
 * POST /session/:sessionId/window/:windowHandle/size
 *
 * author:  david linse
 * version: 0.0.1
 *
 * usage: { "type": "windowSize",  "width": 800, "height": 600 }
 */

exports.run = function(tr, cb) {
  tr.do('windowHandle', [], cb, function (err, handle) {
    var w = parseInt(tr.p('width'), 10),
        h = parseInt(tr.p('height'), 10);
    tr.do('windowSize', [handle, w, h], cb, function(err) {
      cb({'success': !err, 'error': err});
    });
  });
};
