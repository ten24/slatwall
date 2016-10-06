exports.run = function(tr, cb) {
  var tools = require('../add_step_in_between');
  var fs = require('fs');
  var path = require('path');
  var component = JSON.parse(fs.readFileSync(path.join(__dirname, '../', tr.currentStep()['rel_dir'])));
  component = tools.addStepInBetween(component,{"script":"return document.readyState","value":"complete","type":"waitForEval"}); 
  component = tools.addStepInBetween(component,{"type":"waitForElementPresent"});
  var currentStepIndex = tr.script.steps.indexOf(tr.currentStep());
  tr.script.steps.splice(currentStepIndex,1);
  for (var i = 0; i < component.steps.length; i++) {
    tr.script.steps.splice(currentStepIndex, 0,component.steps[i]);
    currentStepIndex++;
  }
  tr.do('refresh', [], cb);  
}