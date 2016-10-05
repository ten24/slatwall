exports.run = function(tr, cb) {
  var fs = require('fs');
  var path = require('path');
  var component = JSON.parse(fs.readFileSync(path.join(__dirname, '../', tr.currentStep()['rel_dir'])));
  var currentStepIndex = tr.script.steps.indexOf(tr.currentStep());
  tr.script.steps.splice(currentStepIndex,1);
  for (var i = 0; i < component.steps.length; i++) {
    tr.script.steps.splice(currentStepIndex, 0,component.steps[i]);
    currentStepIndex++;
  }
  tr.do('back', [], cb);  
}