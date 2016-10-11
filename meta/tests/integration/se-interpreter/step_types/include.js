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
var get_component = function(relative_dir) {
	var fs = require('fs');
    var path = require('path');
    var tools = require('../functions');
	var component = JSON.parse(fs.readFileSync(path.join(__dirname, '../', relative_dir)));
    component = tools.addStepInBetween(component,{"script":"return document.readyState","value":"complete","type":"waitForEval"});
    component = tools.addStepInBetween(component,{"type":"waitForElementPresent"});
    return component;
}