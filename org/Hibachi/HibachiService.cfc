<cfcomponent accessors="true" extends="HibachiObject">
	
	<!--- Import all of the Hibachi services and DAO's --->
	<cfproperty name="hibachiDAO" type="any">
	<cfproperty name="hibachiAuthenticationService" type="any">
	<cfproperty name="hibachiEventService" type="any">
	<cfproperty name="hibachiRBService" type="any">
	<cfproperty name="hibachiSessionService" type="any">
	<cfproperty name="hibachiTagService" type="any">
	<cfproperty name="hibachiUtilityService" type="any">
	<cfproperty name="hibachiValidationService" type="any">
	
	<!--- Variables Scope Used For Caching --->
	<cfset variables.entitiesMetaData = {} />
	<cfset variables.entitiesProcessContexts = {} />
	<cfset variables.entityORMMetaDataObjects = {} />
	<cfset variables.entityObjects = {} />
	<cfset variables.entityHasProperty = {} />
	<cfset variables.entityHasAttribute = {} />
	
	<cfscript>
		public any function get(required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
			return getHibachiDAO().get(argumentcollection=arguments);
		}
	
		public any function getSmartList(string entityName, struct data={}){
			var smartList = getHibachiDAO().getSmartList(argumentcollection=arguments);
			
			if(structKeyExists(arguments.data, "keyword") || structKeyExists(arguments.data, "keywords")) {
				var example = this.new(arguments.entityName);
				smartList.addKeywordProperty(propertyIdentifier=example.getSimpleRepresentationPropertyName(), weight=1);
			}
			
			return smartList;
		}
		
		public any function list(required string entityName, struct filterCriteria = {}, string sortOrder = '', struct options = {} ) {
			return getHibachiDAO().list(argumentcollection=arguments);
		}
	
		public any function new(required string entityName ) {
			return getHibachiDAO().new(argumentcollection=arguments);
		}
	
		public any function count(required string entityName ) {
			return getHibachiDAO().count(argumentcollection=arguments);
		}
		
		public boolean function delete(required any entity){
			
			// Announce Before Event
			getHibachiEventService().announceEvent("before#arguments.entity.getClassName()#Delete", arguments);
			
			// Do delete validation
			arguments.entity.validate(context="delete");
			
			// If the entity Passes validation
			if(!arguments.entity.hasErrors()) {
				
				// Remove any Many-to-Many relationships
				arguments.entity.removeAllManyToManyRelationships();
				
				// Call delete in the DAO
				getHibachiDAO().delete(target=arguments.entity);
				
				// Announce After Events for Success
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Delete", arguments);
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#DeleteSuccess", arguments);
				
				// Return that the delete was sucessful
				return true;
				
			}
			
			// Announce After Events for Failure
			getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Delete", arguments);
			getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#DeleteFailure", arguments);
			
			return false;
		}
		
		
		// @hint default process method
		public any function process(required any entity, struct data={}, string processContext=""){
			
			// Create the invoke arguments struct
			var invokeArguments = {};
			invokeArguments[ "data" ] = arguments.data;
			invokeArguments[ lcase(arguments.entity.getClassName()) ] = arguments.entity;
			invokeArguments.entity = arguments.entity;
			
			// Announce the processContext specific  event
			getHibachiEventService().announceEvent("before#arguments.entity.getClassName()#Process_#arguments.processContext#", invokeArguments);
			
			// Verify the preProcess
			arguments.entity.validate( context=arguments.processContext );
			
			// If we pass preProcess validation then we can try to setup the processObject if the entity has one, and validate that
			if(!arguments.entity.hasErrors() && arguments.entity.hasProcessObject(arguments.processContext)) {
				
				invokeArguments[ "processObject" ] = arguments.entity.getProcessObject(arguments.processContext);
				
				if(!invokeArguments[ "processObject" ].getPopulatedFlag()) {
					invokeArguments[ "processObject" ].populate( arguments.data );
					invokeArguments[ "processObject" ].setPopulatedFlag( true );
					if(structKeyExists(arguments.data, arguments.entity.getClassName()) && isStruct(arguments.data[arguments.entity.getClassName()])) {
						arguments.entity.populate(arguments.data[arguments.entity.getClassName()]);
						invokeArguments[ "processObject" ].addPopulatedSubProperty( arguments.entity.getClassName(), arguments.entity );
					}
				}
				
				invokeArguments[ "processObject" ].validate( context=arguments.processContext );
				
			}
			
			// if the entity still has no errors then we call call the process method
			if(!arguments.entity.hasErrors()) {
				var methodName = "process#arguments.entity.getClassName()#_#arguments.processContext#";
				arguments.entity = this.invokeMethod(methodName, invokeArguments);
				if(isNull(arguments.entity)) {
					throw("You have created a process method: #methodName# that does not return an entity.  All process methods should return an entity.");
				}
			}	

			// Announce the after events
			getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Process_#arguments.processContext#", invokeArguments);
			if(arguments.entity.hasErrors()) {
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Process_#arguments.processContext#Failure", invokeArguments);
			} else {
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Process_#arguments.processContext#Success", invokeArguments);
			}

			return arguments.entity;
		}
		
		// @hint the default save method will populate, validate, and if not errors delegate to the DAO where entitySave() is called.
	    public any function save(required any entity, struct data, string context="save") {
	    	
	    	if(!isObject(arguments.entity) || !arguments.entity.isPersistent()) {
	    		throw("The entity being passed to this service is not a persistent entity. READ THIS!!!! -> Make sure that you aren't calling the oMM method with named arguments. Also, make sure to check the spelling of your 'fieldname' attributes.");
	    	}
	    	
	    	// Announce Before Event
	    	getHibachiEventService().announceEvent("before#arguments.entity.getClassName()#Save", arguments);
	    	
			// If data was passed in to this method then populate it with the new data
	        if(structKeyExists(arguments,"data")){
	        	
	        	// Populate this object
				arguments.entity.populate(argumentCollection=arguments);
	
	        }
	        
	        // Validate this object now that it has been populated
			arguments.entity.validate(context=arguments.context);
	        
	        // If the object passed validation then call save in the DAO, otherwise set the errors flag
	        if(!arguments.entity.hasErrors()) {
	            arguments.entity = getHibachiDAO().save(target=arguments.entity);
	            
	            // Announce After Events for Success
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Save", arguments);
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#SaveSuccess", arguments);
	        } else {
	            
	            // Announce After Events for Failure
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Save", arguments);
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#SaveFailure", arguments);
	        }
	        
	        // Return the entity
	        return arguments.entity;
	    }
	    
		/**
		* exports the given query/array to file.
		* 
		* @param data      Data to export. (Required) (Currently only supports query).
		* @param columns      list of columns to export. (optional, default: all)
		* @param columnNames      list of column headers to export. (optional, default: none)
		* @param fileName      file name for export. (default: uuid)
		* @param fileType      file type for export. (default: csv)
		*/
		public void function export(required any data, string columns, string columnNames, string fileName, string fileType = 'csv') {
			if(!structKeyExists(arguments,"fileName")){
				arguments.fileName = createUUID() ;
			}
			var fileNameWithExt = arguments.fileName & "." & arguments.fileType ;
			var filePath = getVirtualFileSystemPath() & "/" & fileNameWithExt ;
			if(isQuery(data) && !structKeyExists(arguments,"columns")){
				arguments.columns = arguments.data.columnList;
			}
			if(structKeyExists(arguments,"columns") && !structKeyExists(arguments,"columnNames")){
				arguments.columnNames = arguments.columns;
			}
			var columnArray = listToArray(arguments.columns);
			var columnCount = arrayLen(columnArray);
			
			if(arguments.fileType == 'csv'){
				var dataArray=[arguments.columnNames];
				for(var i=1; i <= data.recordcount; i++){
					var row = [];
					for(var j=1; j <= columnCount; j++){
						arrayAppend(row,'"#data[columnArray[j]][i]#"');
					}
					arrayAppend(dataArray,arrayToList(row));
				}
				var outputData = arrayToList(dataArray,"#chr(13)##chr(10)#");
				fileWrite(filePath,outputData);
			} else {
				throw("Implement export for fileType #arguments.fileType#");
			}
	
			// Open / Download File
			getHibachiUtilityService().downloadFile(fileNameWithExt,filePath,"application/#arguments.fileType#",true);
		}
			
			    
	 	/**
		 * Generic ORM CRUD methods and dynamic methods by convention via onMissingMethod.
		 *
		 * See all onMissing* method comments and other method signatures for usage.
		 *
		 * CREDIT:
		 *   Heavily influenced by ColdSpring 2.0-pre-alpha's coldspring.orm.hibernate.AbstractGateway.
	 	 *   So, thank you Mark Mandel and Bob Silverberg :)
		 *
		 * Provides dynamic methods, by convention, on missing method:
		 *
		 *   newXXX()
		 *
		 *   countXXX()
		 *
		 *   saveXXX( required any xxxEntity )
		 *
		 *   deleteXXX( required any xxxEntity )
		 *
		 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYYANDZZZ( required array [yyyFilterValue,zzzFilterValue], boolean isReturnNewOnNotFound = false )
		 *		AND here is case sensetive to avoid matching in property name i.e brAND
		 *
		 *   listXXX( struct filterCriteria, string sortOrder, struct options )
		 *
		 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
		 *
		 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
		 *
		 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
		 *
		 *	 exportXXX()
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		*/
		public any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ) {
			var lCaseMissingMethodName = lCase( missingMethodName );
	
			if ( lCaseMissingMethodName.startsWith( 'get' ) ) {
				if(right(lCaseMissingMethodName,9) == "smartlist") {
					return onMissingGetSmartListMethod( missingMethodName, missingMethodArguments );
				} else {
					return onMissingGetMethod( missingMethodName, missingMethodArguments );
				}
			} else if ( lCaseMissingMethodName.startsWith( 'new' ) ) {
				return onMissingNewMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'list' ) ) {
				return onMissingListMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'save' ) ) {
				return onMissingSaveMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'delete' ) )	{
				return onMissingDeleteMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'count' ) ) {
				return onMissingCountMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'export' ) ) {
				return onMissingExportMethod( missingMethodName, missingMethodArguments );
			} else if ( lCaseMissingMethodName.startsWith( 'process' ) ) {
				return onMissingProcessMethod( missingMethodName, missingMethodArguments );
			}

			throw('You have called a method #arguments.missingMethodName#() which does not exists in the #getClassName()# entity.');
		}
		
	
	
		/********** PRIVATE ************************************************************/
		private function onMissingDeleteMethod( required string missingMethodName, required struct missingMethodArguments ) {
			return delete( missingMethodArguments[ 1 ] );
		}
	
	
		/**
		 * Provides dynamic get methods, by convention, on missing method:
		 *
		 *   getXXX( required any ID, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYY( required any yyyFilterValue, boolean isReturnNewOnNotFound = false )
		 *
		 *   getXXXByYYYAndZZZ( required array [yyyFilterValue,zzzFilterValue], boolean isReturnNewOnNotFound = false )
		 *		AND here is case sensetive to avoid matching in property name i.e brAND
		 *
		 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingGetMethod( required string missingMethodName, required struct missingMethodArguments ){
			var isReturnNewOnNotFound = structKeyExists( missingMethodArguments, '2' ) ? missingMethodArguments[ 2 ] : false;
	
			var entityName = missingMethodName.substring( 3 );
	
			if ( entityName.matches( '(?i).+by.+' ) ) {
				var tokens = entityName.split( '(?i)by', 2 );
				entityName = tokens[ 1 ];
				if( tokens[ 2 ].matches( '.+AND.+' ) ) {
					tokens = tokens[ 2 ].split( 'AND' );
					var filter = {};
					for(var i = 1; i <= arrayLen(tokens); i++) {
						filter[ tokens[ i ] ] = missingMethodArguments[ 1 ][ i ];
					}
					return get( entityName, filter, isReturnNewOnNotFound );
				} else {
					var filter = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };
					return get( entityName, filter, isReturnNewOnNotFound );
				}
			} else {
				var id = missingMethodArguments[ 1 ];
				return get( entityName, id, isReturnNewOnNotFound );
			}
		}
	
		/**
		 * Provides dynamic getSmarList method, by convention, on missing method:
		 *
		 *   getXXXSmartList( struct data )
		 *
		 * ...in which XXX is an ORM entity name
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		 
		private function onMissingGetSmartListMethod( required string missingMethodName, required struct missingMethodArguments ){
			var smartListArgs = {};
			var entityNameLength = len(arguments.missingMethodName) - 12;
			
			var entityName = missingMethodName.substring( 3,entityNameLength + 3 );
			var data = {};
			if( structCount(missingMethodArguments) && !isNull(missingMethodArguments[ 1 ]) && isStruct(missingMethodArguments[ 1 ]) ) {
				data = missingMethodArguments[ 1 ];
			}
			
			return getSmartList(entityName=entityName, data=data);
		} 
		 
	
		/**
		 * Provides dynamic list methods, by convention, on missing method:
		 *
		 *   listXXX( struct filterCriteria, string sortOrder, struct options )
		 *
		 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
		 *
		 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
		 *
		 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListMethod( required string missingMethodName, required struct missingMethodArguments ){
			var listMethodForm = 'listXXX';
	
			if ( findNoCase( 'FilterBy', missingMethodName ) ) {
				listMethodForm &= 'FilterByYYY';
			}
	
			if ( findNoCase( 'OrderBy', missingMethodName ) ) {
				listMethodForm &= 'OrderByZZZ';
			}
	
			switch( listMethodForm ) {
				case 'listXXX':
					return onMissingListXXXMethod( missingMethodName, missingMethodArguments );
	
				case 'listXXXFilterByYYY':
					return onMissingListXXXFilterByYYYMethod( missingMethodName, missingMethodArguments );
	
				case 'listXXXOrderByZZZ':
					return onMissingListXXXOrderByZZZMethod( missingMethodName, missingMethodArguments );
	
				case 'listXXXFilterByYYYOrderByZZZ':
					return onMissingListXXXFilterByYYYOrderByZZZMethod( missingMethodName, missingMethodArguments );
			}
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXX( struct filterCriteria, string sortOrder, struct options )
		 *
		 * ...in which XXX is an ORM entity name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXMethod( required string missingMethodName, required struct missingMethodArguments ) {
			var listArgs = {};
	
			listArgs.entityName = missingMethodName.substring( 4 );
			
			if ( structKeyExists( missingMethodArguments, '1' ) ) {
				listArgs.filterCriteria = missingMethodArguments[ '1' ];
	
				if ( structKeyExists( missingMethodArguments, '2' ) ) {
					listArgs.sortOrder = missingMethodArguments[ '2' ];
	
					if ( structKeyExists( missingMethodArguments, '3' ) ) {
						listArgs.options = missingMethodArguments[ '3' ];
					}
				}
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXXFilterByYYY( required any yyyFilterValue, string sortOrder, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY is an entity property name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXFilterByYYYMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var listArgs = {};
	
			var temp = missingMethodName.substring( 4 );
	
			var tokens = temp.split( '(?i)FilterBy', 2 );
	
			listArgs.entityName = tokens[ 1 ];
	
			listArgs.filterCriteria = { '#tokens[ 2 ]#' = missingMethodArguments[ 1 ] };
	
			if ( structKeyExists( missingMethodArguments, '2' ) )
			{
				listArgs.sortOrder = missingMethodArguments[ '2' ];
	
				if ( structKeyExists( missingMethodArguments, '3' ) )
				{
					listArgs.options = missingMethodArguments[ '3' ];
				}
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXXFilterByYYYOrderByZZZ( required any yyyFilterValue, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and YYY and ZZZ are entity property names.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXFilterByYYYOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var listArgs = {};
	
			var temp = missingMethodName.substring( 4 );
	
			var tokens = temp.split( '(?i)FilterBy', 2 );
	
			listArgs.entityName = tokens[ 1 ];
	
			tokens = tokens[ 2 ].split( '(?i)OrderBy', 2 );
	
			listArgs.filterCriteria = { '#tokens[ 1 ]#' = missingMethodArguments[ 1 ] };
	
			listArgs.sortOrder = tokens[ 2 ];
	
			if ( structKeyExists( missingMethodArguments, '2' ) )
			{
				listArgs.options = missingMethodArguments[ '2' ];
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic list method, by convention, on missing method:
		 *
		 *   listXXXOrderByZZZ( struct filterCriteria, struct options )
		 *
		 * ...in which XXX is an ORM entity name, and ZZZ is an entity property name.
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		private function onMissingListXXXOrderByZZZMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var listArgs = {};
	
			var temp = missingMethodName.substring( 4 );
	
			var tokens = temp.split( '(?i)OrderBy', 2 );
	
			listArgs.entityName = tokens[ 1 ];
	
			listArgs.sortOrder = tokens[ 2 ];
	
			if ( structKeyExists( missingMethodArguments, '1' ) )
			{
				listArgs.filterCriteria = missingMethodArguments[ '1' ];
	
				if ( structKeyExists( missingMethodArguments, '2' ) )
				{
					listArgs.options = missingMethodArguments[ '2' ];
				}
			}
	
			return list( argumentCollection = listArgs );
		}
	
	
		/**
		 * Provides dynamic count methods, by convention, on missing method:
		 *
		 *   countXXX()
		 *
		 * ...in which XXX is an ORM entity name.
		 */
		private function onMissingCountMethod( required string missingMethodName, required struct missingMethodArguments ){
			var entityName = missingMethodName.substring( 5 );
	
			return count( entityName );
		}
	
	
		private function onMissingNewMethod( required string missingMethodName, required struct missingMethodArguments )
		{
			var entityName = missingMethodName.substring( 3 );
	
			return new( entityName );
		}
	
	
		private function onMissingSaveMethod( required string missingMethodName, required struct missingMethodArguments ) {
			if ( structKeyExists( missingMethodArguments, '3' ) ) {
				return save( entity=missingMethodArguments[1], data=missingMethodArguments[2], context=missingMethodArguments[3]);
			} else if ( structKeyExists( missingMethodArguments, '2' ) ) {
				return save( entity=missingMethodArguments[1], data=missingMethodArguments[2]);
			} else {
				return save( entity=missingMethodArguments[1] );
			}
		}
		
		private function onMissingProcessMethod( required string missingMethodName, required struct missingMethodArguments ) {
			if ( structKeyExists( missingMethodArguments, '3' ) ) {
				return process( entity=missingMethodArguments[1], data=missingMethodArguments[2], processContext=missingMethodArguments[3]);
			} else if ( structKeyExists( missingMethodArguments, '2' ) ) {
				return process( entity=missingMethodArguments[1], processContext=missingMethodArguments[2]);
			}
		}
		
		/**
		 * Provides dynamic export methods, by convention, on missing method:
		 *
		 *   exportXXX()
		 *
		 * ...in which XXX is an ORM entity name.
		 */
		private function onMissingExportMethod( required string missingMethodName, required struct missingMethodArguments ){
			var entityMeta = getMetaData(getEntityObject( missingMethodName.substring( 6 ) ));
			var exportQry = getHibachiDAO().getExportQuery(tableName = entityMeta.table);
			
			export(data=exportQry);
		}
		
		// @hint returns the correct service on a given entityName.  This is very useful for creating abstract code
		public boolean function getEntityNameIsValidFlag( required string entityName ) {
			
			// Use the short version of the entityName
			if(len(getProperlyCasedShortEntityName(arguments.entityName, true))){
				return true;
			}
			
			return false;
		}
		
		// @hint returns the correct service on a given entityName.  This is very useful for creating abstract code
		public any function getServiceByEntityName( required string entityName ) {
			
			// Use the short version of the entityName
			arguments.entityName = getProperlyCasedShortEntityName(arguments.entityName);
			
			if(structKeyExists(getEntitiesMetaData(), arguments.entityName) && structKeyExists(getEntitiesMetaData()[arguments.entityName], "hb_serviceName")) {
				return getService( getEntitiesMetaData()[ arguments.entityName ].hb_serviceName );
			}
			
			// By default just return the base hibachi service
			return getService("hibachiService");
		}
		
		// ======================= START: Entity Name Helper Methods ==============================
		
		public string function getProperlyCasedShortEntityName( required string entityName, boolean returnBlankIfNotFound=false ) {
			if(left(arguments.entityName, len(getApplicationValue('applicationKey'))) == getApplicationValue('applicationKey')) {
				arguments.entityName = right(arguments.entityName, len(arguments.entityName)-len(getApplicationValue('applicationKey')));
			}
			
			if( structKeyExists(getEntitiesMetaData(), arguments.entityName) ) {
				var keyList = structKeyList(getEntitiesMetaData());
				var keyIndex = listFindNoCase(keyList, arguments.entityName);
				return listGetAt(keyList, keyIndex);
			}
			
			if(arguments.returnBlankIfNotFound) {
				return "";
			}
			
			throw("The entity name that you have requested: #arguments.entityname# is not in the ORM Library of entity names that is setup in coldsrping.  Please add #arguments.entityname# to the list of entity mappings in coldspring.");
		}
		
		public string function getProperlyCasedFullEntityName( required string entityName ) {
			return "#getApplicationValue('applicationKey')##getProperlyCasedShortEntityName( arguments.entityName )#";
		}
		
		public string function getProperlyCasedFullClassNameByEntityName( required string entityName ) {
			return "#getApplicationValue('applicationKey')#.model.entity.#getProperlyCasedShortEntityName( arguments.entityName )#";
		}
		
		// =======================  END: Entity Name Helper Methods ===============================
		
		// ===================== START: Cached Entity Meta Data Methods ===========================
		
		public any function getEntitiesMetaData() {
			if(!structCount(variables.entitiesMetaData)) {
				var entityDirectoryArray = directoryList(expandPath('/#getApplicationValue('applicationKey')#/model/entity'));
				for(var e=1; e<=arrayLen(entityDirectoryArray); e++) {
					if(listLast(entityDirectoryArray[e], '.') eq 'cfc') {
						var entityShortName = listFirst(listLast(replace(entityDirectoryArray[e], '\', '/', 'all'), '/'), '.');
						var entityMetaData = createObject('component', '#getApplicationValue('applicationKey')#.model.entity.#entityShortName#').getThisMetaData();
						
						if(structKeyExists(entityMetaData, "persistent") && entityMetaData.persistent) {
							 variables.entitiesMetaData[ entityShortName ] = entityMetaData;
						}
					}
				}
			}
			
			return variables.entitiesMetaData;
		}
		
		public any function getEntityMetaData( required string entityName ) {
			return getEntitiesMetaData()[ getProperlyCasedShortEntityName( arguments.entityName ) ];
		}
		
		// @hint returns the entity meta data object that is used by a lot of the helper methods below
		public any function getEntityORMMetaDataObject( required string entityName ) {
			
			arguments.entityName = getProperlyCasedFullEntityName( arguments.entityName );
			
			if(!structKeyExists(variables.entityORMMetaDataObjects, arguments.entityName)) {
				variables.entityORMMetaDataObjects[ arguments.entityName ] = ormGetSessionFactory().getClassMetadata( arguments.entityName );
			}
			
			return variables.entityORMMetaDataObjects[ arguments.entityName ];
		}
		
		// @hint returns the metaData struct for an entity
		public any function getEntityObject( required string entityName ) {
			
			arguments.entityName = getProperlyCasedFullEntityName( arguments.entityName );
			
			if(!structKeyExists(variables.entityObjects, arguments.entityName)) {
				variables.entityObjects[ arguments.entityName ] = entityNew(arguments.entityName);
			}
			
			return variables.entityObjects[ arguments.entityName ];
		}
		
		// @hint returns the properties of a given entity
		public any function getPropertiesByEntityName( required string entityName ) {
			
			// First Check the application cache
			if( hasApplicationValue("classPropertyCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#") ) {
				return getApplicationValue("classPropertyCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#");
			}
			
			// Pull the meta data from the object (which in turn will cache it in the application for the next time)
			return getEntityObject( arguments.entityName ).getProperties();
		}
		
		// @hint returns the properties of a given entity
		public any function getPropertiesStructByEntityName( required string entityName ) {
			// Pull the meta data from the object (which in turn will cache it in the application for the next time)
			return getEntityObject( arguments.entityName ).getPropertiesStruct(); 
		}
		
		// @hint returns a property of a given entity
		public any function getPropertyByEntityNameAndPropertyName( required string entityName, required string propertyName ) {
			return getPropertiesStructByEntityName( entityName=arguments.entityName )[ arguments.propertyName ]; 
		}
		
		/*
		public any function getEntitiesProcessContexts() {
			if(!structKeyExists(variables, "entitiesProcessContexts")) {
				var processContexts = {};
				var emd = getEntitiesMetaData();
				
				for(var entityName in emd) {
					if(structKeyExists(emd[ entityName ], "hb_processContexts")) {
						processContexts[ entityName ] = listToArray(emd[ entityName ].hb_processContexts);
					}
				}
				
				variables.entitiesProcessContexts = processContexts;
			}
			return variables.entitiesProcessContexts;
		}
		*/
		
		// =====================  END: Cached Entity Meta Data Methods ============================
		
		
		// ============================== START: Logical Methods ==================================
		
		// @hint returns an array of ID columns based on the entityName
		public array function getIdentifierColumnNamesByEntityName( required string entityName ) {
			return getEntityORMMetaDataObject( arguments.entityName ).getIdentifierColumnNames();
		}
		
		// @hint returns the primary id property name of a given entityName
		public string function getPrimaryIDPropertyNameByEntityName( required string entityName ) {
			var idColumnNames = getIdentifierColumnNamesByEntityName( arguments.entityName );
			
			if( arrayLen(idColumnNames)) {
				var shortEntityName = getProperlyCasedShortEntityName(arguments.entityName);
				shortEntityName = lcase(shortEntityName.charAt(0)) & shortEntityName.subString(1);
				return replaceNoCase(replaceNoCase(idColumnNames[1],shortEntityName,shortEntityName),"code","Code");
			}
		}
		
		// @hint returns true or false based on an entityName, and checks if that property exists for that entity 
		public boolean function getEntityHasPropertyByEntityName( required string entityName, required string propertyName ) {
			return structKeyExists(getPropertiesStructByEntityName(arguments.entityName), arguments.propertyName );
		}
		
		// @hint leverages the getEntityHasPropertyByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
		public boolean function getHasPropertyByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			try {
				return getEntityHasPropertyByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), propertyName=listLast(arguments.propertyIdentifier, "._") );	
			} catch(any e) {
				return false;	
			}
		}
		
		// @hint traverses a propertyIdentifier to find the last entityName in the list... this is then used by the hasProperty and hasAttribute methods()
		public string function getLastEntityNameInPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			if(listLen(arguments.propertyIdentifier, "._") gt 1) {
				var propertiesSruct = getPropertiesStructByEntityName( arguments.entityName );
				if( !structKeyExists(propertiesSruct, listFirst(arguments.propertyIdentifier, "._")) || !structKeyExists(propertiesSruct[listFirst(arguments.propertyIdentifier, "._")], "cfc") ) {
					throw("The Property Identifier #arguments.propertyIdentifier# is invalid for the entity #arguments.entityName#");
				}
				return getLastEntityNameInPropertyIdentifier( entityName=listLast(propertiesSruct[listFirst(arguments.propertyIdentifier, "._")].cfc, "."), propertyIdentifier=right(arguments.propertyIdentifier, len(arguments.propertyIdentifier)-(len(listFirst(arguments.propertyIdentifier, "._"))+1)));	
			}
			
			return arguments.entityName;
		}
		
			
		public any function getTableTopSortOrder(required string tableName, string contextIDColumn, string contextIDValue) {
			return getHibachiDAO().getTableTopSortOrder(argumentcollection=arguments);
		}
	
		public any function updateRecordSortOrder(required string recordIDColumn, required string recordID, required string entityName, required numeric newSortOrder) {
			var entityMetaData = getEntityMetaData( arguments.entityName );
			arguments.tableName = entityMetaData.table;
			getHibachiDAO().updateRecordSortOrder(argumentcollection=arguments);
		}
		
	</cfscript>
</cfcomponent>
