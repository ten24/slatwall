component output="false" accessors="true" persistent="false" extends="HibachiObject" {

	property name="hibachiErrors" type="any" persistent="false";							// This porpery holds errors that are not part of ValidateThis, for example processing errors.
	property name="hibachiMessages" type="any" persistent="false";
	property name="populatedSubProperties" type="struct" persistent="false";
	property name="validations" type="struct" persistent="false";
	property name="announceEvent" type="boolean" persistent="false" default="true";

	// ========================= START: ACCESSOR OVERRIDES ==========================================

	// @hint Returns the errorBean object, if one hasn't been setup yet it returns a new one
	public any function getHibachiErrors() {
		if(!structKeyExists(variables, "hibachiErrors")) {
			variables.hibachiErrors = getTransient("hibachiErrors");
		}
		return variables.hibachiErrors;
	}
	
	public any function setHibachiErrors(any errors){
		if(structKeyExists(arguments,'errors')){
			variables.hibachiErrors = arguments.errors;
		}
	}

	public void function clearHibachiErrors(){
		structDelete(variables,'hibachiErrors');
	}

	// @hint Returns the messageBean object, if one hasn't been setup yet it returns a new one
	public any function getHibachiMessages() {
		if(!structKeyExists(variables, "hibachiMessages")) {
			variables.hibachiMessages = getTransient("hibachiMessages");
		}
		return variables.hibachiMessages;
	}

	// =========================  END:  ACCESSOR OVERRIDES ==========================================
	// ========================== START: ERRORS / MESSAGES ==========================================

	// @hint Returns a struct of all the errors for this entity
	public struct function getErrors() {
		return getHibachiErrors().getErrors();
	}

	// @hint Returns the error message of a given error name
	public array function getError( required string errorName ) {

		// Check First that the error exists, and if it does return it
		if( hasError(arguments.errorName) ) {
			return getErrors()[ arguments.errorName ];
		}

		// Default behavior if the error isn't found is to return an empty array
		return [];
	}

	// @hint Returns true if this object has any errors.
	public boolean function hasErrors() {
		if(structCount(getErrors())) {
			return true;
		}

		return false;
	}

	// @hint Returns true if a specific error key exists
	public boolean function hasError( required string errorName ) {
		return structKeyExists(getErrors(), arguments.errorName);
	}

	// @hint helper method to add an error to the error bean
	public void function addError( required string errorName, required any errorMessage) {
		getHibachiErrors().addError(argumentCollection=arguments);
	}

	// @hint helper method to add an array of errors to the error bean
	public void function addErrors( required struct errors ) {
		getHibachiErrors().addErrors(argumentCollection=arguments);
	}

	// @hint helper method that returns all error messages as <p> html tags
	public string function getAllErrorsHTML( ) {
		var returnString = "";

		for(var errorName in getErrors()) {

			// Make sure the error isn't a processObjects error or populate error
			if(!listFindNoCase("processObjects,populate", errorName)) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					returnString &= "<p class='error'>" & getErrors()[errorName][i] & "</p>";
				}
			}
		}

		return returnString;
	}

	// @hint helper method to have these error messages be passed to the current hibachiScope
	public void function showErrors() {

		// Loop over all errors
		for(var errorName in getErrors()) {

			// Make sure the error isn't a processObjects error or populate error
			if(!listFindNoCase("processObjects,populate", errorName)) {
				for(var i=1; i<=arrayLen(getErrors()[errorName]); i++) {
					getHibachiScope().showMessage(getErrors()[errorName][i], "error");
				}
			}

		}
	}

	// @hint Returns a struct of all the messages for this object
	public struct function getMessages() {
		return getHibachiMessages().getMessages();
	}

	// @hint Returns true if there are any messages
	public boolean function hasMessages( ) {
		return getHibachiMessages().hasMessages();
	}

	// @hint Returns true if a specific message key exists
	public boolean function hasMessage( required string messageName ) {
		return getHibachiMessages().hasMessage( arguments.messageName );
	}

	// @hint helper method to add an error to the error bean
	public void function addMessage( required string messageName, required string message ) {
		getHibachiMessages().addMessage(argumentCollection=arguments);
	}

	// @hint helper method that returns all messages as <p> html tags
	public string function getAllMessagesHTML( ) {
		var returnString = "";

		for(var messageName in getMessages()) {
			for(var i=1; i<=arrayLen(getMessages()[messageName]); i++) {
				returnString &= "<p class='message #lcase(messageName)#'>" & getMessages()[messageName][i] & "</p>";
			}
		}

		return returnString;
	}

	// @hint helper method to have these messages be passed to the current hibachiScope
	public void function showMessages() {
		for(var messageName in getMessages()) {
			for(var i=1; i<=arrayLen(getMessages()[messageName]); i++) {
				if(right(messageName, 5) eq "error") {
					getHibachiScope().showMessage(getMessages()[messageName][i], "error");
				} else if (right(messageName, 7) eq "warning") {
					getHibachiScope().showMessage(getMessages()[messageName][i], "warning");
				} else {
					getHibachiScope().showMessage(getMessages()[messageName][i], "info");
				}
			}
		}
	}

	// @hint helper method to have all error messages and regular messages shown
	public void function showErrorsAndMessages() {
		showErrors();
		showMessages();
	}

	// ==========================  END: ERRORS / MESSAGES ===========================================
	// ======================= START: POPULATION & VALIDATION =======================================

	public any function beforePopulate( required struct data={} ) {
		// Left Blank to be overridden by objects
	}

	public any function afterPopulate( required struct data={} ) {
		// Left Blank to be overridden by objects
	}
	
	
	/**
	 * Helper function to for `populate()` to check if the property can be populated; 
	*/
    private boolean function canPopulateProperty( 
        required struct propertyMeta,  
        string objectPopulateMode = 'default' //allowed values are [ default, public, private ]
    ){
        
        var propertyPopulateLevel = 'default';
        
        // we can rename `hb_populateEnabled` to `hb_populateLevel` as the later is more meaningful 
        // but not donig so to maintain compatability.
        // one option can be to support both keywords, and depricate the old one so we can slowly migrate
        if( structKeyExists(arguments.propertyMeta, "hb_populateEnabled") ){
            // allowed values are, [ false, private, public, true ]
            propertyPopulateLevel = arguments.propertyMeta.hb_populateEnabled; 
        }
        
        // if the property is explicitly marked to not populate in any condition [ 'hb_populateEnabled=false' ]
        if( !propertyPopulateLevel ){
            return false; 
        }
        
        // if the property is explicitly marked to populate in all conditions [ 'hb_populateEnabled=true' ]
        // OR if the current-Object is a Transient
        if( propertyPopulateLevel || !this.isPersistent() ){
            return true; 
        }
        
        // if populate-mode is PRIVATE
        // only populate-type [ private, public, true ] can be populated in PRIVATE mode
        if( arguments.objectPopulateMode == 'private' && listFindNoCase('private,public', propertyPopulateLevel) ){
            return true; 
        }
        
        // if populate-mode on is PUBLIC
        // only populate-type [ public, true ] can be populated in PRIVATE mode
        if( arguments.objectPopulateMode == 'public' && propertyPopulateLevel == 'public' ){
            return true; 
        }
        
        // else the populate-mode is DEFAULT,  
        // we'll check if current-user can perform CRUD for this property
        return this.getHibachiScope().authenticateEntityProperty( 
            crudType        = "update", 
            entityName      = this.getClassName(),
            propertyName    = arguments.propertyMeta.name 
        );
        
        logHibachi("the populate-mode: #arguments.objectPopulateMode# & property-populate-type: #propertyPopulateLevel# are not valid for Entity: #this.getClassName()# & propertyMetaData: " & serializeJSON(arguments.propertyMeta) );
        return false;
    }
    
    /**
	 * Helper function to for `populate()` to populate simple properties; 
	*/
    private void function populateSimpleValue( required struct propertyMeta, required any propertyValue ){
        
        arguments.propertyValue = trim(arguments.propertyValue);
        
        // If the value is blank, then we check to see if the property can be set to NULL.
		if( arguments.propertyValue == "" && ( !structKeyExists(arguments.propertyMeta, "notNull") || !arguments.propertyMeta.notNull ) ) {
			_setProperty(arguments.propertyMeta.name);

		// If the value isn't blank, or we can't set to null... then we just set the value.
		} else {
			/*
			if( !structKeyExists(arguments.propertyMeta,'hb_formatType') ){
				arguments.propertyMeta.hb_formatType = '';
			}
			_setProperty(arguments.propertyMeta.name, arguments.propertyValue, arguments.propertyMeta.hb_formatType);
			*/
			
			_setProperty(arguments.propertyMeta.name, rereplace( arguments.propertyValue, chr(002),'','all'));
			// if this property has a sessionDefault defined for it, then we should update that value with what was used
			if(structKeyExists(arguments.propertyMeta, "hb_sessionDefault")) {
				setPropertySessionDefault( arguments.propertyMeta.name, arguments.propertyValue );
			}
		}
    }

    /**
	 * Helper function to for `populate()` to populate many-to-one properties; 
	*/
    private void function populateManyToOne( 
        required struct propertyMeta, 
        required struct manyToOneDataStruct, 
        string formUploadDottedPath="", 
        string objectPopulateMode = this.getHibachiScope().getObjectPopulateMode(),
    ){
        
        var entityName = listLast( arguments.propertyMeta.cfc, '.' );
		var entityService = this.getService( "hibachiService" ).getServiceByEntityName( entityName );
        var relatedPropertyName = arguments.propertyMeta.name;
		// Find the primaryID column Name
		var primaryIDPropertyName = this.getService( "hibachiService" ).getPrimaryIDPropertyNameByEntityName( entityName );
        
		// If the primaryID exists then we can set the relationship
		if( !structKeyExists(arguments.manyToOneDataStruct, primaryIDPropertyName) ){
		    arguments.manyToOneDataStruct[ primaryIDPropertyName ] = '';
		}

        var primaryIDValue = trim( arguments.manyToOneDataStruct[primaryIDPropertyName] );
		
	    // If there were no additional values in the strucuture then we just try to get the entity and set it... 
		// in this way a null is a valid option
		if( structCount(arguments.manyToOneDataStruct) == 1 ){
		    
			// If the value passed in for the ID is blank, then set the value of the currentProperty to NULL
			if( primaryIDValue == "") {
				return _setProperty( relatedPropertyName );
            }
            
            // If it was an actual ID, then we will try to load that entity
            
			// Load the specific entity, if one doesn't exist... this will be null
			var relatedEntity = entityService.invokeMethod("get" & entityName, { 1=primaryIDValue });
			
			if( !isNull(relatedEntity) ){
				// Set the value of the property as the loaded entity
				_setProperty(relatedPropertyName, relatedEntity );
			}
			
			return; // no further operation required;
		}


		// If there were additional values in the data, then we will get the entity by the primaryID or create a new one
		// and populate / validate by calling save in it's service[ see populated-sub-properties, and validation ].

		// try to load if there was a prior relation 
		var relatedEntity = this.invokeMethod( "get" & relatedPropertyName );
        // 	if one doesn't exist, we're creating a new relation
		if( isNull(relatedEntity) || relatedEntity.getPrimaryIDValue() != primaryIDValue ){
			relatedEntity = entityService.invokeMethod( "get" & entityName, { 1=primaryIDValue, 2=true } );
		} 

		// Set the value of the property as the loaded entity
		_setProperty( relatedPropertyName, relatedEntity );
		// Populate the sub property
		relatedEntity.populate( 
		    arguments.manyToOneDataStruct, 
		    arguments.formUploadDottedPath & relatedPropertyName & '.', 
		    arguments.objectPopulateMode 
		);
		
		// Tell the variables scope that we populated this sub-property
		this.addPopulatedSubProperty( relatedPropertyName, relatedEntity);
    }
    
    /**
	 * Helper function to for `populate()` to populate ont-to-many properties; 
	*/   
    private void function populateOneToMany( 
        required struct propertyMeta, 
        required array oneToManyDataArray, 
        string formUploadDottedPath="", 
        string objectPopulateMode = this.getHibachiScope().getObjectPopulateMode();    
    ){
        
        var entityName = listLast( arguments.propertyMeta.cfc, '.' );
		var entityService = this.getService( "hibachiService" ).getServiceByEntityName( entityName );
        
        var currentPropertyName = arguments.propertyMeta.name;
        var currentPropertySingularName = arguments.propertyMeta.singularName;
		var primaryIDPropertyName = this.getService( "hibachiService" ).getPrimaryIDPropertyNameByEntityName( entityName );
		
		// And Filter invalid indices
		arguments.oneToManyDataArray = arguments.oneToManyDataArray.filter( function(value){ 
		    return !isNull(value); 
		});
		
		// Loop over the array of objects in the data... Then load, populate, and validate each one
		for( var i=1; i<= arrayLen(arguments.oneToManyDataArray); i++ ){
		    
		    var oneToManyItemDataStruct = arguments.oneToManyDataArray[ i ];

		    // Check to make sure that this struct has the primary ID property in it, otherwise we can't do a populate.  
		    if( structKeyExists( oneToManyItemDataStruct, primaryIDPropertyName) ){
		        
		        var primaryIDValue = trim( oneToManyItemDataStruct[ primaryIDPropertyName ] );

				// Load the specific entity, and if one doesn't exist yet then return a new entity
				var relatedEntity = entityService.invokeMethod( "get"&entityName, { 1=primaryIDValue, 2=true } );
				// Add the entity to the existing objects properties
				this.invokeMethod("add"&currentPropertySingularName, { 1=relatedEntity });

				// If there were additional values in the data array, then we use those values to populate the entity, and validating it as well.
				if( structCount(oneToManyItemDataStruct) > 1) {
					
					// Populate the sub property
					relatedEntity.populate( 
					    data                    = oneToManyItemDataStruct, 
					    formUploadDottedPath    = arguments.formUploadDottedPath&currentPropertyName&"["&i&"].", // E.g. `order.orderItems[1].`
					    objectPopulateMode            = arguments.objectPopulateMode 
					);
					
					this.addPopulatedSubProperty(currentPropertyName, relatedEntity);
				}
			}
		}
		
    }
    
    /**
	 * Helper function to for `populate()` to populate many-to-many properties; 
	*/   
    private void function populateManyToMany( required struct propertyMeta, required string manyToManyIDList ){

        var entityName = listLast( arguments.propertyMeta.cfc, '.' );
        var currentPropertyName = arguments.propertyMeta.name;
        var currentPropertySingularName = arguments.propertyMeta.singularName;

		// set the service to use to get the specific entity
		var entityService = this.getService( "hibachiService" ).getServiceByEntityName( entityName );
		// Find the primaryID column Name
		var primaryIDPropertyName = this.getService( "hibachiService" ).getPrimaryIDPropertyNameByEntityName( entityName );

		// Get all of the existing related entities
		var existingRelatedEntities = invokeMethod( "get"&currentPropertyName );

		if( isNull(existingRelatedEntities)) {
			throw("The Many-To-Many relationship for '#currentPropertyName#' could not be populated because it wasn't setup as an empty array on init.");
		}

		// Loop over the existing related entities and check if the primaryID exists in the list of data that was passed in.
		for(var relatedEntity in existingRelatedEntities ){

			// Get the primary ID of this existing relationship
			var thisPrimrayID = relatedEntity.invokeMethod( "get"&primaryIDPropertyName );
			// Find out if hat ID is in the list
			var listIndex = listFind( arguments.manyToManyIDList, thisPrimrayID );

			if(listIndex) {
			    // If the relationship already exist, then remove that id from the list
				arguments.manyToManyIDList = listDeleteAt(arguments.manyToManyIDList, listIndex);
			} else {
			    // If the relationship no longer exists in the list, then remove the entity relationship
				this.invokeMethod("remove"&currentPropertySingularname, { 1=relatedEntity } );
			}
		}

		// Loop over all of the primaryID's that are still in the list, and add the relationship
		for(var relatedEntityID in arguments.manyToManyIDList ){
			// Load the specific entity, if one doesn't exist... this will be null
			var relatedEntity = entityService.invokeMethod( "get"&currentPropertyName, { 1=relatedEntityID } );
			// If the entity exists, then add it to the relationship
			if(!isNull(relatedEntity)) {
				this.invokeMethod( "add"&currentPropertySingularname, { 1=relatedEntity } );
			}
		}
		
    }

	// @hint Public populate method to utilize a struct of data that follows the standard property form format
	public any function populate( 
	    required struct data    = {}, 
	    formUploadDottedPath    = "", 
	    string objectPopulateMode     = this.getHibachiScope().getObjectPopulateMode() 
	){
	    
		// Call beforePopulate
		beforePopulate(data=arguments.data);

		// Get an array of All the properties for this object
		var properties = getProperties();

		// Loop over properties looking for a value in the incomming data
		for( var p=1; p <= arrayLen(properties); p++ ) {

			// Set the current property into variable of meta data
			var currentProperty = properties[p];

			// Check to see if this property has a key in the data that was passed in
			if( structKeyExists(arguments.data, currentProperty.name) && this.canPopulateProperty(currentProperty, arguments.objectPopulateMode) ){

			    var currentPropertyValue = arguments.data[ currentProperty.name ];

				// ( COLUMN )
				if( (!structKeyExists(currentProperty, "fieldType") || currentProperty.fieldType == "column") && isSimpleValue(currentPropertyValue) && !structKeyExists(currentProperty, "hb_fileUpload") ) {

                    populateSimpleValue(currentProperty, currentPropertyValue);

				// ( POPULATE-STRUCT )
				} else if( structKeyExists(currentProperty, "fieldType") && currentProperty.fieldType == "struct"  && structKeyExists(currentProperty, "hb_populateStruct") && currentProperty.hb_populateStruct && isStruct( currentPropertyValue ) ) {

					_setProperty(currentProperty.name, currentPropertyValue );

				// ( POPULATE-ARRAY )
				} else if( (!structKeyExists(currentProperty, "fieldType") || currentProperty.fieldType == "column") && structKeyExists(currentProperty, "hb_populateArray") && currentProperty.hb_populateArray && isArray( currentPropertyValue ) ) {

					_setProperty(currentProperty.name, currentPropertyValue );

				// (MANY-TO-ONE) Do this logic if this property is a many-to-one relationship, and the data passed in is of type struct
				} else if( structKeyExists(currentProperty, "fieldType") && currentProperty.fieldType == "many-to-one" && isStruct( currentPropertyValue ) ){

					populateManyToOne( currentProperty, currentPropertyValue, arguments.formUploadDottedPath );

				// (ONE-TO-MANY) Do this logic if this property is a one-to-many or many-to-many relationship, and the data passed in is of type array
				} else if ( structKeyExists(currentProperty, "fieldType") && (currentProperty.fieldType == "one-to-many" or currentProperty.fieldType == "many-to-many") && isArray( currentPropertyValue ) ){

    			    // Also check to make sure populateSubProperties was not set to false in the data (if not defined we asume true).
        		    var canPopulateSubProperties = (!structKeyExists(arguments.data, "populateSubProperties") || arguments.data.populateSubProperties); //not sure about the use-cases, but keeping it for compatibility.
                    
                    if(canPopulateSubProperties){
					    populateOneToMany( currentProperty, currentPropertyValue, arguments.formUploadDottedPath );
                    }

				// (MANY-TO-MANY) Do this logic if this property is a many-to-many relationship, and the data passed in as a list of ID's
				} else if ( structKeyExists(currentProperty, "fieldType") && currentProperty.fieldType == "many-to-many" && isSimpleValue( currentPropertyValue ) ){

					populateManyToMany( currentProperty, currentPropertyValue );

				}
			}
		}

		// Do any file upload properties
		for( var p=1; p <= arrayLen(properties); p++ ) {

			// Setup the current property
			currentProperty = properties[p];

			// Check to see if we should upload this property
			// Prepend the provided formUploadDottedPath if this file is being uploaded as a subpopulated property to determine absolute path reference for form scope retrieval
			if( 
				structKeyExists(arguments.data, currentProperty.name) 
				&& (
					!structKeyExists(currentProperty, "fieldType") 
					|| currentProperty.fieldType == "column"
				) && isSimpleValue(arguments.data[ currentProperty.name ]) 
				&& structKeyExists(currentProperty, "hb_fileUpload") 
				&& currentProperty.hb_fileUpload 
				&& structKeyExists(currentProperty, "hb_fileAcceptMIMEType") 
				&& len(arguments.data[ currentProperty.name ]) 
				&& structKeyExists(form, "#arguments.formUploadDottedPath##currentProperty.name#") 
				&& len(form["#arguments.formUploadDottedPath##currentProperty.name#"])
			) {
				// Wrap in try/catch to add validation error based on fileAcceptMIMEType
				try {

					// Get the upload directory for the current property
					var uploadDirectory = this.invokeMethod("get#currentProperty.name#UploadDirectory");

					// Handle s3 upload
					if(left(uploadDirectory, 5) == 's3://'){

						var uploadData = fileUpload(getVirtualFileSystemPath(), '#arguments.formUploadDottedPath##currentProperty.name#', currentProperty.hb_fileAcceptMIMEType, 'makeUnique' );

						uploadDirectory = replace(uploadDirectory,'s3://','');

						var newFileName = createUUID() & '.' & uploadData.clientFileExt;

						var uploadResult = getService("hibachiUtilityService").uploadToS3(
 							bucketName=uploadDirectory,
							fileName=uploadData.serverfile,
							keyName=newFileName,
 							contentType='#uploadData.contentType#/#uploadData.contentSubType#',
 							awsAccessKeyId=getHibachiScope().setting("globalS3AccessKey"),
 							awsSecretAccessKey=getHibachiScope().setting("globalS3SecretAccessKey"),
							uploadDir=uploadData.serverdirectory
						);

						if(!uploadResult){
 							throw;
 						}

						_setProperty(currentProperty.name, newFileName);
					}else{
						// If the directory where this file is going doesn't exists, then create it
						if(!directoryExists(uploadDirectory)) {
							directoryCreate(uploadDirectory);
						}

						// Do the upload
						var uploadData = fileUpload( uploadDirectory, '#arguments.formUploadDottedPath##currentProperty.name#', currentProperty.hb_fileAcceptMIMEType, 'makeUnique' );

						// Update the property with the serverFile name
						_setProperty(currentProperty.name, uploadData.serverFile);

						// Attempt to invoke setXXXUploadStatus() method naming convention if exists to store reference to the file upload status data
						// If file upload property name already has xxxUpload suffix, only add 'Status' so we can reference 'setXXXUploadStatus' instead of 'setXXXUploadUploadStatus'
						var uploadStatusMethodName = 'set#currentProperty.name#';
						if (right(currentProperty.name, len('upload')) == 'upload') {
							uploadStatusMethodName &= 'Status';
						} else {
							uploadStatusMethodName &= 'UploadStatus';
						}

						// Invoke if a method matches the appropriate naming convention
						if (structKeyExists(this, uploadStatusMethodName)) {
							invokeMethod(uploadStatusMethodName, {1=uploadData});
						}
					}

				} catch(any e) {
					this.addError(currentProperty.name, rbKey('validate.fileUpload'));
				}
			}
		}

		// Call afterPopulate
		afterPopulate(data=arguments.data);

		// Return this object
		return this;
	}
	
	public void function addPopulatedSubProperty( required string propertyName, required any entity ) {
		// Make sure the structure exists
		if(!structKeyExists(variables, "populatedSubProperties")){
			variables.populatedSubProperties = {};
		}

		// Get the meta data from the objects property
		var propertyMeta = getPropertyMetaData( arguments.propertyName );

		// If fieldtype = many-to-one
		if(structKeyExists(propertyMeta, "fieldtype") && propertyMeta.fieldType == "many-to-one") {
			variables.populatedSubProperties[ arguments.propertyName ] = arguments.entity;

		// If fieldtype = one-to-many
		} else if (structKeyExists(propertyMeta, "fieldtype") && propertyMeta.fieldType == "one-to-many") {
			if(!structKeyExists(variables.populatedSubProperties, arguments.propertyName)) {
				variables.populatedSubProperties[ arguments.propertyName ] = [];
			}
			arrayAppend(variables.populatedSubProperties[ arguments.propertyName ], arguments.entity);
		}
	}


	// @hind public method to see all of the validations for a particular context
	public struct function getValidations( string context="" ) {
		return getService("hibachiValidationService").getValidationsByContext( object=this, context=arguments.context);
	}

	// @hint pubic method to validate this object
	public any function validate( string context="" ) {
		getService("hibachiValidationService").validate(object=this, context=arguments.context);

		// If there were sub properties that have been populated, then we should validate each of those
		if(structKeyExists(variables, "populatedSubProperties")) {

			// Loop ove each property that was populated
			for(var propertyName in variables.populatedSubProperties) {
				
				// setup the correct validation context for this property
				var propertyContext = getService("hibachiValidationService").getPopulatedPropertyValidationContext( object=this, propertyName=propertyName, originalContext=arguments.context );
				
				var entityService = getService( "hibachiService" ).getServiceByEntityName( listLast(getPropertyMetaData(propertyName).cfc,'.') );
				
				// Make sure that the context is a valid context
				if( len(propertyContext) && (!isBoolean(propertyContext) || propertyContext) ) {
					// If this was a one-to-many than validate each
					if(isArray(variables.populatedSubProperties[ propertyName ])) {

						// Loop over each one that was populated and call the validation
						for(var i=1; i<=arrayLen(variables.populatedSubProperties[ propertyName ]); i++) {

							// Validate this one
							variables.populatedSubProperties[ propertyName ][i].validate( propertyContext );

							// If it had errors, add an error to this entity
							if(variables.populatedSubProperties[ propertyName ][i].hasErrors()) {
								getHibachiErrors().addError('populate', propertyName);
							}
						}

					// If this was a many-to-one, then just validate it
					} else if (!isNull(variables[ propertyName ])) {
						// Validate the property
						variables[ propertyName ].validate( propertyContext );

						// If it had errors, add an error to this entity
						if(variables[ propertyName ].hasErrors()) {
							getHibachiErrors().addError('populate', propertyName);
						}
					}
				}
			}
		}

		if(this.isPersistent() && this.hasErrors()) {
			getHibachiScope().setORMHasErrors( true );
		}

		return getHibachiErrors();
	}

	// =======================  END:  POPULATION & VALIDATION =======================================
	// ======================= START: PROPERTY INTROSPECTION ========================================

	public any function hasPropertyByPropertyIdentifier(required string propertyIdentifier){
		var object = getLastObjectByPropertyIdentifier( propertyIdentifier=arguments.propertyIdentifier );

		if(isNull(object) || isSimpleValue(object)) {
			return false;
		}
		var propertyName = listLast(arguments.propertyIdentifier,'.');
		return object.hasProperty(propertyName);
	}

	// @hint Public method to retrieve a value based on a propertyIdentifier string format
	public any function getValueByPropertyIdentifier(required string propertyIdentifier, boolean formatValue=false, any args) {
		var object = getLastObjectByPropertyIdentifier( propertyIdentifier=arguments.propertyIdentifier );
		var propertyName = listLast(arguments.propertyIdentifier,'.');
		
		if(!isNull(object) && !isSimpleValue(object)) {
			if(arguments.formatValue) {
				return object.getFormattedValue( propertyName );
			}
			
			if (structKeyExists(arguments, "args")){
				var rawValue = object.invokeMethod("get#propertyName#", args);
			}else{
				var rawValue = object.invokeMethod("get#propertyName#");
			}
			
			if(!isNull(rawValue)) {
				return rawValue;
			}
		}

		return "";
	}
	

	public string function getOrmTypeByPropertyIdentifier( required string propertyIdentifier ) {		
		return getService('HibachiService').getOrmTypeByEntityNameAndPropertyIdentifier(this.getClassName(), arguments.propertyIdentifier);
	}
	
	public string function getSingularNameByPropertyIdentifier( required string propertyIdentifier ) {
		var entityName = getService('HibachiService').getLastEntityNameInPropertyIdentifier(entityName=this.getClassName(), propertyIdentifier=arguments.propertyIdentifier );
		var object = getService('HibachiService').getEntityObject(entityName);
		var propertyName = listLast(arguments.propertyIdentifier,'.');
		if(
			!isNull(object) 
			&& !isSimpleValue(object)
			&& structKeyExists(object.getPropertyMetaData( propertyName ),'fieldtype')
			&& object.getPropertyMetaData( propertyName ).fieldtype == 'one-to-many'
		) {
			return object.getPropertyMetaData( propertyName ).singularName;
		}
		return "";
	}
	
	public string function getFormatTypeByPropertyIdentifier( required string propertyIdentifier ) {
		var entityName = getService('HibachiService').getLastEntityNameInPropertyIdentifier(entityName=this.getClassName(), propertyIdentifier=arguments.propertyIdentifier );
		var object = getService('HibachiService').getEntityObject(entityName);
		var propertyName = listLast(arguments.propertyIdentifier,'.');
		return object.getPropertyFormatType(propertyName);
	}

	public any function getLastObjectByPropertyIdentifier(required string propertyIdentifier) {

		//if 0 property identifier points to an object not a property on an object
		if(listLen(arguments.propertyIdentifier, ".") <= 1) {
			return this;
		}
		var object = invokeMethod("get#listFirst(arguments.propertyIdentifier, '.')#");
		if(!isNull(object) && isObject(object)) {
			return object.getLastObjectByPropertyIdentifier(listRest(arguments.propertyIdentifier, "."));
		}
	}

	public any function getFormattedValue(required string propertyName, string formatType, string locale, boolean useFallback=true ) {
		arguments.value = invokeMethod("get#arguments.propertyName#");
		// check if a formatType was passed in, if not then use the getPropertyFormatType() method to figure out what it should be by default
		if(!structKeyExists(arguments, "formatType")) {
			arguments.formatType = getPropertyFormatType( arguments.propertyName );
		}
		if(!structKeyExists(arguments, 'locale')){
			arguments.locale = getHibachiScope().getSession().getRbLocale();
		}

		// If the formatType is custom then deligate back to the property specific getXXXFormatted() method.
		if(arguments.formatType eq "custom") {
			return this.invokeMethod("get#arguments.propertyName#Formatted");
		} else if(arguments.formatType eq "rbKey") {
			if(!isNull(arguments.value)) {
				return rbKey('entity.#replace(getEntityName(),getApplicationValue('applicationKey'),"")#.#arguments.propertyName#.#arguments.value#');
			} else {
				return '';
			}
		}

		// This is the null format option
		if(isNull(arguments.value)) {
			var propertyMeta = getPropertyMetaData( arguments.propertyName );
			if(structKeyExists(propertyMeta, "hb_nullRBKey")) {
				return rbKey(propertyMeta.hb_nullRBKey);
			}

			return "";
		// This is a simple value, so now lets try to actually format the value
		} else if (isSimpleValue(arguments.value)) {
			var formatDetails = {
				locale:arguments.locale,
				object:this,
				propertyName:arguments.propertyName,
				useFallback:arguments.useFallback
			};
			
			if(this.hasProperty('currencyCode') && !isNull(getCurrencyCode())) {
				formatDetails.currencyCode = getCurrencyCode();
			}
			
			
			// handle Attribute Options Translation
			if (len(arguments.value) && arguments.formatType == 'multiselect' && structKeyExists(variables, "getAttributeValue") && hasProperty("attributeValues") && hasAttributeCode(arguments.propertyName) ) {

				var propertyMeta = getPropertyMetaData( arguments.propertyName );
				
				if(structKeyExists(propertyMeta, "hb_attributeID")) {
					
					var attributeOptionValues = listToArray(arguments.value);
					var formatedValues = '';
					for(var attributeOptionValue in attributeOptionValues){
						
						var attributeOption = getDAO('AttributeDAO').getAttributeOptionByAttributeOptionValueAndAttributeID(
							attributeOptionValue = attributeOptionValue, 
							attributeID = propertyMeta.hb_attributeID
						);
						
						if(!isNull(attributeOption)){
							formatDetails['object'] = attributeOption;
							formatDetails['propertyName'] = 'attributeOptionLabel';
						}else{
							formatDetails['object'] = this;
							formatDetails['propertyName'] = arguments.propertyName;
						}
						formatedValues = listAppend(formatedValues, getService("hibachiUtilityService").formatValue(value=attributeOptionValue, formatType=arguments.formatType, formatDetails=formatDetails));
						
					}
					return formatedValues;
				}
				
			}
			
			
			return getService("hibachiUtilityService").formatValue(value=arguments.value, formatType=arguments.formatType, formatDetails=formatDetails);
		}

		// If the value has not yet been returned, then it is because the value was complex
		throw("You cannont convert complex values to formatted Values");
	}

	// @hint public method for getting the display format for a given property, this is used a lot by the HibachiPropertyDisplay
	public string function getPropertyFormatType(required string propertyName) {

		var propertyMeta = getPropertyMetaData( arguments.propertyName );

		if(structKeyExists(propertyMeta, "hb_displayType")) {
			return propertyMeta.hb_displayType;

		// First check to see if formatType was explicitly set for this property
		} else if(structKeyExists(propertyMeta, "hb_formatType")) {
			return propertyMeta.hb_formatType;

		// If it wasn't set, but this is a simple value field then inspect the dataTypes and naming convention to try an figure it out
		} else if( !structKeyExists(propertyMeta, "fieldType") || propertyMeta.fieldType == "column" ) {

			var dataType = "";

			// Check if there is an ormType attribute for this property to use first and asign it to the 'dataType' local var.  Otherwise check if the type attribute was set and use that.
			if( structKeyExists(propertyMeta, "ormType") ) {
				dataType = propertyMeta.ormType;
			} else if ( structKeyExists(propertyMeta, "type") ) {
				dataType = propertyMeta.type;
			}

			// Check the dataType against different lists of types for correct formatType
			if( listFindNoCase("boolean,yes_no,true_false", dataType) ) {
				return "yesno";
			} else if ( listFindNoCase("date,timestamp", dataType) ) {
				return "datetime";
			} else if ( listFindNoCase("big_decimal", dataType) && right(arguments.propertyName, 6) == "weight" ) {
				return "weight";
			} else if ( listFindNoCase("big_decimal", dataType) ) {
				return "currency";
			}

		}

		// By default just return non
		return "none";
	}

	// @hint public method for returning the validation class of a property
	public string function getPropertyValidationClass( required string propertyName, string context="save" ) {

		var validationClass = "";

		var validations = getValidations(arguments.context);

		if(structKeyExists(validations, arguments.propertyName)) {
			for(var i=1; i<=arrayLen(validations[ arguments.propertyName ]); i++) {
				var constraintDetails = validations[ arguments.propertyName ][i];
				if(!structKeyExists(constraintDetails, "conditions")) {
					if(constraintDetails.constraintType == "required" && constraintDetails.constraintValue) {
						validationClass = listAppend(validationClass, "required", " ");
					} else if (constraintDetails.constraintType == "dataType") {
						if(constraintDetails.constraintValue == "numeric") {
							validationClass = listAppend(validationClass, "number", " ");
						} else {
							validationClass = listAppend(validationClass, constraintDetails.constraintValue, " ");
						}
					}
				}
			}
		}

		return validationClass;
	}

	// @hint public method for getting the title to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay
	public string function getPropertyTitle(required string propertyName) {

		var propertyMetaData = getPropertyMetaData( arguments.propertyName );

		if(structKeyExists(propertyMetaData, "hb_rbKey")) {
			return rbKey(propertyMetaData.hb_rbKey);

		} else if (isPersistent()) {

			// See if we can add additional lookup locations
			if(structKeyExists(propertyMetaData, "fieldtype") && structKeyExists(propertyMetaData, "cfc") && listFindNoCase("one-to-many,many-to-many", propertyMetaData.fieldtype)) {
				return rbKey("entity.#getClassName()#.#arguments.propertyName#,entity.#propertyMetaData.cfc#_plural");
			} else if (structKeyExists(propertyMetaData, "fieldtype") && structKeyExists(propertyMetaData, "cfc") && listFindNoCase("many-to-one", propertyMetaData.fieldtype)) {
				return rbKey("entity.#getClassName()#.#arguments.propertyName#,entity.#propertyMetaData.cfc#");
			}

			return rbKey("entity.#getClassName()#.#arguments.propertyName#");

		} else if (isProcessObject()) {

			// See if we can add additional lookup locations
			if(structKeyExists(propertyMetaData, "fieldtype") && structKeyExists(propertyMetaData, "cfc") && listFindNoCase("one-to-many,many-to-many", propertyMetaData.fieldtype)) {
				return rbKey("processObject.#getClassName()#.#arguments.propertyName#,entity.#propertyMetaData.cfc#_plural");
			} else if (structKeyExists(propertyMetaData, "fieldtype") && structKeyExists(propertyMetaData, "cfc") && listFindNoCase("many-to-one", propertyMetaData.fieldtype)) {
				return rbKey("processObject.#getClassName()#.#arguments.propertyName#,entity.#propertyMetaData.cfc#");
			}

			return rbKey("processObject.#getClassName()#.#arguments.propertyName#");
		}

		return rbKey("object.#getClassName()#.#arguments.propertyName#");
	}

	// @hint public method for getting the title hint to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay
	public string function getPropertyHint(required string propertyName) {
		var propertyMetaData = getPropertyMetaData( arguments.propertyName );
		if(structKeyExists(propertyMetaData, "hb_rbKey")) {
			var keyValue = rbKey("#propertyMetaData.hb_rbKey#_hint");
		} else if (isPersistent()) {
			var keyValue = rbKey("entity.#getClassName()#.#arguments.propertyName#_hint");
		} else if (isProcessObject()) {
			var keyValue = rbKey("processObject.#getClassName()#.#arguments.propertyName#_hint");
		} else {
			var keyValue = rbKey("object.#getClassName()#.#arguments.propertyName#_hint");
		}
		if(right(keyValue, 8) != "_missing") {
			return keyValue;
		}
		return "";
	}

	// @hint public method to get the rbKey value for a property in a subentity
	public string function getTitleByPropertyIdentifier( required string propertyIdentifier ) {
		if(find(".", arguments.propertyIdentifier)) {
			var exampleEntity = entityNew("#getApplicationValue('applicationKey')##listLast(getPropertyMetaData( listFirst(arguments.propertyIdentifier, '.') ).cfc,'.')#");
			return exampleEntity.getTitleByPropertyIdentifier( replace(arguments.propertyIdentifier, "#listFirst(arguments.propertyIdentifier, '.')#.", '') );
		}
		return getPropertyTitle( arguments.propertyIdentifier );
	}

	// @hint public method to get the rbKey value for a property in a subentity
	public string function getFieldTypeByPropertyIdentifier( required string propertyIdentifier ) {
		if(find(".", arguments.propertyIdentifier)) {
			var exampleEntity = entityNew("#getApplicationValue('applicationKey')##listLast(getPropertyMetaData( listFirst(arguments.propertyIdentifier, '.') ).cfc,'.')#");
			return exampleEntity.getFieldTypeByPropertyIdentifier( replace(arguments.propertyIdentifier, "#listFirst(arguments.propertyIdentifier, '.')#.", '') );
		}
		return getPropertyFieldType( arguments.propertyIdentifier );
	}

	// @hint public method for returning the name of the field for this property, this is used a lot by the PropertyDisplay
	public string function getPropertyFieldName(required string propertyName) {

		// Get the Meta Data for the property
		var propertyMeta = getPropertyMetaData( arguments.propertyName );

		// If this is a relational property, and the relationship is many-to-one, then return the propertyName and propertyName of primaryID
		if( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "many-to-one" ) {

			var primaryIDPropertyName = getService( "hibachiService" ).getPrimaryIDPropertyNameByEntityName( "#getApplicationValue('applicationKey')##listLast(propertyMeta.cfc,'.')#" );
			return "#arguments.propertyName#.#primaryIDPropertyName#";
		}

		// Default case is just to return the property Name
		return arguments.propertyName;
	}

	// @hint public method for inspecting the property of a given object and determining the most appropriate field type for that property, this is used a lot by the HibachiPropertyDisplay
	public string function getPropertyFieldType(required string propertyName) {

		// Get the Meta Data for the property
		var propertyMeta = getPropertyMetaData( arguments.propertyName );

		// Check to see if there is a meta data called 'formFieldType'
		if( structKeyExists(propertyMeta, "hb_formFieldType") ) {
			return propertyMeta.hb_formFieldType;
		}

		// If this isn't a Relationship property then run the lookup on ormType then type.
		if( !structKeyExists(propertyMeta, "fieldType") || propertyMeta.fieldType == "column" ) {

			var dataType = "";

			// Check if there is an ormType attribute for this property to use first and asign it to the 'dataType' local var.  Otherwise check if the type attribute was set and use that.
			if( structKeyExists(propertyMeta, "ormType") ) {
				dataType = propertyMeta.ormType;
			} else if ( structKeyExists(propertyMeta, "type") ) {
				dataType = propertyMeta.type;
			}

			// Check the dataType against different lists of types for correct fieldType
			if( listFindNoCase("boolean,yes_no,true_false", dataType) ) {
				return "yesno";
			} else if ( listFindNoCase("date,timestamp", dataType) ) {
				return "dateTime";
			} else if ( listFindNoCase("array", dataType) ) {
				return "select";
			} else if ( listFindNoCase("struct", dataType) ) {
				return "checkboxgroup";
			}

			// If the propertyName has the word 'password' in it... then use a password field
			if(findNoCase("password", arguments.propertyName)) {
				return "password";
			}

		// If this is a Relationship property, then determine the relationship type and return the correct fieldType
		} else if( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "many-to-one" ) {
			return "select";
		} else if ( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "one-to-many" ) {
			throw("There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldType for #arguments.propertyName#");
		} else if ( structKeyExists(propertyMeta, "fieldType") && propertyMeta.fieldType == "many-to-many" ) {
			return "listingMultiselect";
		}

		// Default case if no matches were found is a text field
		return "text";
	}

	public boolean function getPropertyIsNumeric( required string propertyName ) {
		var propertyMetaData = getPropertyMetaData(arguments.propertyName);
		if( structKeyExists(propertyMetaData, "ormtype") && 
			listFindNoCase("big_decimal,integer,int,double,float", propertyMetaData.ormtype)
		){
			return true; 
		}
		return false; 
	} 

	// @help public method for getting the meta data of a specific property
	public struct function getPropertyMetaData( required string propertyName ) {
		var propertiesStruct = getPropertiesStruct();

		if(structKeyExists(propertiesStruct, arguments.propertyName)) {
			return propertiesStruct[ arguments.propertyName ];
		}

		// If no properties found with the name throw error
		throw("No property found with name #propertyName# in #getClassName()#");
	}

	// this method allows for default values to be pulled at the session level so that forms re-use the last selection by a user
	public any function getPropertySessionDefault( required string propertyName ) {
		if(!getHibachiScope().hasSessionValue("propertySessionDefault_#getClassName()#_#arguments.propertyName#")) {
			var propertyMeta = getPropertyMetaData( propertyName=arguments.propertyName );
			getHibachiScope().setSessionValue("propertySessionDefault_#getClassName()#_#arguments.propertyName#", propertyMeta.hb_sessionDefault);
		}
		return getHibachiScope().getSessionValue("propertySessionDefault_#getClassName()#_#arguments.propertyName#");
	}

	// this method allows for default values to be stored at the session level so that forms re-use the last selection by a user
	public any function setPropertySessionDefault( required string propertyName, required any defaultValue ) {
		getHibachiScope().setSessionValue("propertySessionDefault_#getClassName()#_#arguments.propertyName#", arguments.defaultValue);
	}

	public boolean function hasProperty(required string propertyName) {
		return structKeyExists( getPropertiesStruct(), arguments.propertyName );
	}

	// =======================  END: PROPERTY INTROSPECTION  ========================================
	// ==================== START: APPLICATION CACHED META VALUES ===================================

	public array function getProperties() {
		if( !getHibachiScope().hasApplicationValue("classPropertyCache_#getClassFullname()#") ) {
			var metaData = getMetaData(this);

			var hasExtends = structKeyExists(metaData, "extends");
			var metaProperties = [];
			do {
				var hasExtends = structKeyExists(metaData, "extends");
				if(structKeyExists(metaData, "properties")) {
					metaProperties = getService("hibachiUtilityService").arrayConcat(metaProperties, metaData.properties);
				}
				if(hasExtends) {
					metaData = metaData.extends;
				}
			} while( hasExtends );

			var metaPropertiesArrayCount = arraylen(metaProperties);
			for(var i=1; i < metaPropertiesArrayCount;i++){
				metaProperties[i] = convertStructToLowerCase(metaProperties[i]);
			}
			setApplicationValue("classPropertyCache_#getClassFullname()#", metaProperties);
		}

		return getApplicationValue("classPropertyCache_#getClassFullname()#");
	}

	private struct function convertStructToLowerCase(required struct st){
		var aKeys = structKeyArray(arguments.st);
        var stN = structNew();
        var i= 0;
        var ai= 0;
        for(i in aKeys){
        	 if (isStruct(st[i])){
        		stN['#lCase(i)#'] = convertStructToLower(st[i]);
        	}else if (isArray(st[i])){
        		for(var ai = 1; ai < arraylen(st[i]); ai++){
        			if (isStruct(st[i][ai])){
        				st[i][ai] = convertStructToLower(st[i][ai]);
        			}else{
        				st[i][ai] = st[i][ai];
        			}
        		}
                stN['#lcase(i)#'] = st[i];
        	}else{
        		stN['#lcase(i)#'] = st[i];
        	}
        }

        return stn;
	}

	public struct function getPropertiesStruct() {
		if( !getHibachiScope().hasApplicationValue("classPropertyStructCache_#getClassFullname()#") ) {
			var propertiesStruct = {};
			var properties = getProperties();

			for(var i=1; i<=arrayLen(properties); i++) {
				propertiesStruct[ properties[i].name ] = properties[ i ];
			}
			setApplicationValue("classPropertyStructCache_#getClassFullname()#", propertiesStruct);
		}

		return getApplicationValue("classPropertyStructCache_#getClassFullname()#");
	}

	// @help private method only used by populate
	private void function _setProperty( required any name, any value, any formatType='' ) {

		// If a value was passed in, set it
		if( structKeyExists(arguments, 'value') ) {
			// Defined the setter method
			var theMethod = this["set" & arguments.name];

			// Call Setter
			theMethod(arguments.value);
		} else {
			// Remove the key from variables, represents setting as NULL for persistent entities
			structDelete(variables, arguments.name);
		}
	}

	// ====================  END: APPLICATION CACHED META VALUES ====================================
	// ========================= START: DELIGATION HELPERS ==========================================
	
	public void function addCheckpoint(string description="", string tags, string blockName, any object) {
		
		// If no object provided, use this component
		if (!structKeyExists(arguments, 'object')) {
			arguments.object = this;
		}
		
		// If no blockName provided, use the component filename by default
		if (!structKeyExists(arguments, 'blockName')) {
			arguments.blockName = listLast(getThisMetaData().path, '/') & '###getIdentityHashCode()#';
		}
		
		super.addCheckpoint(argumentCollection=arguments);
	}

	// @hint helper function to pass this entity along with a template to the string replace function
	public string function stringReplace( required string template, boolean formatValues=false, boolean removeMissingKeys=false, string templateContextPathList ) {
		
		arguments['object'] = this; 
		
		return getService("hibachiUtilityService").replaceStringTemplate(argumentCollection=arguments);
	}
}
