exports.run = function(tr, cb) {
   var tools = require('../functions');
   var component = tools.split_path_and_wait(tr.currentStep());
  //combine arrays at an index
   tr.script.steps.splice.apply(tr.script.steps, [tr.stepIndex+1, 0].concat(component));
   cb({'success': true});
}