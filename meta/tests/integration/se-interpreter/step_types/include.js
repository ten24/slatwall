exports.run = function(tr, cb) { 
 
  var component = get_component(tr.currentStep()['rel_dir']);  
  /*
  Check if there are subcomponents and we add them to the component. This is not 
  included as a step as it was creating context problems
  */
  var component_size = component.steps.length;
  for (var i = 0; i < component.steps.length; i++) {
  	if (component.steps[i]['type'] === 'include_as_subcomponent') {
    	var sub_component_included = get_component(component.steps[i]['rel_dir']);
    	component.steps.splice(i,1);// deletes the ['rel_dir'] step in the subcomponent
    	for(var j = 0; j < sub_component_included.steps.length; j++) {
    		console.log(sub_component_included.steps[j]);
    		component.steps.splice(i, 0,sub_component_included.steps[j]);
    		i++;
    		component_size++;
    	}
    } 
  }
  var currentStepIndex = tr.script.steps.indexOf(tr.currentStep());
  tr.script.steps.splice(currentStepIndex,1);
  for (var i = 0; i < component.steps.length; i++) {
    	tr.script.steps.splice(currentStepIndex, 0,component.steps[i]);
    	currentStepIndex++;
  }  
  cb({'success': true});
}

var get_component = function (relative_dir) {
		var fs = require('fs');
    	var path = require('path');
		var tools = require('../functions');
		var component = JSON.parse(fs.readFileSync(path.join(__dirname, '../', relative_dir)));
    	component = tools.addStepInBetween(component,{"script":"return document.readyState","value":"complete","type":"waitForEval"}); 
    	component = tools.addStepInBetween(component,{"type":"waitForElementPresent"});
    	return component;
	}
