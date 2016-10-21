module.exports = {
  /*
	Adds step in between the execution of a step
	@param script: JSON File
	@param step: Block Step to insert in between the steps in the file
	@return JSON file with the step added
  */
  addStepInBetween : function (script, step) {
    var array_components = new Object();
    var input_type = this.get_input_types();
    var index = 0;     
    for(var key in script) {
    	var jsonFileSize = script[key].length;
    	if((script['steps'][index]['type'] !== 'store') && (script['steps'][index]['type'] !== 'storeCurrentUrl')) {
    		if(key == "steps") {
    		var counter = 1;
    		
    		if (step['type'] === 'waitForEval') {
    			for(var i = 1; i < jsonFileSize; i++) {
        			if(counter == i) {
        				script[key].splice(i, 0,step);
        				counter = counter + 2;
        			} 
            	}   			
    		} else if (step['type'] === 'waitForElementPresent') {
    			for(var i = 0; i < jsonFileSize; i++) {
    				if(input_type.indexOf(script[key][i]['type']) > -1) {
    					script[key].splice(i, 0,{"type":"waitForElementPresent","locator":script[key][i]['locator']});
    					i++;
    					jsonFileSize++;
    				}        			
            	}
    		} 
          }
    	}
    }
    return script;
	},
	generate_assertions : function(step) {
		var array_of_assertion_steps = [];
		switch(step['assertion_type']) {
			case "waitForText":
				  array_of_assertion_steps.push({"type":step['assertion_type'],"text":step['text'],"locator":step['locator']})
			      array_of_assertion_steps.push({"type":"verifyText","text":step['text'],"locator":step['locator']})
				  array_of_assertion_steps.push({"type":"assertText","text":step['text'],"locator":step['locator']})
			      break;
		    case "waitForElementSelected":
		    	  array_of_assertion_steps.push({"type":step['assertion_type'],"locator":step['locator']});
			      array_of_assertion_steps.push({"type":"verifyElementSelected","locator":step['locator'],"value":step['value']})
				  array_of_assertion_steps.push({"type":"assertElementSelected","locator":step['locator'],"value":step['value']})
			      break;
			case "waitForElementValue":
			 	  array_of_assertion_steps.push({"type":step['assertion_type'],"locator":step['locator'],"value":step['text']});
			      array_of_assertion_steps.push({"type":"verifyElementValue","locator":step['locator'],"value":step['text']})
				  array_of_assertion_steps.push({"type":"assertElementValue","locator":step['locator'],"value":step['text']})
			      break;
			case "waitForTextPresent":
			      array_of_assertion_steps.push({"type":step['assertion_type'],"text":step['text']});
			      array_of_assertion_steps.push({"type":"verifyTextPresent","text":step['text']})
				  array_of_assertion_steps.push({"type":"assertTextPresent","text":step['text']})
			      break;
		}
		return array_of_assertion_steps
	},
	split_path_and_wait : function (step) {
		var path_steps = [];
	    var split_path = step['locator']['value'].split(">");
	    var split_path_str = split_path[0].trim();
	    path_steps.push({"type":"waitForElementPresent","locator":{"type":step['locator']['type'],"value":split_path_str}});
	    for(var i = 1; i< split_path.length; i++) {
	    	split_path_str = split_path_str + " > " + split_path[i].trim();
	    	path_steps.push({"type":"waitForElementPresent","locator":{"type":step['locator']['type'],"value":split_path_str}});
	    }
		return path_steps;
	},
	/*
	gets all possible input types
	@return Array with all possible input types
  */
	get_input_types : function () {
		var input_type =  ["clickElement", "doubleClickElement", "mouseOverElement", "setElementText", "sendKeysToElement","setElementSelected","setElementNotSelected","clearSelections","submitElement","dragToAndDropElement","clickAndHoldElement","releaseElement"];
	    return input_type;
	},
    get_component : function(relative_dir) {
		var fs = require('fs');
    	var path = require('path');
    	var component = JSON.parse(fs.readFileSync(path.join(__dirname, './', relative_dir)));
    	component = this.addStepInBetween(component,{"script":"return document.readyState","value":"complete","type":"waitForEval"});
    	component = this.addStepInBetween(component,{"type":"waitForElementPresent"});
    	return component;
	}
};

 