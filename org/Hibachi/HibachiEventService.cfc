/*

-------------- Explicitly Defined Events ------------------

// onEvent

// onApplicationSetup
// onApplicationFullUpdate
// onApplicationBootstrapRequestStart
// onApplicationRequestStart
// onApplicationRequestEnd

// onSessionAccountLogin
// onSessionAccountLogout

-------------- Implicitly Defined Events ------------------

// before{EntityName}Save
// after{EntityName}Save
// after{EntityName}SaveSuccess
// after{EntityName}SaveFailure

// before{EntityName}Delete
// after{EntityName}Delete
// after{EntityName}DeleteSuccess
// after{EntityName}DeleteFailure

// before{EntityName}Process
// after{EntityName}Process
// after{EntityName}ProcessSuccess
// after{EntityName}ProcessFailure

// before{EntityName}Process_{processContext}
// after{EntityName}Process_{processContext}
// after{EntityName}Process_{processContext}Success
// after{EntityName}Process_{processContext}Failure

*/
component output="false" update="true" extends="HibachiService" {

	variables.registeredEvents = {};
	variables.registeredEventHandlers = {};
	
	public any function getEventHandler( required string objectFullname ) {
		if(!structKeyExists(variables.registeredEventHandlers, arguments.objectFullname)) {
			try {
				variables.registeredEventHandlers[ arguments.objectFullname ] = createObject("component", arguments.objectFullname);
			} catch(any e) {
				logHibachi("The event handler: #arguments.objectFullname# could not be instantiated.  Please verify that this component does not have errors.  In addition whenever possible eventHandler names should start from the Application root mapping at #getApplicationValue('applicationKey')#.xxx");
			}
		}
		if(structKeyExists(variables.registeredEventHandlers, arguments.objectFullname)) {
			return variables.registeredEventHandlers[ arguments.objectFullname ];
		}
	}
	
	private any function setEventHandler( required any object ) {
		var objectFullname = getMetadata(arguments.object).fullname;
		variables.registeredEventHandlers[ objectFullname ] = arguments.object;
		return objectFullname;
	}
	
	public void function announceEvent(required string eventName, struct eventData={}) {
		logHibachi("Event Announced: #arguments.eventName#");
		
		// Stick the Hibachi Scope in with the rest of the event data
		arguments.eventData[ "#getApplicationValue('applicationKey')#Scope" ] = getHibachiScope();
		
		// If there is an onEvent registered, then we call that first
		if(structKeyExists(variables.registeredEvents, "onEvent")) {
			
			var onEventData = arguments.eventData;
			onEventData.eventName = arguments.eventName;
			
			// Loop over all of the different registered events for a given eventName
			for(var i=1; i<=arrayLen(variables.registeredEvents.onEvent); i++) {
				
				// Get the object to call the method on
				var object = getEventHandler(variables.registeredEvents.onEvent[i]);
				
				// Call the onEvent Method
				object.onEvent(argumentcollection=onEventData);	
				
			}
		}
		
		// Check to see if there are any events registered
		if(structKeyExists(variables.registeredEvents, arguments.eventName)) {
			
			// Loop over all of the different registered events for a given eventName
			for(var i=1; i<=arrayLen(variables.registeredEvents[ arguments.eventName ]); i++) {
				
				// Get the object to call the method on
				var object = getEventHandler(variables.registeredEvents[ arguments.eventName ][i]);
				
				// Stick the Hibachi Scope in with the rest of the event data
				arguments.eventData[ "#getApplicationValue('applicationKey')#Scope" ] = getHibachiScope();
				
				// Attempt to evaluate this method
				evaluate("object.#eventName#( argumentCollection=arguments.eventData )");	
				
			}
		}
	}
	
	public void function registerEvent( required string eventName, required any object, string objectFullname ) {
		if(!structKeyExists(variables.registeredEvents, arguments.eventName)) {
			variables.registeredEvents[ arguments.eventName ] = [];
		}
		if(!structKeyExists(arguments, "objectFullname")) {
			arguments.objectFullname = getMetaData(arguments.object).fullname;
		}
		arrayAppend(variables.registeredEvents[ arguments.eventName ], arguments.objectFullname);
	}
	
	public void function registerEventHandler( required any eventHandler ) {
		if(isObject(arguments.eventHandler)) {
			var objectFullname = setEventHandler( arguments.eventHandler );
			var object = arguments.eventHandler;
		} else if (isSimpleValue(arguments.eventHandler)) {
			var objectFullname = arguments.eventHandler;
			var object = getEventHandler( arguments.eventHandler );
		}
		
		if(!isNull(object)) {
			var objectMetaData = getMetaData(object);
			for(var f=1; f<=arrayLen(objectMetaData.functions); f++) {
				if(!structKeyExists(objectMetaData.functions[f], "access") || objectMetaData.functions[f].access == "public") {
					registerEvent(eventName=objectMetaData.functions[f].name, object=object, objectFullname=objectFullname);
				}
			}
		}
	}
	
	public void function registerEventHandlers() {
		if(directoryExists(getApplicationValue('applicationRootMappingPath') & '/model/handler')) {
			var dirList = directoryList(getApplicationValue('applicationRootMappingPath') & '/model/handler');
			for(var h=1; h<=arrayLen(dirList); h++) {
				if(listLast(dirList[h], '.') eq 'cfc') {
					registerEventHandler( "#getApplicationValue('applicationKey')#.model.handler.#listFirst(listLast(dirList[h], '/'), '.')#" );
				}
			}
		}
		if(directoryExists(getApplicationValue('applicationRootMappingPath') & '/custom/model/handler')) {
			var dirList = directoryList(getApplicationValue('applicationRootMappingPath') & '/custom/model/handler');
			for(var h=1; h<=arrayLen(dirList); h++) {
				if(listLast(dirList[h], '.') eq 'cfc') {
					registerEventHandler( "#getApplicationValue('applicationKey')#.custom.model.handler.#listFirst(listLast(dirList[h], '/'), '.')#" );
				}
			}
		}
	}
	
	public any function getEventNameOptions() {
		var opArr = [];
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('define.select')#", value=""});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onEvent')# | onEvent", value="onEvent"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onApplicationSetup')# | onApplicationSetup", value="onApplicationSetup"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onApplicationFullUpdate')# | onApplicationFullUpdate", value="onApplicationFullUpdate"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onApplicationBootstrapRequestStart')# | onApplicationBootstrapRequestStart", value="onApplicationBootstrapRequestStart"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onApplicationRequestStart')# | onApplicationRequestStart", value="onApplicationRequestStart"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onApplicationRequestEnd')# | onApplicationRequestEnd", value="onApplicationRequestEnd"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onSessionAccountLogin')# | onSessionAccountLogin", value="onSessionAccountLogin"});
		arrayAppend(opArr, {name="#getHibachiScope().rbKey('event.onSessionAccountLogout')# | onSessionAccountLogout", value="onSessionAccountLogout"});
		
		var emd = getEntitiesMetaData();
		var entityNameArr = listToArray(structKeyList(emd));
		arraySort(entityNameArr, "text");
		for(var i=1; i<=arrayLen(entityNameArr); i++) {
			var entityName = entityNameArr[i];
			
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.before')# #getHibachiScope().rbKey('define.save')# | before#entityName#Save", value="before#entityName#Save", entityName=entityName});
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.save')# | after#entityName#Save", value="after#entityName#Save", entityName=entityName});
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.save')# #getHibachiScope().rbKey('define.success')# | after#entityName#SaveSuccess", value="after#entityName#SaveSuccess", entityName=entityName});
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.save')# #getHibachiScope().rbKey('define.failure')# | after#entityName#SaveFailure", value="after#entityName#SaveFailure", entityName=entityName});
			
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.before')# #getHibachiScope().rbKey('define.delete')# | before#entityName#Delete", value="before#entityName#Delete", entityName=entityName});
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.delete')# | after#entityName#Delete", value="after#entityName#Delete", entityName=entityName});
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.delete')# #getHibachiScope().rbKey('define.success')# | after#entityName#DeleteSuccess", value="after#entityName#DeleteSuccess", entityName=entityName});
			arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.delete')# #getHibachiScope().rbKey('define.failure')# | after#entityName#DeleteFailure", value="after#entityName#DeleteFailure", entityName=entityName});
			
			if(structKeyExists(emd[entityName], "hb_processContexts")) {
				for(var c=1; c<=listLen(emd[entityName].hb_processContexts); c++) {
					var thisContext = listGetAt(emd[entityName].hb_processContexts, c);
					
					arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.before')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# | before#entityName#Process_#thisContext#", value="before#entityName#Process_#thisContext#", entityName=entityName});
					arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# | after#entityName#Process_#thisContext#", value="after#entityName#Process_#thisContext#", entityName=entityName});
					arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# #getHibachiScope().rbKey('define.success')# | after#entityName#Process_#thisContext#Success", value="after#entityName#Process_#thisContext#Success", entityName=entityName});
					arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# #getHibachiScope().rbKey('define.failure')# | after#entityName#Process_#thisContext#Failure", value="after#entityName#Process_#thisContext#Failure", entityName=entityName});
				}
			}
		}
		
		return opArr;
	}
	
}