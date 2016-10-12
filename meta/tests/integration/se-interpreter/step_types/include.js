exports.run = function(tr, cb) {
  var tools = require('../functions');
  var component = tools.get_component(tr.currentStep()['rel_dir']);
  /*
  We check if there are subcomponents and we add them to the component. This is not
  included as a step as it was creating context problems
  */
  
  //combine arrays at an index
  tr.script.steps.splice.apply(tr.script.steps, [tr.stepIndex+1, 0].concat(component.steps));
 
  cb({'success': true});
}