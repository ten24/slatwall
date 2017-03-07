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
	
	property name="workflowDAO" type="any";


	// ===================== START: Logical Methods ===========================
	
	public any function runAllWorkflowsByEventTrigger( required any eventName, required any entity, required struct eventData={} ) {
		// Pull the workflowTriggerEventsArray out of cache so that it is quick and can be checked to see if we need to trigger an event
		var allWorkflowTriggerEventsArray = getHibachiCacheService().getOrCacheFunctionValue("workflowDAO_getWorkflowTriggerEventsArray", getWorkflowDAO(), "getWorkflowTriggerEventsArray");
		
		// Make sure that this event has workflows attached before creating a thread
		if(arrayFind(allWorkflowTriggerEventsArray, arguments.eventName)) {
			
			// Run all workflows inside of a thread
			//thread action="run" name="#createUUID()#" application="#application#" eventName="#arguments.eventName#" entity="#arguments.entity#" {

				var workflowTriggers = getWorkflowDAO().getWorkflowTriggersForEvent(eventName = arguments.eventName);

				for (var workflowTrigger in workflowTriggers) {

					if(workflowTrigger.getStartDateTime() > now() || (!isNull(workflowTrigger.getEndDateTime()) && workflowTrigger.getEndDateTime() < now())){
						continue;
					}

					if(workflowTrigger.getSaveTriggerHistoryFlag() == true) {

						// Create a new workflowTriggerHistory to be logged
						var workflowTriggerHistory = this.newWorkflowTriggerHistory();

						//Attach workflowTrigger to workflowTriggerHistory
						workflowTriggerHistory.setWorkflowTrigger(workflowTrigger);
						workflowTriggerHistory.setStartTime(now());
						
					}

					try {
						var processData = {};

						// If the triggerObject is the same as this event, then we just use it
						if (isNull(workflowTrigger.getObjectPropertyIdentifier()) || !len(workflowTrigger.getObjectPropertyIdentifier()) || workflowTrigger.getObjectPropertyIdentifier() == arguments.entity.getClassName()) {

							processData.entity = arguments.entity;

						} else {
							processData.entity = arguments.entity.getValueByPropertyIdentifier(workflowTrigger.getObjectPropertyIdentifier());

						}

						// As long as the processEntity was found, then we can process the workflow
						if (structKeyExists(processData, "entity") && !isNull(processData.entity) && isObject(processData.entity) && processData.entity.getClassName() == workflowTrigger.getWorkflow().getWorkflowObject()) {
							processData.workflowTrigger = workflowTrigger;

							this.processWorkflow(workflowTrigger.getWorkflow(), processData, 'execute');
						}
						if (!isNull(workflowTriggerHistory)) {
							// Update the workflowTriggerHistory
							workflowTriggerHistory.setSuccessFlag(true);
							workflowTriggerHistory.setResponse("");
						}
					} catch (any e){
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
				}
			//}
		}
		
	}

	public void function runWorkflowTriggerById(required string workflowTriggerID){
		var	workflowTrigger = runWorkflowsByScheduleTrigger(getHibachiScope().getEntity('WorkflowTrigger', arguments.workflowTriggerID));
		if(!isNull(workflowTrigger.getWorkflowTriggerException())){
			throw(workflowTrigger.getWorkflowTriggerException());
		}
	}

	public any function runAllWorkflowsByScheduleTrigger() {
		var workflowTriggers = getWorkflowDAO().getDueWorkflows();
		for(var workflowTrigger in workflowTriggers) {
			runWorkflowsByScheduleTrigger(workflowTrigger);
		}
	}

	public any function runWorkflowsByScheduleTrigger(required any workflowTrigger) {

		//Change WorkflowTrigger runningFlag to TRUE
		getWorkflowDAO().updateWorkflowTriggerRunning(workflowTriggerID=arguments.workflowTrigger.getWorkflowTriggerID(), runningFlag=true);

		if(workflowTrigger.getSaveTriggerHistoryFlag() == true){
			// Create a new workflowTriggerHistory to be logged
			var workflowTriggerHistory = this.newWorkflowTriggerHistory();
			//Attach workflowTrigger to workflowTriggerHistory
			workflowTriggerHistory.setWorkflowTrigger(arguments.workflowTrigger);
			workflowTriggerHistory.setStartTime(now());

			// Persist the info to the DB
			workflowTriggerHistory = this.saveWorkflowTriggerHistory(workflowTriggerHistory);
			getHibachiDAO().flushORMSession();
		}



		try{

			//get workflowTriggers Object
			var currentObjectName = arguments.workflowTrigger.getScheduleCollection().getCollectionObject();
			//execute Collection and return only the IDs
			var triggerCollectionResult = arguments.workflowTrigger.getScheduleCollection().getPrimaryIDs();

			//Loop Collection Data
			for(var i=1; i <= ArrayLen(triggerCollectionResult); i++){
				//get current ObjectID
				var workflowTriggerID = arguments.workflowTrigger.getWorkflowTriggerID();
				var currentObjectID = triggerCollectionResult[i][structKeyArray(triggerCollectionResult[i])[1]];
				var currentThreadName = "thread_#right(workflowTriggerID, 6)&i#";

				thread action="run" name="#currentThreadName#" currentObjectName="#currentObjectName#" currentObjectID="#currentObjectID#" workflowTriggerID="#workflowTriggerID#"{
					//load Objects by id

					var workflowTrigger = getHibachiScope().getEntity('WorkflowTrigger', workflowTriggerID);
					var processData = {
						entity = getHibachiScope().getEntity(currentObjectName, currentObjectID),
						workflowTrigger = workflowTrigger
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
					throw(evaluate(currentThreadName).error.message);
					break;
				}
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

		//Change WorkflowTrigger runningFlag to FALSE
		getWorkflowDAO().updateWorkflowTriggerRunning(workflowTriggerID=arguments.workflowTrigger.getWorkflowTriggerID(), runningFlag=false);

		if(!isNull(workflowTriggerHistory)) {
			// Set the end for history
			workflowTriggerHistory.setEndTime(now());
			// Persist the info to the DB
			workflowTriggerHistory = this.saveWorkflowTriggerHistory(workflowTriggerHistory);
		}

		// Update the taskSechedules nextRunDateTime
		workflowTrigger.setNextRunDateTime( arguments.workflowTrigger.getSchedule().getNextRunDateTime(arguments.workflowTrigger.getStartDateTime(), arguments.workflowTrigger.getEndDateTime() ) );

		this.saveWorkflowTrigger(workflowTrigger);


		// Flush the DB again to persist all updates
		getHibachiDAO().flushORMSession();
		return workflowTrigger;
	}

	private boolean function executeTaskAction(required any workflowTaskAction, required any entity, required string type){
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
				var entityService = getServiceByEntityName( entityName=arguments.entity.getClassName());
				var processMethod = entityService.invokeMethod(workflowTaskAction.getProcessMethod(), {'1'=arguments.entity});
				if(!processMethod.hasErrors()) {
					actionSuccess = true;
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
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processWorkflow_execute(required any workflow, required struct data) {
		// Loop over all of the tasks for this workflow

		for(var workflowTask in arguments.workflow.getWorkflowTasks()) {
			// Check to see if the task is active and the entity object passes the conditions validation
			if(workflowTask.getActiveFlag() && workflowTask.getWorkflow().getActiveFlag() && entityPassesAllWorkflowTaskConditions(arguments.data.entity, workflowTask.getTaskConditionsConfigStruct())) {
				// Now loop over all of the actions that can now be run that the workflow task condition has passes
				for(var workflowTaskAction in workflowTask.getWorkflowTaskActions()) {

					if(!isnull(workflowTaskAction.getUpdateData())){
						if(!isnull(workflowTaskAction.getActionType())){
							if(data.workflowTrigger.getTriggerType() == 'Event'){
								arguments.data.entity.setAnnounceEvent(false);
							}
							//Execute ACTION
							executeTaskAction(workflowTaskAction, arguments.data.entity, data.workflowTrigger.getTriggerType());

							if(data.workflowTrigger.getTriggerType() == 'Event') {
								arguments.data.entity.setAnnounceEvent(true);
							}
						}
						
        			}
        			
				}
				
			}
			
		}
		return arguments.data.entity;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveWorkflowTrigger(required any entity, struct data={}) {

		// Call the default save logic
		arguments.entity = super.save(argumentcollection=arguments);

		//Check if is a Schedule Trigger
		if(structKeyExists(arguments.data, "schedule")){
		// Update the nextRunDateTime
			arguments.entity.setNextRunDateTime( entity.getSchedule().getNextRunDateTime(entity.getStartDateTime(), entity.getEndDateTime()) );
		}
		
		// If there aren't any errors then flush, and clear cache
		if(!getHibachiScope().getORMHasErrors()) {
			
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
					workflowCondition.propertyIdentifier = Replace(workflowCondition.propertyIdentifier, '_','.', 'ALL');
					workflowConditionGroupString &= " #logicalOperator# #getHibachiValidationService().invokeMethod('validate_#comparisonOperator#',{1=arguments.entity, 2=listRest(workflowCondition.propertyIdentifier,'.'), 3=workflowCondition.value})# " ;	
				}
			}
				
		}
		
		return workflowConditionGroupString;
	}
	
	
	private string function getComparisonOperator(required string comparisonOperator)
	{
		switch(arguments.comparisonOperator){
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
