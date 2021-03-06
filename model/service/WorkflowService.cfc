/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService" accessors="true" output="false" {

	property name="hibachiService" type="any";
	property name="hibachiUtilityService" type="any";	
	property name="hibachiEntityQueueDAO" type="any";
	property name="workflowDAO" type="any";


	// ===================== START: Logical Methods ===========================
	
	public boolean function runWorkflowByEventTrigger(required any workflowTrigger, required any entity){
			//only flush on after
			if(left(arguments.workflowTrigger.getTriggerEvent(),'5')=='after'){
				getHibachiScope().flushORMSession();
			}
			
			var successFlag = false;
			if(arguments.workflowTrigger.getStartDateTime() > now() || (!isNull(arguments.workflowTrigger.getEndDateTime()) && arguments.workflowTrigger.getEndDateTime() < now())){
				return; 
			}
	
			if(arguments.workflowTrigger.getSaveTriggerHistoryFlag() == true) {
	
				// Create a new workflowTriggerHistory to be logged
				var workflowTriggerHistory = this.newWorkflowTriggerHistory();
	
				//Attach workflowTrigger to workflowTriggerHistory
				workflowTriggerHistory.setWorkflowTrigger(arguments.workflowTrigger);
				workflowTriggerHistory.setStartTime(now());
			}
			
			try {
				var processData = {};
	
				// If the triggerObject is the same as this event, then we just use it
				if (isNull(arguments.workflowTrigger.getObjectPropertyIdentifier()) || !len(arguments.workflowTrigger.getObjectPropertyIdentifier()) || arguments.workflowTrigger.getObjectPropertyIdentifier() == arguments.entity.getClassName()) {
	
					processData['entity'] = arguments.entity;
	
				} else {
					processData['entity'] = arguments.entity.getValueByPropertyIdentifier(arguments.workflowTrigger.getObjectPropertyIdentifier());
	
				}
	
				// As long as the processEntity was found, then we can process the workflow
				if (structKeyExists(processData, "entity") && !isNull(processData.entity) && isObject(processData.entity) && processData.entity.getClassName() == arguments.workflowTrigger.getWorkflow().getWorkflowObject()) {
					processData['workflowTrigger'] = arguments.workflowTrigger;
	
					this.processWorkflow(arguments.workflowTrigger.getWorkflow(), processData, 'execute');
				}
				
				if (!isNull(workflowTriggerHistory)) {
					// Update the workflowTriggerHistory
					
					workflowTriggerHistory.setSuccessFlag(1);
					workflowTriggerHistory.setResponse("");
				}
				successFlag = true;
			} catch (any e){
				successFlag = false;
				if (!isNull(workflowTriggerHistory)) {
					// Update the workflowTriggerHistory
					workflowTriggerHistory.setSuccessFlag(false);
					workflowTriggerHistory.setResponse(e.Message);
					workflowTrigger.setWorkflowTriggerException(e);
				}
			}
		

		if (!isNull(workflowTriggerHistory)) {
			// Set the end for history
			workflowTriggerHistory.setEndTime(now());

			// Persist the info to the DB
			workflowTriggerHistory = this.saveWorkflowTriggerHistory(workflowTriggerHistory);
		}
		return successFlag;
	}
	
	public any function runAllWorkflowsByEventTrigger( required any eventName, required any entity, required struct eventData={} ) {
		// Pull the workflowTriggerEventsArray out of cache so that it is quick and can be checked to see if we need to trigger an event
		var allWorkflowTriggerEventsArray = getHibachiCacheService().getOrCacheFunctionValue("workflowDAO_getWorkflowTriggerEventsArray", getWorkflowDAO(), "getWorkflowTriggerEventsArray");
		
		// Make sure that this event has workflows attached before creating a thread
		if(arrayFindNoCase(allWorkflowTriggerEventsArray, arguments.eventName)) {
			
			// Run all workflows inside of a thread
			//thread action="run" name="#createUUID()#" application="#application#" eventName="#arguments.eventName#" entity="#arguments.entity#" {

				var workflowTriggers = getWorkflowDAO().getWorkflowTriggersForEvent(eventName = arguments.eventName);

				for (var workflowTrigger in workflowTriggers) {
					runWorkflowByEventTrigger(workflowTrigger,arguments.entity);
				}
			//}
		}
		
	}

	public void function runWorkflowTriggerById(required string workflowTriggerID){
		var	workflowTrigger = runWorkflowsByScheduleTrigger(getHibachiScope().getEntity('WorkflowTrigger', arguments.workflowTriggerID), true);
		if(!isNull(workflowTrigger.getWorkflowTriggerException())){
			throw(workflowTrigger.getWorkflowTriggerException());
		}
	}

	public any function runWorkflowOnAllServers() {
		getDao('HibachiCacheDAO').deleteStaleServerInstance();
		if(getHibachiScope().getApplicationValue('applicationCluster') == ''){
			return;
		}
		// get all active instances in the current cluster
		var serverInstanceCollectionList = getService('HibachiService').getServerInstanceCollectionList();
		serverInstanceCollectionList.addFilter('serverInstanceClusterName',getHibachiScope().getApplicationValue('applicationCluster'));

		var serverInstances = serverInstanceCollectionList.getRecords();
		for (var serverInstance in serverInstances) {
			
	        var offset = findNoCase('Slatwall',cgi.script_name)?'Slatwall/':'';
			var workflowurl = 'http://#serverInstance["serverInstanceIPAddress"]#:#serverInstance["serverInstancePort"]#/#offset#?slatAction=api:workflow.executeScheduledWorkflows';
			this.logHibachi('Invoking workflows on #workflowurl#');
			var req = new http();
	        req.setMethod("get");
	        req.setUrl(workflowurl);
	        req.setTimeOut(3);
	        var res = req.send().getPrefix();
		}
		// delete all old server instance
		getDao('HibachiCacheDAO').deleteStaleServerInstance();
	}
	
	public any function runAllWorkflowsByScheduleTrigger() {
		
		// update timestamp on server instance
		getDao('hibachiCacheDAO').updateServerInstanceLastRequestDateTime();
		
		var workflowTriggers = getWorkflowDAO().getDueWorkflows();
		var exclusiveInvocationClusters = getWorkflowDAO().getExclusiveWorkflowTriggersInvocationClusters();
		for(var workflowTrigger in workflowTriggers) {
			// make sure workflow runs on the allowed cluster
			if( !isNull(workflowTrigger.getAllowedInvocationCluster()) && len(workflowTrigger.getAllowedInvocationCluster()) && !findNoCase(getHibachiScope().getApplicationValue('applicationCluster'), workflowTrigger.getAllowedInvocationCluster())) {
				continue;
			}
			// make sure exlcusive domain is only used for those workflows
			if( findNoCase(getHibachiScope().getApplicationValue('applicationCluster'), exclusiveInvocationClusters) && (isNull(workflowTrigger.getAllowedInvocationCluster()) || !findNoCase(workflowTrigger.getAllowedInvocationCluster(), exclusiveInvocationClusters)) ) {
				continue;
			}
			
			if(workflowTrigger.getLockLevel() == 'database' && !isNull(workflowTrigger.getRunningFlag()) && workflowTrigger.getRunningFlag()){
				//timed out
				if( DateAdd("n",val(workflowTrigger.getTimeout()),workflowTrigger.getNextRunDateTime()) < now() ){
					getWorkflowDAO().resetExpiredWorkflow(workflowTrigger.getWorkflowTriggerID());
				}else{
				// not timed out yet, skip
					continue;
				}
			}
			
			runWorkflowsByScheduleTrigger(workflowTrigger);
		}
	}

	public boolean function updateWorkflowTriggerRunning(required any workflowTrigger,required boolean runningFlag){
		var okToRunWorkflow = true;
		//application based workflows rely on application locking instead of database so keep running flag false
		if(arguments.workflowTrigger.getLockLevel()=='database' || !arguments.runningFlag){
			okToRunWorkflow = getWorkflowDAO().updateWorkflowTriggerRunning(workflowTriggerID=arguments.workflowTrigger.getWorkflowTriggerID(), runningFlag=arguments.runningFlag);
		}
		return okToRunWorkflow;
	}

	public any function runWorkflowsByScheduleTrigger(required any workflowTrigger, boolean skipTriggerRunningCheck = false) {
		this.logHibachi('Start executing workflow: #arguments.workflowTrigger.getWorkflow().getWorkflowName()#', true);
		var triggerExecutionStartTime = getTickCount();
		
		var timeout = workflowTrigger.getTimeout();
		if(!isNull(timeout)){
			//convert to seconds
			timeout = timeout * 60;
			getService('hibachiTagService').cfsetting(requesttimeout=timeout);
		}

		if(
			arguments.workflowTrigger.getLockLevel()=='database'
			&& arguments.workflowTrigger.getStartDateTime() > now() 
			|| (
				!isNull(arguments.workflowTrigger.getEndDateTime()) 
				&& arguments.workflowTrigger.getEndDateTime() < now()
			)
		){	
			return arguments.workflowTrigger;
		}
		
		lock name="runWorkflowsByScheduleTrigger_#getHibachiScope().getServerInstanceKey()#_#arguments.workflowTrigger.getWorkflowTriggerID()#" timeout="5" throwontimeout=false{
			//Change WorkflowTrigger runningFlag to TRUE
			var okToRunWorkflow = updateWorkflowTriggerRunning(workflowTrigger=arguments.workflowTrigger, runningFlag=true);
			if( !okToRunWorkflow && !arguments.skipTriggerRunningCheck){
				return arguments.workflowTrigger;
			}
			
			if(workflowTrigger.getSaveTriggerHistoryFlag() == true){
				// Create a new workflowTriggerHistory to be logged
				var workflowTriggerHistory = this.newWorkflowTriggerHistory();
				//Attach workflowTrigger to workflowTriggerHistory
				workflowTriggerHistory.setWorkflowTrigger(arguments.workflowTrigger);
				workflowTriggerHistory.setStartTime(now());
				workflowTriggerHistory.setServerInstanceKey(getHibachiScope().getServerInstanceKey());
				// Persist the info to the DB
				workflowTriggerHistory = this.saveWorkflowTriggerHistory(workflowTriggerHistory);
				getHibachiDAO().flushORMSession();
			}
	
	
	
			try{
				//get workflowTriggers Object
				//execute Collection and return only the IDs

				getService('hibachiEventService').announceEvent('beforeWorkflowTriggerPopulate',{workflowTrigger=arguments.workflowTrigger,timeout=timeout});
				
				if(	arguments.workflowTrigger.getCollectionBasedFlag() && !isNull(arguments.workflowTrigger.getCollection()) ){
					
					var scheduleCollection = arguments.workflowTrigger.getCollection();
					var currentObjectName = arguments.workflowTrigger.getCollection().getCollectionObject();
					
				
					if(arguments.workflowTrigger.getCollectionPassthrough()){
							
							//Don't Instantiate every object, just passthrough the collection records returned
							var processData = {
								'entity' : this.invokeMethod('new#currentObjectName#'),
								'workflowTrigger' : arguments.workflowTrigger,
								'collectionConfig' : scheduleCollection.getCollectionConfigStruct() 
							};

							if(arguments.workflowTrigger.getCollectionFetchRecordsFlag()){
								scheduleCollection.setDirtyReadFlag(true);
								
								if(isNumeric(arguments.workflowTrigger.getCollectionFetchSize()) && arguments.workflowTrigger.getCollectionFetchSize() > 0){
									scheduleCollection.setPageRecordsShow(arguments.workflowTrigger.getCollectionFetchSize());
									getHibachiScope().setValue('debug_collection_config', scheduleCollection.getCollectionConfig());
									processData['collectionData'] = scheduleCollection.getPageRecords(formatRecords=false);
								}else{
									processData['collectionData'] = scheduleCollection.getRecords(formatRecords=false);
								}
								
							}

							//Call proccess method to execute Tasks
							this.processWorkflow(workflowTrigger.getWorkflow(), processData, 'execute');
					} else {
	
						var currentObjectPrimaryIDName = getService('HibachiService').getPrimaryIDPropertyNameByEntityName(currentObjectName);
						var triggerCollectionResult = scheduleCollection.getPrimaryIDs(arguments.workflowTrigger.getCollectionFetchSize());
						for(var i=1; i <= ArrayLen(triggerCollectionResult); i++){
							//get current ObjectID
							var workflowTriggerID = arguments.workflowTrigger.getWorkflowTriggerID();
							var currentObjectID = triggerCollectionResult[i][currentObjectPrimaryIDName];
							var currentThreadName = "thread_#right(workflowTriggerID, 6)&i#";
			
							thread action="run" name="#currentThreadName#" currentObjectName="#currentObjectName#" currentObjectID="#currentObjectID#" workflowTriggerID="#workflowTriggerID#"{
								//load Objects by id
			
								var workflowTrigger = getHibachiScope().getEntity('WorkflowTrigger', workflowTriggerID);
								var processData = {
									'entity' : getHibachiScope().getEntity(currentObjectName, currentObjectID),
									'workflowTrigger' : workflowTrigger
								};
			
								//Call proccess method to execute Tasks
								this.processWorkflow(workflowTrigger.getWorkflow(), processData, 'execute');
			
								if(processData.entity.hasErrors()) {
									throw("error");
									//application[getDao('hibachiDao').gethibachiInstanceApplicationScopeKey()].application.endHibachiLifecycle();
								}
			
								if(!getHibachiScope().getORMHasErrors()) {
									getHibachiScope().getDAO("hibachiDAO").flushORMSession();
								}
								// Commit audit queue
								getHibachiScope().getService("hibachiAuditService").commitAudits();
							}
							threadJoin(currentThreadName);
			
							//if there was any errors inside of the thread, propagate to catch
							if(structKeyExists(evaluate(currentThreadName), 'error')){
								writedump(evaluate(currentThreadName).error);
								throw(evaluate(currentThreadName).error.message);
							}
						}
					}
				//run process without collection
				}else{
					var processData = {
						'workflowTrigger' : arguments.workflowTrigger
					};

					//Call proccess method to execute Tasks
					this.processWorkflow(workflowTrigger.getWorkflow(), processData, 'execute');

					if(structKeyExists(processData,'entity') && processData.entity.hasErrors()) {
						throw("error");
						//application[getDao('hibachiDao').gethibachiInstanceApplicationScopeKey()].application.endHibachiLifecycle();
					}
	
					if(!getHibachiScope().getORMHasErrors()) {
						getHibachiScope().getDAO("hibachiDAO").flushORMSession();
					}
					// Commit audit queue
					getHibachiScope().getService("hibachiAuditService").commitAudits();
				}
				
				if(!isNull(workflowTriggerHistory)){
					// Update the workflowTriggerHistory
					workflowTriggerHistory.setSuccessFlag( true );
					workflowTriggerHistory.setResponse( "" );
				}
	
			} catch(any e){
				if(!isNull(workflowTriggerHistory)) {
					// Update the workflowTriggerHistory
					workflowTriggerHistory.setSuccessFlag(false);
					workflowTriggerHistory.setResponse(e.Message);
					workflowTrigger.setWorkflowTriggerException(e);
				}
			}
		}
		
		//Change WorkflowTrigger runningFlag to FALSE
		updateWorkflowTriggerRunning(workflowTrigger=arguments.workflowTrigger, runningFlag=false);
	

		if(!isNull(workflowTriggerHistory)) {
			// Set the end for history
			workflowTriggerHistory.setEndTime(now());
			// Persist the info to the DB
			workflowTriggerHistory = this.saveWorkflowTriggerHistory(workflowTriggerHistory);
		}

		// Update the taskSechedules nextRunDateTime
		if(!isNull(arguments.workflowTrigger.getSchedule())){
			var runDateTimeData = {};
			if(!isNull(arguments.workflowTrigger.getStartDateTime())){
				runDateTimeData['startDateTime'] = arguments.workflowTrigger.getStartDateTime();
			}
			if(!isNull(arguments.workflowTrigger.getEndDateTime())){
				runDateTimeData['endDateTime'] = arguments.workflowTrigger.getEndDateTime();
			}
			var nextRunDateTime = arguments.workflowTrigger.getSchedule().getNextRunDateTime(argumentCollection=runDateTimeData);
	
			workflowTrigger.setNextRunDateTime( nextRunDateTime );
		}
		this.saveWorkflowTrigger(entity=workflowTrigger, resetCacheFlag=false);


		// Flush the DB again to persist all updates
		getHibachiDAO().flushORMSession();
		this.logHibachi('Finished executing workflow: #arguments.workflowTrigger.getWorkflow().getWorkflowName()# - #getFormatedExecutionTime(triggerExecutionStartTime, getTickCount())#', true);
		return workflowTrigger;
	}
	
	private string function getFormatedExecutionTime(required numeric start, required numeric end){
		var millis = end - start;
		var formatedValue = 'Duration: ' & numberFormat(millis) & ' ms';
		
		//tags to simplify search
		if(millis > 300000){
			formatedValue &= ' [over5minutes]';
		}else if(millis > 180000){
			formatedValue &= ' [over3minutes]';
		}else if(millis > 120000){
			formatedValue &= ' [over2minutes]';
		}else if(millis > 60000){
			formatedValue &= ' [over1minute]';
		}else if(millis > 30000){
			formatedValue &= ' [over30seconds]';
		}
		return formatedValue;
	}

	private boolean function executeTaskAction(required any workflowTaskAction, any entity, required string type, struct data = {}){
		var actionSuccess = false;

		switch (workflowTaskAction.getActionType()) {
			// EMAIL
			case 'email' :
				
				var email = getService('emailService').generateAndSendFromEntityAndEmailTemplate(entity=arguments.entity, emailTemplate=workflowTaskAction.getEmailTemplate());
				if(!email.hasErrors()) {
					actionSuccess = true;
				}
				break;

			// PRINT
			case 'print' :
				var print = getService('printService').generateAndPrintFromEntityAndPrintTemplate(entity=arguments.entity, emailTemplate=workflowTaskAction.getPrintTemplate());
				if(!print.hasErrors()) {
					actionSuccess = true;
				}
				break;

			// UPDATE
			case 'update' :
				// Setup the updateData object that will be used during the save functions 'populate'
				var updateData = {};
				// Attempt to pull the update data out of the object
				if(isJSON(workflowTaskAction.getUpdateData())) {
					var allUpdateData = deserializeJSON(workflowTaskAction.getUpdateData());
					// If there is static data, set that as the updateData by default
					if(structKeyExists(allUpdateData, "staticData")) {
						updateData = allUpdateData.staticData;
					}
					// Then look for dynamic data that needs to be updated
					if(structKeyExists(allUpdateData, "dynamicData")) {
						structAppend(updateData, setupDynamicUpdateData(arguments.entity, allupdateData.dynamicData));
					}
					getHibachiScope().saveEntity(arguments.entity,updateData);
				};
				if(!arguments.entity.hasErrors()) {
					actionSuccess = true;
				}
				break;

			//PROCESS
			case 'process' :
				
				// Append extra data passed in the WorkflowAction
				structAppend(arguments.data, arguments.workflowTaskAction.getProcessMethodDataStruct(), true);
					
				if(structKeyExists(arguments,'entity')){
					var entityService = getServiceByEntityName( entityName=arguments.entity.getClassName());
					var processContext = listLast(workflowTaskAction.getProcessMethod(),'_');
					
					

					//process will determine whether we need to inflate a process object or pass data directly
					arguments.entity = entityService.process(arguments.entity, arguments.data, processContext);
					
					if(!arguments.entity.hasErrors()) {
						actionSuccess = true;
					}
				}else{
					var entityService = getServiceByEntityName( entityName=arguments.workflowTaskAction.getWorkflowTask().getWorkflow().getWorkflowObject());
					try{
						var processMethod = entityService.invokeMethod(arguments.workflowTaskAction.getProcessMethod(), { 'data' : arguments.data } );
						actionSuccess = true;
					}catch(any e){
						actionSuccess = false;
					}
				}
				
				break;
			case 'processByQueue' :

				if(!isNull(arguments.workflowTaskAction.getProcessEntityQueueFlagPropertyName())){		
					actionSuccess = bulkEntityQueueInsertByEntityQueueFlagProperty(argumentCollection=arguments); 
					break; 
				} 				

				//fallback solution not ideal for large data sets
				if(structKeyExists(arguments.data, 'collectionData')){ 	
					
					var primaryIDName = getHibachiService().getPrimaryIDPropertyNameByEntityName(arguments.entity.getClassName()); 
					var primaryIDsToQueue = getHibachiUtilityService().arrayOfStructsToList(arguments.data.collectionData, primaryIDName);
					getHibachiEntityQueueDAO().bulkInsertEntityQueueByPrimaryIDs(primaryIDsToQueue, arguments.entity.getClassName(), arguments.workflowTaskAction.getProcessMethod(), arguments.workflowTaskAction.getUniqueFlag());
					
					actionSuccess = true; 
				}
				break;

			case 'processEmailByQueue' : 

				if(isNull(arguments.workflowTaskAction.getEmailTemplate())){
					actionSuccess = false;
					break; 
				} 

				arguments.processMethod = 'process#arguments.entity.getClassName()#_email';

				arguments.entityQueueData = {
					'emailTemplate' : {
						'emailTemplateID' : arguments.workflowTaskAction.getEmailTemplate().getEmailTemplateID()
					} 
				}; 

				if(arguments.type == 'Event'){
					arguments.baseObject = arguments.entity.getClassName();
					arguments.baseID = arguments.entity.getPrimaryIDValue();
					getHibachiEntityQueueDAO().insertEntityQueue(argumentCollection=arguments);
					actionSuccess = true; 
				} else {
					actionSuccess = bulkEntityQueueInsertByEntityQueueFlagProperty(argumentCollection=arguments); 
				}
				
				break; 

			case 'utility' :
				// Append extra data passed in the WorkflowAction
				structAppend(arguments.data, arguments.workflowTaskAction.getProcessMethodDataStruct(), true);
				
				try{
					var processMethod = getService('HibachiUtilityService').invokeMethod(arguments.workflowTaskAction.getProcessMethod(), arguments.data );
					actionSuccess = true;
				}catch(any e){
					actionSuccess = false;
				}
				
				
				break;

			//IMPORT
			case 'import' :
				// TODO: Impliment This
				break;

			//EXPORT
			case 'export' :
				// TODO: Impliment This
				break;

			//EXPORT
			case 'webhook' :
				
				var payload = {
					"eventName": "",
					"eventTimeStamp": now(),
					"entity": arguments.entity.getClassName(),
					"data": ""
				};
				
				if(!isNull(arguments.data.workflowTrigger)){
					payload['eventName'] = arguments.data.workflowTrigger.getTriggerEventTitle();
				}
				
				var payloadData = arguments.workflowTaskAction.getProcessMethodData();
				
				if(!isNull(payloadData) && len(payloadData)){
					var payloadData = arguments.entity.stringReplace(payloadData,false,true);
					// if root key is data, override, otherwise append
					if(isJSON(payloadData)){
						payloadDataStruct = deserializeJSON(payloadData);
						if(structKeyExists(payloadDataStruct,'data')){
							payload['data'] = payloadDataStruct['data'];
						} else if(structKeyExists(payloadDataStruct,'custom')){
							payload = payloadDataStruct['custom'];
						} else {
							payload['extraData'] = payloadDataStruct;
						}
					} else {
						payload['extraData'] = payloadData;
					}
				}
				
				if(structKeyExists(payload, 'data') && !isStruct(payload['data']) && !len(payload['data'])){
					payload['data'] = arguments.entity.getStructRepresentation();
				}
				
				if(arguments.type == 'Event'){
					runWebhookInThread(arguments.workflowTaskAction.getWebhookURL(), payload);
				} else {
					runWebhook(arguments.workflowTaskAction.getWebhookURL(), payload);
				}

				break;

			//DELETE
			case 'delete' :
				if(type != 'Event'){
					actionSuccess = getHibachiScope().deleteEntity(arguments.entity);
				}else{
					actionSuccess = false;
				}
				break;
		}
		return actionSuccess;
	}
	
	private void function runWebhookInThread(required any webhookURL, required struct payload){
		var currentThreadName = hash(serializeJSON(arguments));
		this.logHibachi('Invoking weblook with thread name: #currentThreadName#');
		thread action="run" name="#currentThreadName#" threadData="#arguments#"{
			// removing this log line stops webhook from working, need to figure out why.
			this.logHibachi('call webhook inside thread');
			this.runWebhook(argumentCollection=threadData);
		}
	}

	private void function runWebhook(required any webhookURL, required struct payload){

		var req = new http();
        req.setMethod("POST"); 
        req.setUrl(arguments.webhookURL);
        req.addParam(type="header",name="Content-Type", value="application/json");
        req.addParam(type="body", value="#serializeJSON(arguments.payload)#"); 
        var res = req.send().getPrefix();
        actionSuccess = left(res.status_code, 1) == "2";
		this.logHibachi('Webhook finished with status code : #res.status_code#');
		
		if(!actionSuccess){
			//TODO: Add to reetry queue with 3 retries
		}
	}
	
	private boolean function bulkEntityQueueInsertByEntityQueueFlagProperty( required any workflowTaskAction, required any entity, string processEntityQueueFlagPropertyName, string processMethod, struct data = {}, struct entityQueueData = {}){


			if(!structKeyExists(arguments, 'processMethod')){	
				arguments.processMethod = arguments.workflowTaskAction.getProcessMethod(); 
			}	

			if(isNull(arguments.processMethod)){
				return false; 
			} 

			if(!structKeyExists(arguments, 'processEntityQueueFlagPropertyName')){
				arguments.processEntityQueueFlagPropertyName = arguments.workflowTaskAction.getProcessEntityQueueFlagPropertyName();	
			} 

			if(isNull(arguments.processEntityQueueFlagPropertyName)){
				return false; 
			} 
			
			if(!structKeyExists(arguments, 'processMethod')){
				return false; 	
			} 
			
			//we need some form of collection data for this to work
			if(!structKeyExists(arguments.data, 'collectionData') && !structKeyExists(arguments.data, 'collectionConfig')){
				return false;
			}
			
			if(!arguments.entity.hasProperty(arguments.processEntityQueueFlagPropertyName)){
				return false; 
			}	

			var entityCollection = arguments.entity.getEntityCollectionList();
			entityCollection.setCollectionConfigStruct(arguments.data.collectionConfig); 
					
			var updateData = {
				'#arguments.processEntityQueueFlagPropertyName#': true
			};

			entityCollection.executeUpdate(updateData);		

			//call entity queue dao to insert into with a select
			getHibachiEntityQueueDAO().bulkInsertEntityQueueByFlagPropertyName(arguments.processEntityQueueFlagPropertyName, arguments.entity.getClassName(), arguments.processMethod, arguments.workflowTaskAction.getUniqueFlag(), updateData[processEntityQueueFlagPropertyName], arguments.entityQueueData);
					
			updateData['#arguments.processEntityQueueFlagPropertyName#'] = false;

			entityCollection.executeUpdate(updateData);

			return true; 
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processWorkflow_execute(required any workflow, required struct data) {
	   
		getHibachiScope().setObjectPopulateMode( 'private' );
		
		// Loop over all of the tasks for this workflow
		for(var workflowTask in arguments.workflow.getWorkflowTasks()) {

			// Check to see if the task is active and the entity object passes the conditions validation
			if(
				workflowTask.getActiveFlag() 
				&& 
				(
					!structKeyExists(arguments.data,'entity')
					||
					(
						structKeyExists(arguments.data,'entity')
					&& 
						entityPassesAllWorkflowTaskConditions(arguments.data.entity, workflowTask.getTaskConditionsConfigStruct()) 
					)
				)
			){
				
				// Now loop over all of the actions that can now be run that the workflow task condition has passes
				for(var workflowTaskAction in workflowTask.getWorkflowTaskActions()) {
					if(!isNull(workflowTaskAction.getUpdateData()) && !isNull(workflowTaskAction.getActionType())){
					        
							if(data.workflowTrigger.getTriggerType() == 'Event'){
								arguments.data.entity.setAnnounceEvent(false);
							}
							
							//Execute ACTION
							if(structKeyExists(arguments.data,'entity')){
								var actionSuccess = executeTaskAction(workflowTaskAction, arguments.data.entity, data.workflowTrigger.getTriggerType(), arguments.data);
							}else{
								var actionSuccess = executeTaskAction(workflowTaskAction, javacast('null',''), data.workflowTrigger.getTriggerType(), arguments.data);
							}

							if(data.workflowTrigger.getTriggerType() == 'Event') {
								arguments.data.entity.setAnnounceEvent(true);
							}
        			}
				}
			} 
		}
		
		
		if(structKeyExists(arguments.data,'entity')){
			return arguments.data.entity;
		//process methods must return entities
		}else{
			return arguments.workflow;
		}
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveWorkflow(required any entity, struct data={}) {
		// Call the default save logic
		arguments.entity = super.save(argumentcollection=arguments);
		// If there aren't any errors then flush, and clear cache
		if(!getHibachiScope().getORMHasErrors()) {
			
			getHibachiCacheService().updateServerInstanceSettingsCache();
			
			getHibachiDAO().flushORMSession();
			
			getHibachiCacheService().resetCachedKey('workflowDAO_getWorkflowTriggerEventsArray');
		}
		
		return arguments.entity;
	}
	
	public any function saveWorkflowTrigger(required any entity, struct data={}, resetCacheFlag=true) {

		// Call the default save logic
		arguments.entity = super.save(argumentcollection=arguments);

		//Check if is a Schedule Trigger
		if(structKeyExists(arguments.data, "schedule") && !isNull(entity.getSchedule())){
		// Update the nextRunDateTime
			arguments.entity.setNextRunDateTime( entity.getSchedule().getNextRunDateTime(entity.getStartDateTime(), entity.getEndDateTime()) );
		}
		
		// If there aren't any errors then flush, and clear cache
		if(!getHibachiScope().getORMHasErrors() && arguments.resetCacheFlag) {
			
			getHibachiCacheService().updateServerInstanceSettingsCache();
			
			getHibachiDAO().flushORMSession();
			
			getHibachiCacheService().resetCachedKey('workflowDAO_getWorkflowTriggerEventsArray');
		}
		
		return arguments.entity;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	public boolean function deleteWorkflowTrigger(required any entity) {
		
		var deleteResult = super.delete(argumentcollection=arguments); 
		
		// If there aren't any errors then flush, and clear cache
		if(deleteResult && !getHibachiScope().getORMHasErrors()) {
			
			getHibachiCacheService().updateServerInstanceSettingsCache();
			
			getHibachiDAO().flushORMSession();
			
			getHibachiCacheService().resetCachedKey('workflowDAO_getWorkflowTriggerEventsArray');
		}

		return deleteResult;
	}
	
	// =====================  END: Delete Overrides ===========================
	
	// ================== START: Private Helper Functions =====================
	
	private string function getLogicalOperator(required string logicalOperator){
		switch(lcase(arguments.logicalOperator)){
			case "or":
				return "OR";
			break;
			case "and":
				return "AND";
			break;
		}
		return 'AND';
	}
	
	private string function getWorkflowConditionGroupsString(required any entity, required array workflowConditionGroups){
		var workflowConditionGroupsString = '';
		for(var workflowConditionGroup in arguments.workflowConditionGroups){
			var logicalOperator = '';
			
			if(structKeyExists(workflowConditionGroup,'logicalOperator')){
				logicalOperator = getLogicalOperator(workflowConditionGroup.logicalOperator);
			}
			var workflowConditionGroupString = getWorkflowConditionGroupString(arguments.entity,workflowConditionGroup.filterGroup);
			if(len(workflowConditionGroupString)){
				workflowConditionGroupsString &= " #logicalOperator# (#workflowConditionGroupString#)";
			}
		}
		return workflowConditionGroupsString;
	}
	
	private string function getWorkflowConditionGroupString(required any entity, required array workflowConditionGroup){
		var workflowConditionGroupString = '';
		for(var workflowCondition in arguments.workflowConditionGroup){
			var logicalOperator = '';
			if(structKeyExists(workflowCondition,"logicalOperator")){
				logicalOperator = workflowCondition.logicalOperator;
			}
				
			if(structKeyExists(workflowCondition,"filterGroup")){
				
				workflowConditionGroupString &= getWorkflowConditionGroupsString(arguments.entity,[workflowCondition]);
			}else{
				var comparisonOperator = getComparisonOperator(workflowCondition.comparisonOperator);
				if(len(comparisonOperator)){

					if(comparisonOperator == 'null'){
						workflowCondition.value = (lcase(workflowCondition.comparisonOperator) == 'is');
					} 

					workflowConditionGroupString &= " #logicalOperator# #getHibachiValidationService().invokeMethod('validate_#comparisonOperator#',{1=arguments.entity, 2=listRest(workflowCondition.propertyIdentifier,'.'), 3=workflowCondition.value})# " ;	
				}
			}
				
		}
		
		return workflowConditionGroupString;
	}
	
	
	private string function getComparisonOperator(required string comparisonOperator)
	{
		switch(arguments.comparisonOperator){
			case "is not":
				return "null"
			break; 
			case "is":
				return "null"
			break; 
			case "=":
				return "eq";
			break;
			case "!=":
				return "neq";
			break;
			case "<>":
				return "neq";
			break;
			case ">":
				return "gt";
			break;
			case "<":
				return "lt";
			break;
			case "<=":
				return "gte";
			break;
			case ">=":
				return "lte";
			break;
			case "in":
				return "inList";
			break;
			case "not in":
				return "notInList";
			break;
		}
		return arguments.comparisonOperator;
	}	
	
	private boolean function entityPassesAllWorkflowTaskConditions( required any entity, required any taskConditions ) {
		getHibachiDAO().flushORMSession();
		
		/*
		
		You are going to want to use:
		
		getHibachiValidationService().validate_{constraintType}( object=arguments.entity, propertyIdentifier=?, constraintValue=?);
		
		Examples are:
		
		propertyIdentifier = 'defaultSku.price'
		constraintType = 'required'
		constraintValue = 'true'
		
		or
		
		propertyIdentifier = 'password'
		constraintType = 'eqProperty'
		constraintValue = 'passwordConfirm'
		
		*/
		//if we have a any workflow conditions then evaluate them otherwise evaluate as true
		
		if(arguments.entity.getNewFlag()){
			if(arraylen(arguments.taskConditions.filterGroups)){
				var booleanExpressionString = getWorkflowConditionGroupsString(arguments.entity,arguments.taskConditions.filterGroups);
				if(len(booleanExpressionString)){
					return evaluate(booleanExpressionString);
				}else{
					return true;
				}
			}else{
				return true;
			}
		}else{
		    
		    
			var entityCollectionlist = getCollectionlist(arguments.entity.getClassName());
			arguments.taskConditions = serializeJson(arguments.taskConditions);
			arguments.taskConditions = rereplace(arguments.taskConditions,'"eq"','"="','all');
			arguments.taskConditions = rereplace(arguments.taskConditions,'"neq"','"!="','all');
			arguments.taskConditions = deserializeJSON(arguments.taskConditions);

			entityCollectionlist.setCollectionConfigStruct(arguments.taskConditions);
			entityCollectionlist.addFilter(arguments.entity.getPrimaryIDPropertyName(),arguments.entity.getPrimaryIDValue(),'=','AND',"","isolatedFilter");
			entityCollectionlist.setDisplayProperties(arguments.entity.getPrimaryIDPropertyName());
			//only can return 1 item or no items
			return entityCollectionlist.getRecordsCount();
		}
		
		
	}
	
	private boolean function setupDynamicUpdateData(required any entity, required struct dynamicData) {
		
		
		var responseData = {};
		
		/*
		TODO this needs to loop over all of the stuct keys, figure out the type of dynamicData
		here are some example of dynamic data
		
		arguments.dynamicData = {
			'orderExpectedShipDate' = {
				'dynamicType' = 'dateAddNow',
				'datePart' = 'd',
				'number' = 3,
			},
			'account.lastOrderPlacedDateTime' = {
				'dynamicType' = 'copyProperty',
				'dynamicParam' = 'orderPlacedDateTime'
			},
			'account.totalHighTicketOrdersPlaced' = {
				'dynamicType' = 'increaseInt',
				'increaseAmount' = 1
			}
		}
		
		for(var key in arguments.dynamicData) {
			
			var originalValue = arguments.entity.getValueByPropertyIdentifier( key );
			
			if(arguments.dynamicData[ key ].dynamicType == 'dateAdd') {
				newValue = dateAdd('d', ?, originalValue);
				
			} else if(arguments.dynamicData[ key ].dynamicType == 'dateAddFromNow') {
				newValue = dateAdd('d', ?, originalValue);
				
			} else if(arguments.dynamicData[ key ].dynamicType == 'increaseInt') {
				newValue = originalValue + 1;
				
			} else if(arguments.dynamicData[ key ].dynamicType == 'decreaseInt') {
				newValue = originalValue - 1;
				
			} else if(arguments.dynamicData[ key ].dynamicDataType == 'stringReplace') {
				newValue = arguments.entity.stringReplace(arguments.dynamicData[ key ].stringTemplate);
				
			}
			
			responseData[ key ] = newValue;
		}
		
		*/
		
		
		return responseData;
	}
	
	// ==================  END:  Private Helper Functions =====================

	// =================== START: Deprecated Functions ========================
	
	// ===================  END: Deprecated Functions =========================
	
}
