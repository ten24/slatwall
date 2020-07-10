/**
 * NOTEs
 * 
 * for tailing the logs you can do: [   find ./WEB-INF -type f -iname "*.log" | xargs tail -f    ]
 * and for clearing the logs you can do [   find ./WEB-INF -type f -iname '*.log' -print0 | xargs -0 truncate -s0    ]
 * 
 * Ideas:
 * 1. devops l5 --log; devops l5 --log --clear
 * 
 * 2. https://www.bennadel.com/blog/2346-coldfusion-10---accessing-the-call-stack-with-callstackget.htm
 * 3. log-adapters DB, File;
 * 4. log-level strategies
 * 5. consider LogServise
 * 6. More friendly log-output
 * 7. request -UUID
 */ 
component accessors="true" persistent="false" output="false"{
	property name="loggerTag" type="string" persistent="false" default="Hibachi";
	property name="logFileName" type="string" persistent="false" default="debug";

	public any function init( string loggerTag) {
		variables.loggerTag = arguments.loggerTag;
		return this;
	}
	
	public any function i(any message) {
		this.d( argumentCollection = arguments);
	}
	
	public any function d(any message) {
		logg( 
			(ArrayLen(arguments) > 1) ? concatAll(argumentCollection = arguments) : arguments.message, 
			'information'
		);
	}
	
	public any function w(any message) {
		logg( 
			(ArrayLen(arguments) > 1) ? concatAll(argumentCollection = arguments) : arguments.message, 
			'warning'
		);
	}
	
	public any function m(any with) {
		var callStack = callstackGet();
		// arrayDeleteAt(callStack, 1); 
		arguments['message'] = "Called "&callStack[2]['function'] &" ";
		// arguments['___callStack'] = callstack;
		this.d( argumentCollection = arguments);
	}
	
	public any function e(any message) {
		logg( 
			(ArrayLen(arguments) > 1) ? concatAll(argumentCollection = arguments) : arguments, 
			'error'
		);
	}
	
	public any function o(any theObject, string properties='', allProperties=false) {
		if(arguments.allProperties){
			logg( arguments.theObject.getSimpleValuesSerialized() );
		} else {
			logg(arguments.theObject, 'information', arguments.properties);
		}
	}
	
	private void function logg(any whatever, string theType='information', string properties=''){
		var text = this.simplify( arguments.whatever, arguments.properties );

		if(!IsSimpleValue(text)){
			text = SerializeJson(text) ;
		}
		if(IsJson(text)){
			//TODO: conditional formating
			text = this.formatJSON(text);
		}
		text = " " & variables.loggerTag & " - " & text;
		writeLog(text=text, type=arguments.theType, file=variables.logFileName);
	}		
	
	private struct function concatAll(any message){
		var concated = {};
		for(var key in arguments){
			concated[key] = this.simplify(arguments[key]);
		}
		return concated;
	}
	
	public any function simplify(any whatever, string properties='', numeric depth=5) {
		var simplified = 'unknown';
		
		if(IsNull(arguments.whatever)){
			simplified = "null";
		} 
		else if(IsSimpleValue(arguments.whatever)){
			simplified = arguments.whatever;
		}
		else if(arguments.depth <= 0){
			simplified = "maxDepth reached";	
		} 
		else {
			
			if(IsObject(arguments.whatever)){
				simplified = this.simplifyObject(arguments.whatever, arguments.properties, arguments.depth-1)
			} 
			else if( IsStruct(arguments.whatever) ) {
				simplified = {};
				for(var key in arguments.whatever){
					simplified[key] = this.simplify(arguments.whatever[key], '', arguments.depth-1);
				}
			}
			else if( IsArray(arguments.whatever) ) {
				simplified = [];
				for(var item in arguments.whatever){
					ArrayAppend(simplified, this.simplify(item, '', arguments.depth-1) );
				}
			}
		}
		return simplified;
	}
	
	public any function simplifyObject(any theObject, string properties='', numeric depth=2) {
		var simplified = 'Unknown Class';

		if(isInstanceOf(arguments.theObject, "HibachiObject")){
			var struct = {};
			for(var key in arguments.properties){
				struct[key] = this.simplify(theObject.invokeMethod('get#key#'), '', arguments.depth-1);
			}
			
			if(arguments.theObject.isPersistent()){
				
				if(arguments.theObject.isNew()){
					struct['id'] = "new";
				}
				else{
					struct['id'] = arguments.theObject.getPrimaryIDValue();	
				}
			}
			
			simplified = { "#theObject.getClassName()#" = struct };
		}
	
		return simplified;
	}

	
	public string function formatJSON(str) {
	    var fjson = '';
	    var pos = 0;
	    var strLen = len(arguments.str);
	    var indentStr = '  ';//chr(9); // Adjust Indent Token If you Like
	    var newLine = chr(10); // Adjust New Line Token If you Like <BR>
	    
	    for (var i=1; i<=strLen; i++) {
	        var char = mid(arguments.str,i,1);
	        
	        if (char == '}' || char == ']') {
	            fjson &= newLine;
	            pos = pos - 1;
	            
	            for (var j=1; j<=pos; j++) {
	                fjson &= indentStr;
	            }
	        }
	        
	        if(char == ':'){
	        	fjson &= char & indentStr;    
	        } else{
	        	fjson &= char;    
	        }
	        
	        
	        if (char == '{' || char == '[' || char == ',') {
	            fjson &= newLine;
	            
	            if (char == '{' || char == '[') {
	                pos = pos + 1;
	            }
	            
	            for (var k=1; k<=pos; k++) {
	                fjson &= indentStr;
	            }
	        }
	    }
	    
	    fjson = Replace(fjson, '""', '"', 'all'); 
	    return fjson;
	}

}