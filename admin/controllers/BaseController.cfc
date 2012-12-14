/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component persistent="false" accessors="true" output="false" extends="Slatwall.com.utility.BaseObject" {
	
	property name="fw" type="any";
	property name="emailService" type="any";
	property name="integrationService" type="any";
	property name="sessionService" type="any";
	property name="utilityORMService" type="any";
	property name="accountService" type="any";
	property name="permissionService" type="any";
	property name="commentService" type="any";
	
	public any function init(required any fw) {
		setFW(arguments.fw);
		
		return super.init();
	}
	
	public void function subSystemBefore(required struct rc) {
		param name="arguments.rc.modal" default="false";
		param name="arguments.rc.edit" default="false";
		
		// Check to see if any message keys were passed via the URL
		if(structKeyExists(arguments.rc, "messageKeys")) {
			var messageKeys = listToArray(arguments.rc.messageKeys);
			for(var i=1; i<=arrayLen(messageKeys); i++) {
				showMessageKey(messageKeys[i]);
			}
		}
		
		// Make sure the current user has access to this action
		if(!secureDisplay(arguments.rc.slatAction, getSlatwallScope().getCurrentAccount())) {
			getFW().redirect('main.noaccess');
		}
		
		var subsystemName = getFW().getSubsystem(arguments.rc.slatAction);
		var sectionName = getFW().getSection(arguments.rc.slatAction);
		var itemName = getFW().getItem(arguments.rc.slatAction);
		
		arguments.rc.itemEntityName = "";
		arguments.rc.listAction = arguments.rc.slatAction;
		arguments.rc.saveAction = arguments.rc.slatAction;
		arguments.rc.detailAction = arguments.rc.slatAction;
		arguments.rc.deleteAction = arguments.rc.slatAction;
		arguments.rc.editAction = arguments.rc.slatAction;
		arguments.rc.createAction = arguments.rc.slatAction;
		arguments.rc.cancelAction = arguments.rc.slatAction;
		arguments.rc.exportAction = arguments.rc.slatAction;
		
		if(left(itemName, 4) == "list") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-4);
		} else if (left(itemName, 4) == "edit") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-4);
		} else if (left(itemName, 4) == "save") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-4);
		} else if (left(itemName, 6) == "detail") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-6);
		} else if (left(itemName, 6) == "delete") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-6);
		} else if (left(itemName, 6) == "create") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-6);
		} else if (left(itemName, 7) == "process") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-7);
		} else if (left(itemName, 6) == "export") {
			arguments.rc.itemEntityName = right(itemName, len(itemName)-6);
		}
		
		if(arguments.rc.itemEntityName != "") {
			arguments.rc.listAction = "#subsystemName#:#sectionName#.list#arguments.rc.itemEntityName#"; 
			arguments.rc.saveAction = "#subsystemName#:#sectionName#.save#arguments.rc.itemEntityName#";
			arguments.rc.detailAction = "#subsystemName#:#sectionName#.detail#arguments.rc.itemEntityName#";		
			arguments.rc.deleteAction = "#subsystemName#:#sectionName#.delete#arguments.rc.itemEntityName#";
			arguments.rc.editAction = "#subsystemName#:#sectionName#.edit#arguments.rc.itemEntityName#";
			arguments.rc.createAction = "#subsystemName#:#sectionName#.create#arguments.rc.itemEntityName#";
			arguments.rc.cancelAction = "#subsystemName#:#sectionName#.list#arguments.rc.itemEntityName#";
			arguments.rc.exportAction = "#subsystemName#:#sectionName#.export#arguments.rc.itemEntityName#"; 
		}
		
		arguments.rc.pageTitle = rbKey(replace(arguments.rc.slatAction,':','.','all'));
		if(right(arguments.rc.pageTitle, 8) eq "_missing") {
			if(left(listLast(arguments.rc.slatAction, "."), 4) eq "list") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.list'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));
			} else if (left(listLast(arguments.rc.slatAction, "."), 4) eq "edit") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.edit'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));
			} else if (left(listLast(arguments.rc.slatAction, "."), 6) eq "create") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.create'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));
			} else if (left(listLast(arguments.rc.slatAction, "."), 6) eq "detail") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.detail'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));
			} else if (left(listLast(arguments.rc.slatAction, "."), 7) eq "process") {
				arguments.rc.pageTitle = replace(rbKey('admin.define.process'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));
			}
		}
		
		// Place the framework in the rc
		arguments.rc.fw = getFW();
	}
	
	// Implicit onMissingMethod() to handle standard CRUD
	public void function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		if(structKeyExists(arguments, "missingMethodName")) {
			if( left(arguments.missingMethodName, 4) == "list" ) {
				genericListMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "edit" ) {
				genericEditMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "save" ) {
				genericSaveMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "detail" ) {
				genericDetailMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "delete" ) {
				genericDeleteMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "create" ) {
				genericCreateMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 7) == "process" ) {
				genericProcessMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "export" ) {
				genericExportMethod(entityName=arguments.missingMethodArguments.rc.itemEntityName, rc=arguments.missingMethodArguments.rc);
			}	
		}
	}
	
	public void function genericListMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		var httpRequestData = getHTTPRequestData();
		
		var savedStateKey = lcase( arguments.rc.slatAction );

		/*
		Commenting back out because this now works, but we need to have display in the admin to show that filter(s) have been applied
		if(getSessionService().hasValue( savedStateKey )) {
			rc.savedStateID = getSessionService().getValue( savedStateKey );
		}
		*/
		
		arguments.rc["#arguments.entityName#smartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=arguments.rc} );
		
		getSessionService().setValue( savedStateKey, arguments.rc["#arguments.entityName#smartList"].getSavedStateID() );
		
	}
	
	public void function genericCreateMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		arguments.rc["#arguments.entityName#"] = entityService.invokeMethod( "new#arguments.entityName#" );
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		arguments.rc.edit = true;
		getFW().setView(arguments.rc.detailAction);
	}
	
	public void function genericEditMethod(required string entityName, required struct rc) {
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		if(!structKeyExists(arguments.rc,arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getFW().redirect(arguments.rc.listAction);
		}
		
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		
		arguments.rc.edit = true;
		getFW().setView(arguments.rc.detailAction);
	}
	
	public void function genericDetailMethod(required string entityName, required struct rc) {
		
		loadEntitiesFromRCIDs( arguments.rc );
		
		if(!structKeyExists(arguments.rc,arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getFW().redirect(arguments.rc.listAction);
		}
		
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		
		arguments.rc.edit = false;
	}
	
	public void function genericDeleteMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#arguments.rc.itemEntityName#", {1=arguments.rc[ entityPrimaryID ]} );
		
		if(isNull(entity)) {
			getFW().redirect(action=arguments.rc.listAction, querystring="messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_error");
		}
		
		var deleteOK = entityService.invokeMethod("delete#arguments.entityName#", {1=entity});
		
		if (deleteOK) {
			if(structKeyExists(arguments.rc, "returnAction") && arguments.rc.returnAction != "") {
				redirectToReturnAction( "messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_success" );
			} else {
				getFW().redirect(action=arguments.rc.listAction, querystring="messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_success");	
			}
		}
		
		getFW().redirect(action=arguments.rc.listAction, querystring="messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_error");
	}
	
	
	public void function genericSaveMethod(required string entityName, required struct rc) {
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc[ entityPrimaryID ], 2=true} );
		arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=entity, 2=arguments.rc} );
		
		// If OK, then check for processOptions
		if(!arguments.rc[ arguments.entityName ].hasErrors() && structKeyExists(arguments.rc, "process") && isBoolean(arguments.rc.process) && arguments.rc.process) {
			param name="arguments.rc.processOptions" default="#structNew()#";
			param name="arguments.rc.processContext" default="process";
			
			processData = arguments.rc;
			structAppend(processData, arguments.rc.processOptions, false);
			
			arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "process#arguments.entityName#", {1=arguments.rc[ arguments.entityName ], 2=processData, 3=arguments.rc.processContext} );
			
			if(arguments.rc[ arguments.entityName ].hasErrors()) {
				// Add the error message to the top of the page
				entity.showErrorMessages();	
			}
		}
		
		// If still OK then check what to do next
		if(!arguments.rc[ arguments.entityName ].hasErrors()) {
			
			if(structKeyExists(arguments.rc, "returnAction")) {
				redirectToReturnAction( "messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_success&#entityPrimaryID#=#arguments.rc[ arguments.entityName ].getPrimaryIDValue()#" );
			} else {
				getFW().redirect(action=arguments.rc.detailAction, querystring="#entityPrimaryID#=#arguments.rc[ arguments.entityName ].getPrimaryIDValue()#&messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_success");	
			}
			
		// If Errors
		} else {
			
			arguments.rc.edit = true;
			getFW().setView(action=arguments.rc.detailAction);
			showMessageKey("#replace(arguments.rc.slatAction, ':', '.', 'all')#_error");
			
			for( var p in arguments.rc[ arguments.entityName ].getErrors() ) {
				local.thisErrorArray = arguments.rc[ arguments.entityName ].getErrors()[p];
				for(var i=1; i<=arrayLen(local.thisErrorArray); i++) {
					showMessage(local.thisErrorArray[i], "error");
				}
			}
			
			if(arguments.rc[ arguments.entityName ].isNew()) {
				arguments.rc.slatAction = arguments.rc.createAction;
				arguments.rc.pageTitle = replace(rbKey('admin.define.create'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));	
			} else {
				arguments.rc.slatAction = arguments.rc.editAction;
				arguments.rc.pageTitle = replace(rbKey('admin.define.edit'), "${itemEntityName}", rbKey('entity.#arguments.rc.itemEntityName#'));	
			}
			
			arguments.rc.edit = true;
			loadEntitiesFromRCIDs( arguments.rc );
		}
	}
	
	public void function genericProcessMethod(required string entityName, required struct rc) {
		param name="arguments.rc.edit" default="false";
		param name="arguments.rc.processContext" default="process";
		param name="arguments.rc.multiProcess" default="false";
		param name="arguments.rc.processOptions" default="#{}#";
		param name="arguments.rc.additionalData" default="#{}#";
		
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		var entityPrimaryID = getUtilityORMService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		getFW().setLayout( "admin:process.default" );
		
		if(len(arguments.rc.processContext) && arguments.rc.processContext != "process") {
			arguments.rc.pageTitle = rbKey( "admin.#getFW().getSection(arguments.rc.slatAction)#.process#arguments.entityName#.#arguments.rc.processContext#" );
		}
		
		// If we are actually posting the process form, then this logic gets calls the process method for each record
		if(structKeyExists(arguments.rc, "process") && arguments.rc.process) {
			arguments.rc.errorData = [];
			var errorEntities = [];
			
			// If there weren't any process records passed in, then we will make a sinlge processrecord with the entire rc
			if(!structKeyExists(arguments.rc, "processRecords") || !isArray(arguments.rc.processRecords)) {
				arguments.rc.processRecords = [arguments.rc];
			}
			
			for(var i=1; i<=arrayLen(arguments.rc.processRecords); i++) {
				
				if(structKeyExists(arguments.rc.processRecords[i], entityPrimaryID)) {
					
					structAppend(arguments.rc.processRecords[i], arguments.rc.processOptions, false);
					var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc.processRecords[i][ entityPrimaryID ], 2=true} );
					
					logSlatwall("Process Called: Enity - #arguments.entityName#, EntityID - #arguments.rc.processRecords[i][ entityPrimaryID ]#, processContext - #arguments.rc.processContext# ");
					
					entity = entityService.invokeMethod( "process#arguments.entityName#", {1=entity, 2=arguments.rc.processRecords[i], 3=arguments.rc.processContext} );
					
					// If there were errors, then add to the errored entities
					if( !isNull(entity) && entity.hasErrors() ) {
						
						// Add the error message to the top of the page
						entity.showErrorMessages();
						
						arrayAppend(errorEntities, entity);
						arrayAppend(arguments.rc.errorData, arguments.rc.processRecords[i]);
						
					// If there were not error messages then que and process emails & print options
					} else if (!isNull(entity)) {
						
						// TODO: Sending email needs to get moved out of this loop
						// We need to persist the records to db before we send out emails
						// Send out E-mails
						if(structKeyExists(arguments.rc.processOptions, "email")) {
							for(var emailEvent in arguments.rc.processOptions.email) {
								getEmailService().sendEmailByEvent(eventName="process#arguments.entityName#:#emailEvent#", entity=entity);
							}
						}
						
						// Create any process Comments
						if(structKeyExists(arguments.rc, "processComment") && isStruct(arguments.rc.processComment) && len(arguments.rc.processComment.comment)) {
							
							// Create new Comment
							var newComment = getCommentService().newComment();
							
							// Create Relationship
							var commentRelationship = {};
							commentRelationship.commentRelationshipID = "";
							commentRelationship[ arguments.entityName ] = {};
							commentRelationship[ arguments.entityName ][ entityPrimaryID ] = entity.getPrimaryIDValue();
							arguments.rc.processComment.commentRelationships = [];
							arrayAppend(arguments.rc.processComment.commentRelationships, commentRelationship);
							
							// Save new Comment 
							getCommentService().saveComment(newComment, arguments.rc.processComment);
						}
					}
				}
			}
			
			if(arrayLen(errorEntities)) {
				arguments.rc[ "process#arguments.entityName#SmartList" ] = entityService.invokeMethod( "get#arguments.entityName#SmartList" );
				arguments.rc[ "process#arguments.entityName#SmartList" ].setRecords(errorEntities);
				if(arrayLen(errorEntities) gt 1) {
					arguments.rc.multiProcess = true;
				}
			} else {
				redirectToReturnAction( "messagekeys=#replace(arguments.rc.slatAction, ':', '.', 'all')#_success" );
			}
			
		
		// IF we are just doing the process setup page, run this logic
		} else {
			
			// Go get the correct type of SmartList
			arguments.rc[ "process#arguments.entityName#SmartList" ] = entityService.invokeMethod( "get#arguments.entityName#SmartList" );
			
			// If no ID was passed in create a smartList with only 1 new entity in it
			if(!structKeyExists(arguments.rc, entityPrimaryID) || arguments.rc[entityPrimaryID] == "") {
				var newEntity = entityService.invokeMethod( "new#arguments.entityName#" );
				arguments.rc[ "process#arguments.entityName#SmartList" ].setRecords([newEntity]);
			} else {
				arguments.rc[ "process#arguments.entityName#SmartList" ].addInFilter(entityPrimaryID, arguments.rc[entityPrimaryID]);	
			}
			
			// If there are no records then redirect to the list action
			if(!arguments.rc[ "process#arguments.entityName#SmartList" ].getRecordsCount()) {
				getFW().redirect(action=arguments.rc.listaction);
			} else if (arguments.rc[ "process#arguments.entityName#SmartList" ].getRecordsCount() gt 1) {
				arguments.rc.multiProcess = true;
			}
		}
	}
	
	public void function genericExportMethod(required string entityName, required struct rc) {
		
		var entityService = getUtilityORMService().getServiceByEntityName( entityName=arguments.entityName );
		
		entityService.invokeMethod("export#arguments.entityName#");
	}
	
	private void function loadEntitiesFromRCIDs(required struct rc) {
		try{
			for(var key in arguments.rc) {
				if(!find('.',key) && right(key, 2) == "ID" && len(arguments.rc[key]) == "32") {
					var entityName = left(key, len(key)-2);
					var entityService = getUtilityORMService().getServiceByEntityName( entityName=entityName );
					var entity = entityService.invokeMethod("get#entityName#", {1=arguments.rc[key]});
					if(!isNull(entity)) {
						arguments.rc[ entityName ] = entity;
					}
				}
			}
		}catch(any e){
			writedump(e);abort;
		}
	}
	
	private void function redirectToReturnAction(string additionalQueryString="") {
		var raArray = listToArray(request.context.returnAction, chr(35));
		var qs = buildReturnActionQueryString( arguments.additionalQueryString );
		if(arrayLen(raArray) eq 2) {
			qs &= "#chr(35)##raArray[2]#";
		}
		
		getFW().redirect(action=raArray[1], querystring=qs);
	}
	
	private string function buildReturnActionQueryString(string additionalQueryString="", string ignoreKeys="") {
		var queryString = "";
		for(var key in url) {
			if(!listFindNoCase(ignoreKeys, key) && key != "returnAction" && key != "slatAction") {
				queryString = listAppend(queryString, key & "=" & url[key], "&");
			}
		}
		if(len(arguments.additionalQueryString)) {
			queryString = listAppend(queryString, arguments.additionalQueryString, "&");
		}
		return queryString;
	}
}
