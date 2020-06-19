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
component extends="HibachiService" output="false" accessors="true"{

	property name="emailService" type="any";
	property name="subscriptionService" type="any";
	property name="skuService" type="any";
	
	property name="taskDAO" type="any";
	
	// ===================== START: Logical Methods ===========================
	
	public void function updateEntityCalculatedProperties(required any entityName, struct smartListData={}) {
		
		// Setup a smart list to figure out how many things to update
		var smartList = getServiceByEntityName( arguments.entityName ).invokeMethod( "get#arguments.entityName#SmartList", {1=arguments.smartListData});
		
		// log the job started
		logHibachi("updateEntityCalculatedProperties starting for #arguments.entityName# with #smartList.getRecordsCount()# records");
		
		// create a local variable for the totalPages
		var totalPages = smartList.getTotalPages();
		
		for(var p=1; p <= totalPages; p++) {
			
			// Log to hibachi the current page
			logHibachi("updateEntityCalculatedProperties starting page: #p#");
			
			// Clear the session, so that it doesn't hog primary cache
			ormClearSession();
			
			// Set the correct page
			smartList.setCurrentPageDeclaration( p );
			
			// Get the records for this page, make sure to pass true so that the old records get cleared out
			var records = smartList.getPageRecords( true );
			
			// Figure out the recordCount we need to loop to
			var rc = arrayLen(records);
			
			// Loop over each record in the page and call update / flush
			for(var r=1; r<=rc; r++) {
				records[r].updateCalculatedProperties();
				ormFlush();
			}
		}
		
		// log the job finished
		logHibachi("updateEntityCalculatedProperties starting for #arguments.entityName# finished");
		
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	public any function processTask_runTask(required any task, required struct data) {
		
		// Create variable for the thread to run as
		var taskThread = "";
		
		// Setup the taskData that will be passed into the thread
		var threadData = {};
		threadData.taskID = arguments.task.getTaskID();
		threadData.taskData = {};
		
		// If there was a schedule, pass that in as well
		if(structKeyExists(arguments.data, "taskScheduleID")) {
			threadData.taskScheduleID = arguments.data.taskScheduleID;
		}
		
		// If there was a runTaskConfig then pass that in, otherwise we try to pull it out of the task object
		if(structKeyExists(arguments.data, "runTaskConfig") && isStruct(arguments.data.runTaskConfig)) {
			threadData.taskData = arguments.data.runTaskConfig;
		} else if (!isNull(arguments.task.getTaskConfig()) && isJSON(arguments.task.getTaskConfig())) {
			threadData.taskData = deserializeJSON(arguments.task.getTaskConfig());
		}
		
		thread action="run" name="taskThread-#createUUID()#" threadData="#threadData#" {
			
			// Create a new taskHistory to be logged
			var taskHistory = this.newTaskHistory();
			
			// Get the task from the DB
			var task = this.getTask(attributes.threadData.taskID);
			// Setup the task as running
			getTaskDAO().updateTaskRunning( taskID=attributes.threadData.taskID, runningFlag=true );
			
			// Initiate the taskHistory data
			taskHistory.setTask( task );
			taskHistory.setStartTime( now() );

			// Persist the info to the DB
			taskHistory = this.saveTaskHistory( taskHistory );
			getHibachiDAO().flushORMSession();
			
			// Run the task inside of a try/catch so that errors are logged
			try{
				
				// Call the processMethod for this task
				task = this.processTask( task, attributes.threadData.taskData, task.getTaskMethod() );
				
				// Update the taskHistory
				taskHistory.setSuccessFlag( true );
				taskHistory.setResponse( "" );
				
				// Log the error
				logHibachi( "The task '#task.getTaskName()#' was run successfully." );
				
			} catch(any e){
				
				// Log the error
				logHibachi( "There was an error processing task: #task.getTaskName()#" );
				logHibachiException( e );
				
				// Update the history
				taskHistory.setSuccessFlag( false );
				taskHistory.setResponse( e.Message );
			}
			
			// Set the task as no longer running
			getTaskDAO().updateTaskRunning( taskID=attributes.threadData.taskID, runningFlag=false );
			
			// Set the end for history
			taskHistory.setEndTime( now() );
			
			// Persist the info to the DB
			taskHistory = this.saveTaskHistory( taskHistory );
			getHibachiDAO().flushORMSession();
			
			// If there was a taskSchedule, then we can update it
			if(structKeyExists(attributes.threadData, "taskScheduleID")){
				
				// Get the taskSchedule
				var taskSchedule = this.getTaskSchedule( attributes.threadData.taskScheduleID );
				
				// Update the taskSechedules nextRunDateTime
				taskSchedule.setNextRunDateTime( taskSchedule.getSchedule().getNextRunDateTime( taskSchedule.getStartDateTime(), taskSchedule.getEndDateTime() ) );
			}
			
			// Call save on the task history
			taskHistory = this.saveTaskHistory( taskHistory );

			// Create success or failure email, and also log results
			if(taskHistory.getSuccessFlag()) {
				getEmailService().generateAndSendFromEntityAndEmailTemplateID(entity=task,emailTemplateID=task.setting('taskSuccessEmailTemplate'));
			} else {
				getEmailService().generateAndSendFromEntityAndEmailTemplateID(entity=task,emailTemplateID=task.setting('taskFailureEmailTemplate'));
			}
			
			// Send out any emails in the queue
			getEmailService().sendEmailQueue();
			
			// Flush the DB again to persist all updates
			getHibachiDAO().flushORMSession();
		}
		
		return arguments.task;
	}
	
	public any function processTask_customURL(required any task, required any processObject) {
		return arguments.task;
	}
	
	public any function processTask_subscriptionUsageRenew(required any task) {
		var subscriptionUsages = getSubscriptionService().getSubscriptionUsageForRenewal();
		
		var data = {
			autoUpdateFlag = true
		};
		
		for(var subscriptionUsage in subscriptionUsages) {
			if(!isnull(subscriptionUsage.getAutoRenewFlag()) && subscriptionUsage.getAutoRenewFlag()){
				subscriptionUsage = getService("subscriptionService").processSubscriptionUsage(subscriptionUsage, data, 'renew');
			}else{
				subscriptionUsage = getService("subscriptionService").processSubscriptionUsage(subscriptionUsage, {}, 'updateStatus');
			}
			
		}
		
		return arguments.task;
	}
	
	public any function processTask_subscriptionUsageRenewalReminder(required any task) {
		var subscriptionUsages = getSubscriptionService().getSubscriptionUsageForRenewalReminder();
		
		for(var subscriptionUsage in subscriptionUsages) {
			subscriptionUsage = getService("subscriptionService").processSubscriptionUsage(subscriptionUsage, {}, 'sendRenewalReminder');
		}
		
		return arguments.task;
	}
	
	public any function processTask_updateCalculatedProperties(required any task, required any processObject) {
		
		var setupData = {};
		
		// Order
		if(arguments.processObject.getUpdateOrderFlag()) {
			setupData = {};
			setupData["p:show"] = 200;
			updateEntityCalculatedProperties("Order", setupData);
		}
		
		// Stock / Sku / Product
		if(arguments.processObject.getUpdateStockSkuProductFlag()) {
			setupData = {};
			setupData["p:show"] = 200;
			setupData["f:sku.activeFlag"] = 1;
			setupData["f:sku.product.activeFlag"] = 1;
			updateEntityCalculatedProperties("Stock", setupData);
		}
		
		return arguments.task;
	}
	
	// @hint Moves expired waitlisted registrants to end of waitlist and changes status of next in line to 'pending confirmation'
	public any function processTask_updateEventWaitlists(required any task) {
		var smartlist = getService("SkuService").getFutureWaitlistEventsSmartlist();
		if(arraylen(smartlist.getRecords())) {
			for(var event in smartlist.getRecords()) {
				getService("SkuService").processSku(event, {}, 'notifyWaitlistOpenings');
			}
		}
		
		return arguments.task;
	}
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveTask(required any task, struct data={}, string context="save") {
		
		// Call the generic save method
		arguments.task = save(arguments.task, arguments.data, arguments.context);
		
		// If this task has a taskMethod and that taskMethod has a processObject then we need to validate and persist the data
		if(!isNull(arguments.task.getTaskMethod()) && arguments.task.hasProcessObject(arguments.task.getTaskMethod())) {
			
			
			// Get the correct processObject
			var processObject = arguments.task.getProcessObject( arguments.task.getTaskMethod() );
			
			// If there was a task config then we can populate with that first
			if(structKeyExists(arguments.data, "taskConfig") && isStruct(arguments.data.taskConfig)) {
				
				// Populate the processObject with a taskConfig
				processObject.populate(arguments.data.taskConfig);
				
				// Update the value we are going to save with this info.
				arguments.task.setTaskConfig( serializeJSON( arguments.data.taskConfig ) );
				
			}
			
			// Validate that this taskConfig will work
			processObject.validate( context=arguments.task.getTaskMethod() );
			
			// If the processObject has errors after validation, then setORMHasErrors() and add error to entity
			if(processObject.hasErrors()) {
				
				getHibachiScope().setORMHasErrors( true );
				arguments.task.addError( 'taskConfig', rbKey('entity.task.taskConfig.invalidConfig') );
				
			}
		}
		
		return arguments.task;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	public any function getTask( required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
		
		// Call the generic get method
		var task = get(entityName="SlatwallTask", idOrFilter=arguments.idOrFilter, isReturnNewOnNotFound=isReturnNewOnNotFound);
		
		// If this task has a taskMethod and that taskMethod has a processObject then we need to validate and persist the data
		if(!isNull(task.getTaskMethod()) && task.hasProcessObject(task.getTaskMethod()) && !isNull(task.getTaskConfig()) && isJSON(task.getTaskConfig())) {
			
			// Get the correct processObject
			var processObject = task.getProcessObject( task.getTaskMethod() );
			
			// Populate the processObject with a taskConfig
			processObject.populate( deserializeJSON(task.getTaskConfig()) );
			
		}
		
		return task;
	}
	
	// ======================  END: Get Overrides =============================
	
}
