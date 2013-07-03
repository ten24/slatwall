component output="false" accessors="true" extends="HibachiController" {
	
	property name="hibachiService" type="any";
	
	this.entityController = true;
	
	public void function before( required any rc ) {
		
		// Setup a Private structure in the RC that can't be overridden by the form scope
		arguments.rc.entityActionDetails = {};
		arguments.rc.entityActionDetails.thisAction = arguments.rc[ getFW().getAction() ];
		arguments.rc.entityActionDetails.subsystemName = getFW().getSubsystem( arguments.rc.entityActionDetails.thisAction );
		arguments.rc.entityActionDetails.sectionName = getFW().getSection( arguments.rc.entityActionDetails.thisAction );
		arguments.rc.entityActionDetails.itemName = getFW().getItem( arguments.rc.entityActionDetails.thisAction );
		
		// Setup EntityActionDetails with default redirect / render values
		arguments.rc.entityActionDetails.sRedirectURL = "";
		arguments.rc.entityActionDetails.sRedirectAction = "";
		arguments.rc.entityActionDetails.sRenderItem = "";
		arguments.rc.entityActionDetails.sRedirectQS = "";
		arguments.rc.entityActionDetails.fRedirectURL = "";
		arguments.rc.entityActionDetails.fRedirectAction = "";
		arguments.rc.entityActionDetails.fRenderItem = "";
		arguments.rc.entityActionDetails.fRedirectQS = "";
		
		// Setup EntityActionDetails with all next actions set to this action
		arguments.rc.entityActionDetails.itemEntityName = "";
		arguments.rc.entityActionDetails.backAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.cancelAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.createAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.deleteAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.detailAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.editAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.exportAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.listAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.multiPreProcessAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.multiProcessAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.preProcessAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.processAction = arguments.rc.entityActionDetails.thisAction;
		arguments.rc.entityActionDetails.saveAction = arguments.rc.entityActionDetails.thisAction;
		
		// Setup EntityActionDetails with the correct itemEntityName
		if(left(arguments.rc.entityActionDetails.itemName, 4) == "list") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-4);
		} else if (left(arguments.rc.entityActionDetails.itemName, 4) == "edit") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-4);
		} else if (left(arguments.rc.entityActionDetails.itemName, 4) == "save") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-4);
		} else if (left(arguments.rc.entityActionDetails.itemName, 6) == "detail") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-6);
		} else if (left(arguments.rc.entityActionDetails.itemName, 6) == "delete") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-6);
		} else if (left(arguments.rc.entityActionDetails.itemName, 6) == "create") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-6);
		} else if (left(arguments.rc.entityActionDetails.itemName, 7) == "process") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-7);
		} else if (left(arguments.rc.entityActionDetails.itemName, 10) == "preprocess") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-10);
		} else if (left(arguments.rc.entityActionDetails.itemName, 6) == "export") {
			arguments.rc.entityActionDetails.itemEntityName = right(arguments.rc.entityActionDetails.itemName, len(arguments.rc.entityActionDetails.itemName)-6);
		}
		
		// Setup EntityActionDetails with correct actions
		if(arguments.rc.entityActionDetails.itemEntityName != "") {
			arguments.rc.entityActionDetails.backAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.list#arguments.rc.entityActionDetails.itemEntityName#";
			if(left(arguments.rc.entityActionDetails.itemName, 6) == "create") {
				arguments.rc.entityActionDetails.cancelAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.list#arguments.rc.entityActionDetails.itemEntityName#";	
			} else {
				arguments.rc.entityActionDetails.cancelAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.detail#arguments.rc.entityActionDetails.itemEntityName#";
			}
			arguments.rc.entityActionDetails.createAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.create#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.detailAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.detail#arguments.rc.entityActionDetails.itemEntityName#";		
			arguments.rc.entityActionDetails.deleteAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.delete#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.editAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.edit#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.exportAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.export#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.listAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.list#arguments.rc.entityActionDetails.itemEntityName#"; 
			arguments.rc.entityActionDetails.multiPreProcessAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.multipreprocess#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.multiProcessAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.multiprocess#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.preProcessAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.preprocess#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.processAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.process#arguments.rc.entityActionDetails.itemEntityName#";
			arguments.rc.entityActionDetails.saveAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.save#arguments.rc.entityActionDetails.itemEntityName#";
		}
		
		// Setup RC with generic redirect/render info
		// redirectURL
		if(structKeyExists(arguments.rc, "redirectURL") && !structKeyExists(arguments.rc, "sRedirectURL")) {
			arguments.rc.sRedirectURL = arguments.rc.redirectURL;
		}
		if(structKeyExists(arguments.rc, "redirectURL") && !structKeyExists(arguments.rc, "fRedirectURL")) {
			arguments.rc.fRedirectURL = arguments.rc.redirectURL;
		}
		// redirectAction
		if(structKeyExists(arguments.rc, "redirectAction") && !structKeyExists(arguments.rc, "sRedirectAction")) {
			arguments.rc.sRedirectAction = arguments.rc.redirectAction;
		}
		if(structKeyExists(arguments.rc, "redirectAction") && !structKeyExists(arguments.rc, "fRedirectAction")) {
			arguments.rc.fRedirectAction = arguments.rc.redirectAction;
		}
		// renderItem
		if(structKeyExists(arguments.rc, "renderItem") && !structKeyExists(arguments.rc, "sRenderItem")) {
			arguments.rc.sRenderItem = arguments.rc.renderItem;
		}
		if(structKeyExists(arguments.rc, "renderItem") && !structKeyExists(arguments.rc, "fRenderItem")) {
			arguments.rc.fRenderItem = arguments.rc.renderItem;
		}
		// redirectQS
		if(structKeyExists(arguments.rc, "redirectQS") && !structKeyExists(arguments.rc, "sRedirectQS")) {
			arguments.rc.sRedirectQS = arguments.rc.redirectQS;
		}
		if(structKeyExists(arguments.rc, "redirectQS") && !structKeyExists(arguments.rc, "fRedirectQS")) {
			arguments.rc.fRedirectQS = arguments.rc.redirectQS;
		}
		// backAction
		if(structKeyExists(arguments.rc, "backAction")) {
			arguments.rc.entityActionDetails.backAction = arguments.rc.backAction;
		}
		
		// Setup the page Title in the RC
		arguments.rc.pageTitle = rbKey(replace(arguments.rc.entityActionDetails.thisAction,':','.','all'));
		
		if(right(arguments.rc.pageTitle, 8) eq "_missing") {
			var replaceData = {
				entityName=getHibachiScope().rbKey('entity.#arguments.rc.entityActionDetails.itemEntityName#'),
				itemEntityName=getHibachiScope().rbKey('entity.#arguments.rc.entityActionDetails.itemEntityName#')
			};
			
			if(left(listLast(arguments.rc.entityActionDetails.thisAction, "."), 4) eq "list") {
				arguments.rc.pageTitle = getHibachiScope().rbKey('admin.define.list', replaceData);
			} else if (left(listLast(arguments.rc.entityActionDetails.thisAction, "."), 4) eq "edit") {
				arguments.rc.pageTitle = getHibachiScope().rbKey('admin.define.edit', replaceData);
			} else if (left(listLast(arguments.rc.entityActionDetails.thisAction, "."), 6) eq "create") {
				arguments.rc.pageTitle = getHibachiScope().rbKey('admin.define.create', replaceData);
			} else if (left(listLast(arguments.rc.entityActionDetails.thisAction, "."), 6) eq "detail") {
				arguments.rc.pageTitle = getHibachiScope().rbKey('admin.define.detail', replaceData);
			}
		}
	}
	
	// Implicit onMissingMethod() to handle standard CRUD
	public void function onMissingMethod(string missingMethodName, struct missingMethodArguments) {
		
		if(structKeyExists(arguments, "missingMethodName")) {
			if( left(arguments.missingMethodName, 4) == "list" ) {
				genericListMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "edit" ) {
				genericEditMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 4) == "save" ) {
				genericSaveMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "detail" ) {
				genericDetailMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "delete" ) {
				genericDeleteMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "create" ) {
				genericCreateMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 7) == "process" ) {
				genericProcessMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 10) == "preprocess" ) {
				genericPreProcessMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			} else if ( left(arguments.missingMethodName, 6) == "export" ) {
				genericExportMethod(entityName=arguments.missingMethodArguments.rc.entityActionDetails.itemEntityName, rc=arguments.missingMethodArguments.rc);
			}
		}
	}
	
	// LIST
	public void function genericListMethod(required string entityName, required struct rc) {
		// Find the correct service
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		// Place the standard smartList in the rc
		arguments.rc["#arguments.entityName#SmartList"] = entityService.invokeMethod( "get#arguments.entityName#SmartList", {1=arguments.rc} );
	}
	
	// CREATE
	public void function genericCreateMethod(required string entityName, required struct rc) {
		// Check for any redirect / render values that were passed in to be used by the create form, otherwise set them to a default
		var hasSuccess = populateRenderAndRedirectSuccessValues( arguments.rc );
		if(!hasSuccess) {
			arguments.rc.entityActionDetails.sRedirectAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.detail#arguments.rc.entityActionDetails.itemEntityName#";
		}
		var hasFaliure = populateRenderAndRedirectFailureValues( arguments.rc );
		if(!hasFaliure) {
			arguments.rc.entityActionDetails.fRenderItem = "create#arguments.rc.entityActionDetails.itemEntityName#";
		}
		populateRedirectQS( arguments.rc );
		
		// Find the correct service
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		// Load the objects for any ID's that were past in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// Call the new method on that service to inject an object into the RC
		if(!structKeyExists(rc, arguments.entityName)) {
			arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "new#arguments.entityName#" );	
		}
		
		// Set the edit to true
		arguments.rc.edit = true;
	}
	
	// EDIT
	public void function genericEditMethod(required string entityName, required struct rc) {
		// Check for any redirect / render values that were passed in to be used by the create form, otherwise set them to a default
		var hasSuccess = populateRenderAndRedirectSuccessValues( arguments.rc );
		if(!hasSuccess) {
			arguments.rc.entityActionDetails.sRedirectAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.detail#arguments.rc.entityActionDetails.itemEntityName#";
		}
		var hasFaliure = populateRenderAndRedirectFailureValues( arguments.rc );
		if(!hasFaliure) {
			arguments.rc.entityActionDetails.fRenderItem = "create#arguments.rc.entityActionDetails.itemEntityName#";
		}
		populateRedirectQS( arguments.rc );
		
		// Load the objects for any ID's that were past in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// Make sure that the object we are trying to request was set in the RC
		if(!structKeyExists(arguments.rc, arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getHibachiScope().showMessage( getHibachiScope().rbKey( "#replace(arguments.rc.entityActionDetails.thisAction, ":", ".", "all")#.notfound" ) , "error");
			getFW().redirect(action=arguments.rc.entityActionDetails.listAction, preserve="messages");
		}
		
		// Check for any redirect / render values that were passed in to be used by the edit form, otherwise set them to a default
		var hasSuccess = populateRenderAndRedirectSuccessValues( arguments.rc );
		if(!hasSuccess) {
			if(structKeyExists(arguments.rc, "modal") && arguments.rc.modal) {
				arguments.rc.entityActionDetails.sRenderItem = listLast(arguments.rc.entityActionDetails.listAction,".");	
			} else {
				arguments.rc.entityActionDetails.sRenderItem = listLast(arguments.rc.entityActionDetails.detailAction,".");
			}
		}
		var hasFaliure = populateRenderAndRedirectFailureValues( arguments.rc );
		if(!hasFaliure) {
			arguments.rc.entityActionDetails.fRenderItem = listLast(arguments.rc.entityActionDetails.editAction,".");
		}
		
		// Setup the values needed for this type of layout
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		arguments.rc.edit = true;
	}
	
	// DETAIL
	public void function genericDetailMethod(required string entityName, required struct rc) {
		// Load the objects for any ID's that were past in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// Make sure that the object was actually defined
		if(!structKeyExists(arguments.rc, arguments.entityName) || !isObject(arguments.rc[arguments.entityName])){
			getHibachiScope().showMessage( getHibachiScope().rbKey( "#replace(arguments.rc.entityActionDetails.thisAction, ":", ".", "all")#.notfound" ) , "error");
			getFW().redirect(action=arguments.rc.entityActionDetails.listAction, preserve="messages");
		}
		
		// Setup the values needed for this type of layout
		arguments.rc.pageTitle = arguments.rc[arguments.entityName].getSimpleRepresentation();
		arguments.rc.edit = false;
	}
	
	// DELETE
	public void function genericDeleteMethod(required string entityName, required struct rc) {
		
		// Find the correct service and this object PrimaryID
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		// Attempt to find the entity
		var entity = entityService.invokeMethod( "get#arguments.rc.entityActionDetails.itemEntityName#", {1=arguments.rc[ entityPrimaryID ]} );
		
		// If the entity was null, then redirect to the falureAction
		if(isNull(entity)) {
			getHibachiScope().showMessage( getHibachiScope().rbKey( "#replace(arguments.rc.entityActionDetails.thisAction, ":", ".", "all")#.notfound" ) , "error");
			getFW().redirect(action=arguments.rc.entityActionDetails.listAction, preserve="messages");
		}
		
		// Check how the delete went
		var deleteOK = entityService.invokeMethod("delete#arguments.entityName#", {1=entity});
		
		// SUCCESS
		if (deleteOK) {
			// Show the Generica Action Success Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "#arguments.rc.entityActionDetails.subsystemName#.#arguments.rc.entityActionDetails.sectionName#.delete_success" ), "${itemEntityName}", rbKey('entity.#arguments.rc.entityActionDetails.itemEntityName#'), "all" ), "success");
			
			// Render or Redirect a Success
			renderOrRedirectSuccess( defaultAction=arguments.rc.entityActionDetails.listAction, maintainQueryString=true, rc=arguments.rc);
			
		// FAILURE
		} else {
				
			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();
			
			// Render or Redirect a faluire
			renderOrRedirectFailure( defaultAction=arguments.rc.entityActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);	
		}
		
	}
	
	// SAVE
	public void function genericSaveMethod(required string entityName, required struct rc) {
		
		// Find the correct service and this object PrimaryID
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		// Attempt to find the entity
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc[ entityPrimaryID ], 2=true} );
		
		// Call the save method on the entity, and then populate it back into the RC
		arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "save#arguments.entityName#", {1=entity, 2=arguments.rc} );
		
		// If the entity was saved OK, then check for process=1 and a processContext in the RC
		if(!arguments.rc[ arguments.entityName ].hasErrors() && structKeyExists(arguments.rc, "process") && isBoolean(arguments.rc.process) && arguments.rc.process && structKeyExists(arguments.rc, "processContext")) {
			arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "process#arguments.entityName#", {1=arguments.rc[ arguments.entityName ], 2=arguments.rc, 3=arguments.rc.processContext} );
		}
		
		// SUCCESS
		if(!arguments.rc[ arguments.entityName ].hasErrors()) {
			// Show the Generica Action Success Message
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "#arguments.rc.entityActionDetails.subsystemName#.#arguments.rc.entityActionDetails.sectionName#.save_success" ), "${itemEntityName}", rbKey('entity.#arguments.rc.entityActionDetails.itemEntityName#'), "all" ) , "success");
			
			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();
			
			// If this is an ajax request then setup the response
			if(arguments.rc.ajaxRequest) {
			
				// Let AJAX know that this was a success
				arguments.rc.ajaxResponse["success"] = true;
				arguments.rc.ajaxResponse[ entity.getPrimaryIDPropertyName() ] = entity.getPrimaryIDValue();
			
			// Otherwise do the standard render / redirect
			} else {
				
				// Place the id in the URL for redirects in case this was a new entity before
				url[ entity.getPrimaryIDPropertyName() ] = entity.getPrimaryIDValue();
				
				// Render or Redirect a Success
				renderOrRedirectSuccess( defaultAction=arguments.rc.entityActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);	
			}
			
			
		// FAILURE
		} else {
			
			// Show all of the specific messages & error messages for the entity
			entity.showErrorsAndMessages();
			
			// If this is an ajax request then setup the response
			if(arguments.rc.ajaxRequest) {
				
				// Let AJAX know that this was a failure
				arguments.rc.ajaxResponse["success"] = false;
				
				// Place the entities errors in the response
				arguments.rc.ajaxResponse["entityErrors"] = entity.getErrors();
			
			// Otherwise do the standard render/redirect
			} else {
				
				// Place the id in the URL for redirects in case this was a new entity before
				url[ entity.getPrimaryIDPropertyName() ] = entity.getPrimaryIDValue();
				
				// Render or Redirect a faluire
				renderOrRedirectFailure( defaultAction="edit#arguments.rc.entityActionDetails.itemEntityName#", maintainQueryString=true, rc=arguments.rc);
			}
		}
	}
	
	// PRE-PROCESS
	public void function genericPreProcessMethod(required string entityName, required struct rc) {
		// Check for any redirect / render values that were passed in to be used by the create form, otherwise set them to a default
		var hasSuccess = populateRenderAndRedirectSuccessValues( arguments.rc );
		if(!hasSuccess) {
			arguments.rc.entityActionDetails.sRedirectAction = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.detail#arguments.rc.entityActionDetails.itemEntityName#";
		}
		var hasFaliure = populateRenderAndRedirectFailureValues( arguments.rc );
		if(!hasFaliure) {
			arguments.rc.entityActionDetails.fRenderItem = "preprocess#arguments.rc.entityActionDetails.itemEntityName#";
		}
		populateRedirectQS( arguments.rc );
		
		// Load up any ID's that were passed in
		loadEntitiesFromRCIDs( arguments.rc );
		
		// If the entityName object is now not in the rc because there was no ID, then we need to place a new one in the rc
		if(!structKeyExists(rc, arguments.entityName) || !isObject(rc[ arguments.entityName ]) || lcase(rc[ arguments.entityName ].getClassName()) != lcase(arguments.entityName)) {
			
			var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
			rc[ arguments.entityName ] = entityService.invokeMethod("new#arguments.entityName#");
		}
		
		// Check to see if there is a process object
		var processObjectExists = rc[ arguments.entityName ].hasProcessObject( arguments.rc.processContext );
		
		if(processObjectExists) {
			// Setup the processObject in the RC so that we can use it for our form
			rc.processObject = arguments.rc[ arguments.entityName ].getProcessObject( arguments.rc.processContext );
		
			// Populate the processObject with any data that might have come into the RC
			if(!rc.processObject.getPopulatedFlag()) {
				rc.processObject.populate( rc );
				rc.processObject.setPopulatedFlag( true );	
			}
		}
		
		// Set rc.edit to true because all property displays should be taking inputs
		rc.edit = true;
		
		// Set the page title to the correct rbKey
		rc.pageTitle = rbKey( "entity.#arguments.rc.entityActionDetails.itemEntityName#.process.#rc.processContext#" );
		
		// Set the view correctly to use the context specific preProcess view
		getFW().setView("#lcase(arguments.rc.entityActionDetails.subsystemName)#:#lcase(arguments.rc.entityActionDetails.sectionName)#.#lcase(arguments.rc.entityActionDetails.itemName)#_#lcase(arguments.rc.processContext)#");
	}
	
	// PROCESS
	public void function genericProcessMethod(required string entityName, required struct rc) {
		
		// Find the correct service and this object PrimaryID
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var entityPrimaryID = getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName=arguments.entityName );
		
		// Attempt to find the entity
		var entity = entityService.invokeMethod( "get#arguments.entityName#", {1=arguments.rc[ entityPrimaryID ], 2=true} );
		
		var requirePreProcess = false;
		var processObjectExists = entity.hasProcessObject( arguments.rc.processContext );
		
		// Check to see if this is an AJAX Request, and there is a pre-process object... then call preprocess first
		if( arguments.rc.ajaxRequest && processObjectExists ) {
			// Setup the processObject in the RC so that we can use it for our form if needed
			rc.processObject = entity.getProcessObject( arguments.rc.processContext );
			
			// Populate the processObject
			rc.processObject.populate(arguments.rc);
			
			// hibachiValidationService
			var errorBean = getService("hibachiValidationService").validate(arguments.rc.processObject, arguments.rc.processContext, false);
			
			// If there were error then we know that this will require a preprocess first
			if(errorBean.hasErrors()) {
				// Tell Hibachi not to flush the ORM Session
				getHibachiScope().setORMHasErrors(true);
				
				// Place the entity in the RC
				arguments.rc[ arguments.entityName ] = entity;
				
				// Make sure that we indicate modal for the view to render correctly
				arguments.rc.modal = true;
				
				// Set edit to true
				arguments.rc.edit = true;
				
				// Set the page title to the correct rbKey
				rc.pageTitle = rbKey( "entity.#arguments.rc.entityActionDetails.itemEntityName#.process.#rc.processContext#" );
				
				// Load up any ID's that were passed in
				loadEntitiesFromRCIDs( arguments.rc );
				
				// Check for any redirect / render values that were passed in to be used by the create form, otherwise set them to a default
				var hasSuccess = populateRenderAndRedirectSuccessValues( arguments.rc );
				if(!hasSuccess) {
					arguments.rc.entityActionDetails.sRenderItem = "detail#arguments.rc.entityActionDetails.itemEntityName#";
				}
				var hasFaliure = populateRenderAndRedirectFailureValues( arguments.rc );
				if(!hasFaliure) {
					arguments.rc.entityActionDetails.fRenderItem = "preprocess#arguments.rc.entityActionDetails.itemEntityName#";
				}
				populateRedirectQS( arguments.rc );
				
				// Setup the response
				arguments.rc.ajaxResponse["preProcessView"] = getFW().view( "#replace(arguments.rc.entityActionDetails.preProcessAction,'.','/')#_#arguments.rc.processContext#" );
				
				// Setup the errorBean errors in the response
				arguments.rc.ajaxResponse["processObjectErrors"] = errorBean.getErrors();
			}
		}
		
		if(!requirePreProcess) {
		
			// Call the process method on the entity, and then populate it back into the RC
			arguments.rc[ arguments.entityName ] = entityService.invokeMethod( "process#arguments.entityName#", {1=entity, 2=arguments.rc, 3=arguments.rc.processContext} );
			
			// SUCCESS
			if(!arguments.rc[ arguments.entityName ].hasErrors()) {
				
				// Show the Generic Action Success Message
				getHibachiScope().showMessage( getHibachiScope().rbKey( "#arguments.rc.entityActionDetails.subsystemName#.#arguments.rc.entityActionDetails.sectionName#.#arguments.rc.entityActionDetails.itemName#.#arguments.rc.processContext#_success" ), "success");
					
				// Show all of the specific messages & error messages for the entity
				arguments.rc[ arguments.entityName ].showErrorsAndMessages();
				
				// If there was a processObject then show all of it's errors & messages as well
				if(processObjectExists) {
					// Show all of the specific messages & error messages for the process Object
					arguments.rc[ arguments.entityName ].getProcessObject(rc.processContext).showErrorsAndMessages();
				}
				
				// If this is an ajax request then setup the response
				if(arguments.rc.ajaxRequest) {
					
					// Let AJAX know that this was a success
					arguments.rc.ajaxResponse["success"] = true;
				
				// Otherwise do the standard render / redirect
				} else {
					
					// Place the id in the URL for redirects in case this was a new entity before
					url[ entity.getPrimaryIDPropertyName() ] = arguments.rc[ arguments.entityName ].getPrimaryIDValue();
					
					// Render or Redirect a Success
					renderOrRedirectSuccess( defaultAction=arguments.rc.entityActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);	
				}
				
			// FAILURE
			} else {
				
				// Show all of the specific messages & error messages for the entity
				arguments.rc[ arguments.entityName ].showErrorsAndMessages();
				
				// If there was a processObject then show all of it's errors & messages as well
				if(processObjectExists) {
					// Show all of the specific messages & error messages for the process Object
					arguments.rc[ arguments.entityName ].getProcessObject(rc.processContext).showErrorsAndMessages();
				}
				
				// If this is an ajax request then setup the response
				if(arguments.rc.ajaxRequest) {
					
					// Let AJAX know that this was a failure
					arguments.rc.ajaxResponse["success"] = false;
					
					// Place the entities errors in the response
					arguments.rc.ajaxResponse["entityErrors"] = arguments.rc[ arguments.entityName ].getErrors();
					
					// Place the process objects errors in the response
					if(getFW().getBeanFactory().containsBean( "#arguments.entityName#_#arguments.rc.processContext#")) {
						arguments.rc.ajaxResponse["processObjectErrors"] = entity.getProcessObject(arguments.rc.processContext).getErrors();
					}
				
				// Otherwise do the standard render / redirect
				} else {
					
					// Place the id in the URL for redirects in case this was a new entity before
					url[ entity.getPrimaryIDPropertyName() ] = arguments.rc[ arguments.entityName ].getPrimaryIDValue();
				
					// Render or Redirect a faluire
					renderOrRedirectFailure( defaultAction=arguments.rc.entityActionDetails.detailAction, maintainQueryString=true, rc=arguments.rc);
					
				}
				
			}
		}
		
		
	}
	
	public void function genericExportMethod(required string entityName, required struct rc) {
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		
		entityService.invokeMethod("export#arguments.entityName#");
	}
	
	// ============================= PRIVATE HELPER METHODS
	
	private void function loadEntitiesFromRCIDs(required struct rc) {
		try{
			for(var key in arguments.rc) {
				if(!find('.',key) && right(key, 2) == "ID" && len(arguments.rc[key]) == "32") {
					var entityName = left(key, len(key)-2);
					if( getHibachiService().getEntityNameIsValidFlag(entityName) && ( !structKeyExists(arguments.rc, entityName) || !isObject(arguments.rc[entityName]) ) ) {
						var entityService = getHibachiService().getServiceByEntityName( entityName=entityName );
						var entity = entityService.invokeMethod("get#entityName#", {1=arguments.rc[key]});
						if(!isNull(entity)) {
							arguments.rc[ entityName ] = entity;
						}
					}
				}
			}
		}catch(any e){
			writedump(e);abort;
		}
	}
	
	public boolean function populateRedirectQS(required struct rc) {
		var hasValue = false;
		if(structKeyExists(arguments.rc, "sRedirectQS")) {
			arguments.rc.entityActionDetails.sRedirectQS = arguments.rc.sRedirectQS;
			hasValue = true;
		}
		if(structKeyExists(arguments.rc, "fRedirectQS")) {
			arguments.rc.entityActionDetails.fRedirectQS = arguments.rc.fRedirectQS;
			hasValue = true;
		}
		return hasValue;
	}
	
	private boolean function populateRenderAndRedirectSuccessValues(required struct rc) {
		var hasValue = false;
		if(structKeyExists(arguments.rc, "sRedirectURL")) {
			arguments.rc.entityActionDetails.sRedirectURL = arguments.rc.sRedirectURL;
			hasValue = true;
		} else if(structKeyExists(arguments.rc, "sRedirectAction")) {
			arguments.rc.entityActionDetails.sRedirectAction = arguments.rc.sRedirectAction;
			hasValue = true;
		} else if(structKeyExists(arguments.rc, "sRenderItem")) {
			arguments.rc.entityActionDetails.sRenderItem = arguments.rc.sRenderItem;
			hasValue = true;
		}
		return hasValue;
	}
	private boolean function populateRenderAndRedirectFailureValues(required struct rc) {
		var hasValue = false;
		if(structKeyExists(arguments.rc, "fRedirectURL")) {
			arguments.rc.entityActionDetails.fRedirectURL = arguments.rc.fRedirectURL;
			hasValue = true;
		} else if(structKeyExists(arguments.rc, "fRedirectAction")) {
			arguments.rc.entityActionDetails.fRedirectAction = arguments.rc.fRedirectAction;
			hasValue = true;
		} else if(structKeyExists(arguments.rc, "fRenderItem")) {
			arguments.rc.entityActionDetails.fRenderItem = arguments.rc.fRenderItem;
			hasValue = true;
		}
		return hasValue;
	}
	
	private void function renderOrRedirectSuccess( required string defaultAction, required boolean maintainQueryString, required struct rc ) {
		param name="arguments.rc.sRedirectQS" default="";
		
		// First look for a sRedirectURL in the rc, and do a redirectExact on that
		if(structKeyExists(arguments.rc, "sRedirectURL")) {
			getFW().redirectExact( url=arguments.rc.sRedirectURL );
		
		// Next look for a sRedirectAction in the rc, and do a redirect on that
		} else if (structKeyExists(arguments.rc, "sRedirectAction")) {
			getFW().redirect( action=arguments.rc.sRedirectAction, preserve="messages", queryString=buildRedirectQueryString(arguments.rc.sRedirectQS, arguments.maintainQueryString) );
			
		// Next look for a sRenderItem in the rc, set the view to that, and then call the controller for that action
		} else if (structKeyExists(arguments.rc, "sRenderItem")) {
			if(!getHibachiScope().getORMHasErrors()) {
				getHibachiScope().getDAO("hibachiDAO").flushORMSession();
			}
			getFW().setView( "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.#arguments.rc.sRenderItem#" );
			arguments.rc[ getFW().getAction() ] = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.#arguments.rc.sRenderItem#";
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.rc.sRenderItem, {rc=arguments.rc});
		
		// If nothing was defined then we just do a redirect to the defaultAction, if it is just a single value then render otherwise do a redirect
		} else if (listLen(arguments.defaultAction, ".") eq 1) {
			if(!getHibachiScope().getORMHasErrors()) {
				getHibachiScope().getDAO("hibachiDAO").flushORMSession();
			}
			getFW().setView( "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.#arguments.defaultAction#" );
			arguments.rc[ getFW().getAction() ] = arguments.defaultAction;
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.defaultAction, {rc=arguments.rc});
			
		} else {
			getFW().redirect( action=arguments.defaultAction, preserve="messages", queryString=buildRedirectQueryString(arguments.rc.sRedirectQS, arguments.maintainQueryString) );
			
		}
	}
	
	private void function renderOrRedirectFailure( required string defaultAction, required boolean maintainQueryString, required struct rc ) {
		param name="arguments.rc.fRedirectQS" default="";
		
		// First look for a fRedirectURL in the rc, and do a redirectExact on that
		if(structKeyExists(arguments.rc, "fRedirectURL")) {
			getFW().redirectExact( url=arguments.rc.fRedirectURL );
		
		// Next look for a fRedirectAction in the rc, and do a redirect on that
		} else if (structKeyExists(arguments.rc, "fRedirectAction")) {
			getFW().redirect( action=arguments.rc.fRedirectAction, preserve="messages", queryString=buildRedirectQueryString(arguments.rc.fRedirectQS, arguments.maintainQueryString) );
			
		// Next look for a fRenderItem in the rc, set the view to that, and then call the controller for that action
		} else if (structKeyExists(arguments.rc, "fRenderItem")) {
			getFW().setView( "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.#arguments.rc.fRenderItem#" );
			arguments.rc[ getFW().getAction() ] = "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.#arguments.rc.fRenderItem#";
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.rc.fRenderItem, {rc=arguments.rc});
		
		// Lastly if nothing was defined then we just do a redirect to the defaultAction
		} else if (listLen(arguments.defaultAction, ".") eq 1) {
			getFW().setView( "#arguments.rc.entityActionDetails.subsystemName#:#arguments.rc.entityActionDetails.sectionName#.#arguments.defaultAction#" );
			arguments.rc[ getFW().getAction() ] = arguments.defaultAction;
			this.invokeMethod("before", {rc=arguments.rc});
			this.invokeMethod(arguments.defaultAction, {rc=arguments.rc});
			
		} else {
			getFW().redirect( action=arguments.defaultAction, preserve="messages", queryString=buildRedirectQueryString(arguments.rc.fRedirectQS, arguments.maintainQueryString) );
			
		}
	}
	
	private string function buildRedirectQueryString( required string queryString, required boolean maintainQueryString ) {
		if(arguments.maintainQueryString) {
			for(var key in url) {
				if(key != getFW().getAction()) {
					arguments.queryString = listAppend(arguments.queryString, "#key#=#url[key]#", "&");
				}
			}
		}
		
		return arguments.queryString;
	}
	
	/*
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
	*/
}