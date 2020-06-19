/*

-------------- Explicitly Defined Events ------------------

// onEvent

// onApplicationSetup
// onApplicationFullUpdate
// onApplicationBootstrapRequestStart
// onGlobalRequestSetupComplete
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
// after{EntityName}CreateSuccess
// after{EntityName}CreateFailure
// before{EntityName}Process_{processContext}
// after{EntityName}Process_{processContext}
// after{EntityName}Process_{processContext}Success
// after{EntityName}Process_{processContext}Failure

*/
component output="false" update="true" extends="HibachiService" {

	variables.eventNameOptions = {};
	/*{
		"triggerEvent":"triggerEventRBKey"
	}*/
	variables.triggerEventRBKeyHashMap = {};
	
	public any function getRegisteredEventHandlers(){
		if(!structKeyExists(variables,'registeredEventHandlers')){
			variables.registeredEventHandlers={};
			var eventHandlerBeanInfo = getBeanFactory().getBeanInfo(regex="\w+Handler").beanInfo;
			for(var beanInfo in eventHandlerBeanInfo){
				variables.registeredEventHandlers[eventHandlerBeanInfo[beanInfo].cfc] = getBeanFactory().getBean(beanInfo);
			}
		}
		return variables.registeredEventHandlers;
	}
	
	public any function getRegisteredEvents(){
		if(!structKeyExists(variables,'registeredEvents')){
			var registeredEventHandlers = getRegisteredEventHandlers();
			for(var key in registeredEventHandlers){
				var registeredEventHandler = registeredEventHandlers[key];
				registerEventHandler(registeredEventHandler);
			}
		}
		return variables.registeredEvents;
	}
	
	public any function getEventHandler( required string objectFullname ) {
		return getRegisteredEventHandlers()[objectFullName];
	}
	
	private any function setEventHandler( required any object ) {
		var objectFullname = getMetadata(arguments.object).fullname;
		getRegisteredEventHandlers()[ objectFullname ] = arguments.object;
		return objectFullname;
	}
	
	public void function announceEvent(required string eventName, struct eventData={}) {
		logHibachi("Event Announced: #arguments.eventName#");
		
		// Stick the Hibachi Scope in with the rest of the event data
		arguments.eventData[ "#getApplicationValue('applicationKey')#Scope" ] = getHibachiScope();
		
		// If there is an onEvent registered, then we call that first
		if(structKeyExists(getRegisteredEvents(), "onEvent")) {
			
			var onEventData = arguments.eventData;
			onEventData.eventName = arguments.eventName;
			
			// Loop over all of the different registered events for a given eventName
			for(var i=1; i<=arrayLen(getRegisteredEvents().onEvent); i++) {
				
				// Get the object to call the method on
				var object = getEventHandler(getRegisteredEvents().onEvent[i]);
				
				// Call the onEvent Method
				object.onEvent(argumentcollection=onEventData);	
				
			}
		}
		
		// Check to see if there are any events registered
		if(structKeyExists(getRegisteredEvents(), arguments.eventName)) {
			
			// Loop over all of the different registered events for a given eventName
			for(var i=1; i<=arrayLen(getRegisteredEvents()[ arguments.eventName ]); i++) {
				
				// Get the object to call the method on
				var object = getEventHandler(getRegisteredEvents()[ arguments.eventName ][i]);
				
				// Stick the Hibachi Scope in with the rest of the event data
				arguments.eventData[ "#getApplicationValue('applicationKey')#Scope" ] = getHibachiScope();
				// Attempt to evaluate this method
				
				if(structKeyExists(object,'callEvent')){
					object.callEvent(eventName=arguments.eventName,eventData=arguments.eventData);
				//support legacy event handlers
				}else{ 
					// Attempt to evaluate this method
					evaluate("object.#eventName#( argumentCollection=arguments.eventData )");	
				}
				
			}
		}
	}
	
	public void function registerEvent( required string eventName, required any object, string objectFullname ) {
		if(!structKeyExists(variables,'registeredEvents')){
			variables.registeredEvents={};
		}
	
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
			var objectFullname = getMetadata(arguments.eventHandler).fullname;
			var object = arguments.eventHandler;
		} else if (isSimpleValue(arguments.eventHandler)) {
			var objectFullname = arguments.eventHandler;
			var object = getEventHandler( arguments.eventHandler );
		}
		
		if(!isNull(object)) {
			var functions = [];
			var objectMetaData = getMetaData(object);
			if(structKeyExists(objectMetaData, "functions")){
				for(var functionItem in objectMetaData.functions){
					arrayAppend(functions,functionItem);
				}
			}
			
			while(structKeyExists(objectMetaData,'extends')){
				objectMetaData = objectMetaData.extends;
				if(structKeyExists(objectMetaData, "functions")){
					for(var functionItem in objectMetaData.functions){
						arrayAppend(functions,functionItem);
					}
				}
			}
			if(arrayLen(functions)) {
				for(var f=1; f<=arrayLen(functions); f++) {
					if(!structKeyExists(functions[f], "access") || functions[f].access == "public") {
						registerEvent(eventName=functions[f].name, object=object, objectFullname=objectFullname);
					}
				}	
			}
		}
	}
	
	public any function getEntityEventNameHashMap(){
		var entityEventNameHashMap = {};
		
		var entityEventNameOptions = getEntityEventNameOptions();
		for(entityEventNameOption in entityEventNameOptions){
			entityEventNameHashMap[entityEventNameOption.name] = entityEventNameOption.value;
		}
	}
	
	public any function getEntityEventNameOptions(string eventfilter=""){
		var opArr = [];
		var emd = getEntitiesMetaData();
		var entityNameArr = listToArray(structKeyList(emd));
		arraySort(entityNameArr, "text");
		for(var i=1; i<=arrayLen(entityNameArr); i++) {
			var entityName = entityNameArr[i];
			if(!len(arguments.eventFilter) || arguments.eventFilter == 'before'){
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.before')# #getHibachiScope().rbKey('define.save')# | before#entityName#Save", value="before#entityName#Save", entityName=entityName});
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.before')# #getHibachiScope().rbKey('define.delete')# | before#entityName#Delete", value="before#entityName#Delete", entityName=entityName});
			}
			
			if(!len(arguments.eventFilter) || arguments.eventFilter == 'after'){
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.save')# | after#entityName#Save", value="after#entityName#Save", entityName=entityName});
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.save')# #getHibachiScope().rbKey('define.success')# | after#entityName#SaveSuccess", value="after#entityName#SaveSuccess", entityName=entityName});
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.save')# #getHibachiScope().rbKey('define.failure')# | after#entityName#SaveFailure", value="after#entityName#SaveFailure", entityName=entityName});
				
				
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.delete')# | after#entityName#Delete", value="after#entityName#Delete", entityName=entityName});
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.delete')# #getHibachiScope().rbKey('define.success')# | after#entityName#DeleteSuccess", value="after#entityName#DeleteSuccess", entityName=entityName});
				arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('define.delete')# #getHibachiScope().rbKey('define.failure')# | after#entityName#DeleteFailure", value="after#entityName#DeleteFailure", entityName=entityName});
			}
			
			if(structKeyExists(emd[entityName], "hb_processContexts")) {
				for(var c=1; c<=listLen(emd[entityName].hb_processContexts); c++) {
					var thisContext = listGetAt(emd[entityName].hb_processContexts, c);
					if(!len(arguments.eventFilter) || arguments.eventFilter == 'before'){
						arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.before')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# | before#entityName#Process_#thisContext#", value="before#entityName#Process_#thisContext#", entityName=entityName});
					}
					if(!len(arguments.eventFilter) || arguments.eventFilter == 'after'){
						arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# | after#entityName#Process_#thisContext#", value="after#entityName#Process_#thisContext#", entityName=entityName});
						arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# #getHibachiScope().rbKey('define.success')# | after#entityName#Process_#thisContext#Success", value="after#entityName#Process_#thisContext#Success", entityName=entityName});
						arrayAppend(opArr, {name="#getHibachiScope().rbKey('entity.#entityName#')# - #getHibachiScope().rbKey('define.after')# #getHibachiScope().rbKey('entity.#entityName#.process.#thisContext#')# #getHibachiScope().rbKey('define.failure')# | after#entityName#Process_#thisContext#Failure", value="after#entityName#Process_#thisContext#Failure", entityName=entityName});
					}
				}
			}
		}
		return opArr;
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
		
		var entityEventNameOptions = getEntityEventNameOptions();
		for(var entityEventNameOption in entityEventNameOptions){
			arrayAppend(opArr,entityEventNameOption);
		}
		
		return opArr;
	}
	
	private struct function getEventNameOptionsStruct(required string entityName, string position="before", string process="save", string status=""){
		var optionStruct = {};
		optionStruct['name'] = "#getHibachiScope().rbKey('entity.#arguments.entityName#')# - ";
		
		var processPrefix = "";
		if(lcase(arguments.process) != 'save' && lcase(arguments.process) != 'delete' && lcase(arguments.process) != 'create'){
			processPrefix = "Process_";
			optionStruct['name'] &= "#getHibachiScope().rbKey('define.#arguments.position#')# #getHibachiScope().rbKey('entity.#arguments.entityName#.process.#arguments.process#')#";
		}else{
			optionStruct['name'] &= "#getHibachiScope().rbKey('define.#arguments.position#')# #getHibachiScope().rbKey('define.#arguments.process#')#"; 
		}
		if(len(arguments.status)){
			optionStruct['name'] &= " #getHibachiScope().rbKey('define.#arguments.status#')# | #arguments.position##entityName##processPrefix##arguments.process##arguments.status#";
		}else{
			optionStruct['name'] &= " | #arguments.position##arguments.entityName##processPrefix##arguments.process#";	
		}
		
		optionStruct['value'] = "#arguments.position##entityName##processPrefix##arguments.process##arguments.status#";
		optionStruct['entityName'] = arguments.entityName;
		
		return optionStruct;
	}
	
	public struct function getTriggerEventRBKeyHashMapByEntityName(required string entityName){
		
		if(!structKeyExists(variables.triggerEventRBKeyHashMap,arguments.entityName)){
			getEventNameOptionsForObject(arguments.entityName);
		}
		return variables.triggerEventRBKeyHashMap[arguments.entityName];
	}
	
	public any function getEventNameOptionsForObject(required string objectName, boolean doOneToManyOptions = true) {
		if(!structKeyExists(variables.EventNameOptions,arguments.objectName)){
			var opArr = [];
			
			var emd = getEntityMetaData(arguments.objectName);
			
			var entityName = arguments.objectName;
			
			var positions = ['before','after'];
			var processes = ['Save','Delete','Create'];
			var statuses = ['','Success','Failure'];
			
			if(structKeyExists(emd, "hb_processContexts")) {
				
				for(var c=1; c<=listLen(emd.hb_processContexts); c++) {
					var thisContext = listGetAt(emd.hb_processContexts, c);
					arrayAppend(processes,thisContext);	
				}
			}
			
			for(var process in processes){
				for(var position in positions){
					for(var status in statuses){
						var optionStruct = getEventNameOptionsStruct(arguments.objectName,position,process,status);
					
						arrayAppend(opArr, optionStruct);
						variables.triggerEventRBKeyHashMap[arguments.objectName] = {};
						variables.triggerEventRBKeyHashMap[arguments.objectName][optionStruct['value']] = optionStruct['name'];
					}
				}
			}
			
			if(arguments.doOneToManyOptions){
				var propertiesArrayLength = arrayLen(emd.properties);
				for(var d=1; d<=propertiesArrayLength;d++){
					var property = emd.properties[d];
					if(structKeyExists(property,'fieldType') && property.fieldType == 'one-to-many' && property.cfc != arguments.objectName){
						var relationshipOptions = getEventNameOptionsForObject(property.CFC,false);
						opArr = getService('hibachiUtilityService').arrayConcat(opArr,relationshipOptions);
					}
				}
			}
			variables.EventNameOptions[arguments.objectName] = opArr;
		}
		
		return variables.EventNameOptions[arguments.objectName];
	}
	
}
