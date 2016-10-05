module.exports = {
  /*
	Adds step in between the execution of a step
	@param script: JSON File
	@param step: Block Step to insert in between the steps in the file
  */
  addStepInBetween : function (script, step) {
    var array_components = new Object();    
    for(var key in script) {
    	if(key == "steps") {
    		var jsonFileSize = script[key].length;
    		var counter = 1;
        	for(var i = 1; i < jsonFileSize; i++) {
        		if(counter == i) {
        			script[key].splice(i, 0,step);
        			counter = counter + 2;
        		}
            }
        }   
    }
    return script;
	}
};

 