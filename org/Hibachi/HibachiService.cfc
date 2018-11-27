<cfcomponent accessors="true" output="false" extends="HibachiObject">
	
	<!--- Import all of the Hibachi services and DAO's --->
	<cfproperty name="hibachiDAO" type="any">
	<cfproperty name="hibachiAuthenticationService" type="any">
	<cfproperty name="hibachiCacheService" type="any">
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
	<cfset variables.processComponentDirectoryListing = [] />
	
	<cfscript>
		public any function get(required string entityName, required any idOrFilter, boolean isReturnNewOnNotFound = false ) {
			return getHibachiDAO().get(argumentcollection=arguments);
		}
		
		public any function getParentPropertyByEntityName(required string entityName){
			return getEntitiesMetaData()[ getProperlyCasedShortEntityName( arguments.entityName ) ].hb_parentPropertyName;
		}
		
		public any function getParentPropertyByEntityNameAndPropertyIdentifier(required string entityName, required string propertyIdentifier){
			var lastEntityName = attributes.hibachiScope.getService('HibachiService').getLastEntityNameInPropertyIdentifier(
				attributes.entityName,
				attributes.propertyIdentifier
			);
			
			var propertyMetaData = attributes.hibachiScope.getService('HibachiService').getPropertiesStructByEntityName(
				lastEntityName
			)[listLast(attributes.propertyIdentifier, ".")];
			return propertyMetaData.hb_parentPropertyName;
		}
		
		public string function getSimpleRepresentationPropertyNameByEntityName(required string entityName){
			var example = this.new(arguments.entityName);
			var simpleRepresentationPropertyName = example.getSimpleRepresentationPropertyName();
			return simpleRepresentationPropertyName;
		}
	
		public any function getSmartList(string entityName, struct data={}){
			var smartList = getHibachiDAO().getSmartList(argumentcollection=arguments);
			
			if(structKeyExists(arguments.data, "keyword") || structKeyExists(arguments.data, "keywords")) {
				var example = this.new(arguments.entityName);
				var simpleRepresentationPropertyName = example.getSimpleRepresentationPropertyName();
				var primaryIDPropertyName = example.getPrimaryIDPropertyName();
				var pmd = example.getPropertyMetaData( primaryIDPropertyName );
				if(!structKeyExists(pmd, "ormtype") || pmd.ormtype != 'integer') {
					smartList.addKeywordProperty(propertyIdentifier=primaryIDPropertyName, weight=1);	
				}
				if(simpleRepresentationPropertyName != primaryIDPropertyName) {
					smartList.addKeywordProperty(propertyIdentifier=simpleRepresentationPropertyName, weight=1);	
				}
			}
			
			return smartList;
		}
		
		public any function getCollectionList(string entityName, struct data={}){
		
			var collection = getService('hibachiCollectionService').newCollection(argumentcollection=arguments);
			var addDefaultColumns = true;
			if(structKeyExists(arguments.data, 'defaultColumns')){
				addDefaultColumns = arguments.data.defaultColumns;
			}
			collection.setCollectionObject(arguments.entityName,addDefaultColumns);
			return collection;
		}
		
		public any function getCollectionReportList(string entityName, struct data={}){
		
			var collection = getService('hibachiCollectionService').newCollection(argumentcollection=arguments);
			collection.setReportFlag(1);
			var addDefaultColumns = true;
			if(structKeyExists(arguments.data, 'defaultColumns')){
				addDefaultColumns = arguments.data.defaultColumns;
			}
			collection.setCollectionObject(arguments.entityName,addDefaultColumns);
			return collection;
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
			
			// Add the entity by it's name to the arguments for calling events
	    	arguments[ lcase(arguments.entity.getClassName()) ] = arguments.entity;
			
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
	    	
	    	// Add the entity by it's name to the arguments for calling events
	    	arguments[ lcase(arguments.entity.getClassName()) ] = arguments.entity;
	    	
	    	// Announce Before Event
	    	getHibachiEventService().announceEvent("before#arguments.entity.getClassName()#Save", arguments);
	    	
			// If data was passed in to this method then populate it with the new data
	        if(structKeyExists(arguments,"data")){
	        	
	        	// Populate this object
				arguments.entity.populate(argumentCollection=arguments);
	
	        }
	        
	        // Validate this object now that it has been populated
			arguments.entity.validate(context=arguments.context);
			//check if this is new before save - announcements will need this information later.
	        var isNew = arguments.entity.isNew();
	        
	        // If the object passed validation then call save in the DAO, otherwise set the errors flag
	        if(!arguments.entity.hasErrors()) {
	            arguments.entity = getHibachiDAO().save(target=arguments.entity);
        
                // Announce After Events for Success
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Save", arguments);
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#SaveSuccess", arguments);
				
				//If new need to announce the Create process as well as Success
				if (isNew){
					getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Create", arguments);
					getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#CreateSuccess", arguments);
				}
		    } else {
            
                // Announce After Events for Failure
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Save", arguments);
				getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#SaveFailure", arguments);
				
				//If new need to announce the Create Success
				if (isNew){
					getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#Create", arguments);
					getHibachiEventService().announceEvent("after#arguments.entity.getClassName()#CreateFailure", arguments);
				}
	        }

	        // Return the entity
	        return arguments.entity;
	    }
	    
	  /**
        * Exports the given query/array to file.
        * 
        * @param data Data to export. (Required) (Currently only supports query and array of structs).
        * @param columns List of columns to export. (optional, default: all)
        * @param columnNames List of column headers to export. (optional, default: none)
        * @param fileName File name for export. (default: uuid)
        * @param fileType File type for export. (default: csv)
        * This returns the path and filename of the exported file.
        */ 
         public any function export(required any data, string columns, string columnNames, string fileName, string fileType = 'csv', boolean downloadFile=true, folderPath) {

            if (isArray(data)){
                arguments.data = transformArrayOfStructsToQuery( data, ListToArray(ListRemoveDuplicates(columns)));
            }
	    
			var result = {};
			var supportedFileTypes = "csv,txt";
            if(!structKeyExists(arguments,"fileName")){
                arguments.fileName = createUUID() ;
            }
			if(!listFindNoCase(supportedFileTypes,arguments.fileType)){
				throw("File type not supported in export. Only supported file types are #supportedFileTypes#");
			}
            var fileNameWithExt = arguments.fileName & "." & arguments.fileType ;
				if(structKeyExists(arguments, "folderPath")){
					var filePath = arguments.folderPath & "/" & fileNameWithExt;
				} else if(structKeyExists(application,"tempDir")){
				var filePath = application.tempDir & "/" & fileNameWithExt;
			} else {
				var filePath = GetTempDirectory() & fileNameWithExt;
			}
            if(isQuery(data) && !structKeyExists(arguments,"columns")){
                arguments.columns = arguments.data.columnList;
            }
            if(structKeyExists(arguments,"columns") && !structKeyExists(arguments,"columnNames")){
                arguments.columnNames = arguments.columns;
            }
            var columnArray = listToArray(ListRemoveDuplicates(arguments.columns));
            var columnCount = arrayLen(columnArray);
            
            if(arguments.fileType == 'csv'){
				getHibachiUtilityService().queryToCsvFile(
					filePath = filePath,
					queryData = arguments.data,
					columnNames = columns,
					columnTitles = columnNames
				);
            }else{
				throw("Implement export for fileType #arguments.fileType#");
            }
            
			if(structKeyExists(arguments, "downloadFile") && arguments.downloadFile == true){
				getHibachiUtilityService().downloadFile(fileNameWithExt,filePath,"application/#arguments.fileType#",true);
			} else{
				result.fileName = fileNameWithExt;
				result.fileType = fileType;
				result.filePath = filePath;
				return result;
            }
        }

    /*
     * queryToCsv
     * Allows us to pass in a query object and returns that data as a CSV.
     * This is a refactor of Ben Nadel's method, http://www.bennadel.com/blog/1239-Updated-Converting-A-ColdFusion-Query-To-CSV-Using-QueryToCSV-.htm
     * @param  {Query}      q               {required}  The cf query object to convert. E.g. pass in: qry.execute().getResult();
     * @param  {Boolean}    hr              {required}  True if we should include a header row in our CSV, defaults to TRUE
     * @param  {String}     d               {required}  Delimiter to use in CSV, defaults to a comma (,)
     * @return {String}                                         CSV content
     */
    public string function queryToCsv(required query q, required boolean hr = true, required string d = ","){

        var colNames    = listToArray( lCase(arguments.q.columnlist) );
        var newLine     = (chr(13) & chr(10));
        var buffer      = CreateObject('java','java.lang.StringBuffer').Init();
        // Check if we should include a header row
        if(arguments.hr){
            // append our header row
            buffer.append(
              ArrayToList(colNames,arguments.d) & newLine
            );
        }
        // Loop over query and build csv rows
        for(var i=1; i <= arguments.q.recordcount; i=i+1){
            // this individual row
            var thisRow = [];
            // loop over column list
            for(var j=1; j <= arrayLen(colNames); j=j+1){
                // create our row
                thisRow[j] = replace( replace( arguments.q[colNames[j]][i],',','','all'),'""','""""','all' );
            }
            // Append new row to csv output
            buffer.append(
                JavaCast( 'string', ( ArrayToList( thisRow, arguments.d ) & iif(i < arguments.q.recordcount, "newLine","") ) )
            );
        }
        return buffer.toString();
    };
    
	public query function transformArrayOfStructsToQuery( required array arrayOfStructs, required array colNames ){
		var rowsTotal = ArrayLen(arrayOfStructs);
		var columnsTotal = ArrayLen(colNames); 
		if (rowsTotal < 1){return QueryNew("");}
		var columnNames = arguments.colNames;
		var newQuery = queryNew(arrayToList(columnNames), "VarChar"&repeatString(",VarChar", arraylen(columnNames)-1));
		queryAddRow(newQuery, rowsTotal);
		for (var i=1; i <= rowsTotal; i++){
			for(var n=1; n <= columnsTotal; n++){
				var column = nullReplace(columnNames[n], "");
				var value = "";
				//Fixes undefined values
				if (!StructKeyExists(arrayOfStructs[i], "#column#")){
					value = "";
				}else{
					value = arrayOfStructs[i][column];
				}
				querySetCell(newQuery, column, value, i);
			}
		}
		return newQuery;
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
				} else if(right(lCaseMissingMethodName,14) == "collectionlist"){
					return onMissingGetCollectionListMethod( missingMethodName, missingMethodArguments );
				} else if(right(lCaseMissingMethodName,6) == "struct"){
					return onMissingGetEntityStructMethod( missingMethodName, missingMethodArguments );
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

			throw('You have called a method #arguments.missingMethodName#() which does not exists in the #getClassName()# service.');
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
		 * Provides dynamic getCollection method, by convention, on missing method:
		 *
		 *   getXXXCollection( struct data )
		 *
		 * ...in which XXX is an ORM entity name
		 *
		 * NOTE: Ordered arguments only--named arguments not supported.
		 */
		 
		private function onMissingGetCollectionListMethod( required string missingMethodName, required struct missingMethodArguments ){
			var collectionArgs = {};
			var entityNameLength = len(arguments.missingMethodName) - 17;
			
			var entityName = missingMethodName.substring( 3,entityNameLength + 3 );
			var data = {};
			if( structCount(missingMethodArguments) && !isNull(missingMethodArguments[ 1 ]) && isStruct(missingMethodArguments[ 1 ]) ) {
				data = missingMethodArguments[ 1 ];
			}
			
			return getCollectionList(entityName=entityName, data=data);
		} 


		private function onMissingGetEntityStructMethod( required string missingMethodName, required struct missingMethodArguments ){
			var entityNameLength = len(arguments.missingMethodName) - 9;
			var entityName = missingMethodName.substring( 3,entityNameLength + 3 );
			var entityID = missingMethodArguments[ 1 ]; 
			
			var collection = getCollectionList(entityName=entityName); 
			collection.addFilter(getPrimaryIDPropertyNameByEntityName(entityName), entityID);
			collection.setPageRecordsShow(1);
			return collection.getPageRecords(formatRecords=false)[1];
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
				if(hasService(getEntitiesMetaData()[ arguments.entityName ].hb_serviceName)){
					return getService( getEntitiesMetaData()[ arguments.entityName ].hb_serviceName );
				}
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
			
			throw("The entity name that you have requested: '#arguments.entityname#' is not configured in ORM.");
		}
		
		public string function getProperlyCasedFullEntityName( required string entityName ) {
			return "#getApplicationValue('applicationKey')##getProperlyCasedShortEntityName( arguments.entityName )#";
		}
		
		public string function getProperlyCasedFullClassNameByEntityName( required string entityName ) {
			return "#getApplicationValue('applicationKey')#.model.entity.#getProperlyCasedShortEntityName( arguments.entityName )#";
		}

		public string function getProperlyCasedPropertyIdentifier( required string baseEntityName, required string propertyIdentifier ) {
			var currentPropertiesStruct = getPropertiesStructByEntityName(arguments.baseEntityName);
			var currentStructKeys = listToArray(StructKeyList(currentPropertiesStruct));
			var _propertyIdentifier = '';
			var propertyIdentifierParts = ListToArray(arguments.propertyIdentifier, '.');

			for (var i = 1; i <= arraylen(propertyIdentifierParts); i++) {
				if(i == 1 && propertyIdentifierParts[i] == '_'&lcase(arguments.baseEntityName)){
					_propertyIdentifier = listAppend(_propertyIdentifier, propertyIdentifierParts[i], '.');
					continue;
				}
				if(structKeyExists(currentPropertiesStruct, propertyIdentifierParts[i])){
					propertyIdentifierParts[i] = currentStructKeys[arrayFindNoCase(currentStructKeys, propertyIdentifierParts[i])];
					if(structKeyExists(currentPropertiesStruct[propertyIdentifierParts[i]], 'cfc')){
						arguments.baseEntityName = currentPropertiesStruct[propertyIdentifierParts[i]]['cfc'];
						currentPropertiesStruct = getService('hibachiService').getPropertiesStructByEntityName(arguments.baseEntityName);
						currentStructKeys = listToArray(StructKeyList(currentPropertiesStruct));
					}
				}else{
					logHibachi("The Property #propertyIdentifierParts[i]# is invalid for the entity #arguments.baseEntityName# on property Identifier: #arguments.propertyIdentifier#", true);
				}
				_propertyIdentifier = listAppend(_propertyIdentifier, propertyIdentifierParts[i], '.');
			}
			return _propertyIdentifier;
		}
		
		// =======================  END: Entity Name Helper Methods ===============================
		
		// ===================== START: Cached Entity Meta Data Methods ===========================
		
		public any function getEntitiesMetaData() {
			if(!structCount(variables.entitiesMetaData)) {
				var entityNamesArr = listToArray(structKeyList(ORMGetSessionFactory().getAllClassMetadata()));
				
				
				var allMD = {};
				for(var entityName in entityNamesArr) {
					var entity = entityNew(entityName);
					if(structKeyExists(entity, "getThisMetaData")) {
						var entityMetaData = entityNew(entityName).getThisMetaData();
						if(isStruct(entityMetaData) && structKeyExists(entityMetaData, "fullname")) {
							var entityShortName = listLast(entityMetaData.fullname, '.');
							allMD[ entityShortName ] = entityMetaData;
						}
					}
				}
				variables.entitiesMetaData = allMD;
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
		
		public any function getToManyPropertiesByEntityName(required string entityName){
			var cacheKey = 'toManyPropertiesBy#arguments.entityName#';
			if(!structKeyExists(variables,cacheKey)){
				var toManyProperties = [];
				var properties = getComponentMetaData(getBeanFactory().getBeanInfo( arguments.entityName ).cfc).properties;
				var propertyCount = arrayLen(properties);
				// Loop over all properties
				for(var i=1; i<=propertyCount; i++) {
					// Set any one-to-many or many-to-many properties with a blank array as the default value
					if(structKeyExists(properties[i], "fieldtype") && listFindNoCase("many-to-many,one-to-many", properties[i].fieldtype) && !structKeyExists(variables, properties[i].name) ) {
						arrayAppend(toManyProperties,properties[i].name);
					}
				}
				variables[cacheKey] = toManyProperties;
			}
			return variables[cacheKey];
			
		}
		
		public any function getPropertyIsPersistentByEntityNameAndPropertyIdentifier(required string entityName, required string propertyIdentifier){
			var cacheKey = 'getPropertyIsPersistentByEntityNameAndPropertyIdentifier'&arguments.entityName&arguments.propertyIdentifier;
			
			if(!structKeyExists(variables,cacheKey)){
				var propertyMetaData = getPropertiesStructByEntityName(
				getLastEntityNameInPropertyIdentifier(
						arguments.entityName,
						arguments.propertyIdentifier
					)	
				)[listLast(arguments.propertyIdentifier, ".")];
				variables[cacheKey] = !structKeyExists(propertyMetaData,'persistent') || propertyMetaData.persistent; 
			}
			
			
			return variables[cacheKey];
		}

		// @hint returns a property of a given entity
		public any function getPropertyByEntityNameAndPropertyName( required string entityName, required string propertyName ) {
			var hasAttributeByEntityNameAndPropertyIdentifier = getHasAttributeByEntityNameAndPropertyIdentifier(arguments.entityName, arguments.propertyName);
			if(!hasAttributeByEntityNameAndPropertyIdentifier){
				var propertiesStructByEntityName = getPropertiesStructByEntityName( entityName=arguments.entityName );
				if(structKeyExists(propertiesStructByEntityName,arguments.propertyName)){
					return propertiesStructByEntityName[ arguments.propertyName ];					
				}
			} else {
				var key = 'attributeService_getAttributeNameByAttributeCode_#arguments.propertyName#';
				if(getHibachiCacheService().hasCachedValue(key)) {
					return getHibachiCacheService().getCachedValue(key);
				}
			}
		}
		
		public any function getPropertyByEntityNameAndSingularName( required string entityName, required string singularName ) {
			var propertiesStruct = getPropertiesStructByEntityName( entityName=arguments.entityName );
			for(var key in propertiesStruct){
				var propertyStruct = propertiesStruct[key];
				
				if(isStruct(propertyStruct) && structKeyExists(propertyStruct,'singularname') && structKeyExists(arguments,'singularname') && lcase(propertyStruct.singularname) == lcase(arguments.singularName)){
					return propertyStruct;
				}
			}
		}
		
		public boolean function hasPropertyByEntityNameAndSingularName( required string entityName, required string singularName){
			return !isNull(getPropertyByEntityNameAndSingularName(arguments.entityName,arguments.singularName));
		}
		
		public string function getProcessComponentPath(){
	    	return getDao('hibachiDao').getApplicationValue('applicationKey')&'.model.process.';
	    }
	    
	    public array function getProcessComponentDirectoryListing(){
	    	if(!arrayLen(variables.processComponentDirectoryListing)){
	    		var processComponentPath = getProcessComponentPath();
		    	var processComponentDirectoryPath = expandPath('/'&getDao('hibachiDao').getApplicationKey()) & '/model/process';
		    	variables.processComponentDirectoryListing = directoryList(processComponentDirectoryPath,false,'name','*.cfc');
	    	}
	    	
	    	return variables.processComponentDirectoryListing;
	    }

		public struct function getEntitiesProcessContexts(){
			var serviceBeanInfo = getBeanFactory().getBeanInfo(regex="\w+Service").beanInfo;
			
			if(!structCount(variables.entitiesProcessContexts)) {
				//get processes form the services

				for(var beanName in serviceBeanInfo){
					var bean = getBeanFactory().getBean(beanName);
					var serviceMetaData = getMetaData(bean);
					var serviceFunctions = [];
					if(structKeyExists(serviceMetaData,'functions')){
						for(var functionItem in serviceMetaData.functions){
							arrayAppend(serviceFunctions, functionItem);
						}
					}

					if(listToArray(serviceMetaData.name,'.')[2]=='custom' && 
						structKeyExists(serviceMetaData,'extends') && 
						listLast(serviceMetaData.extends.name,'.') == beanName && 
						structKeyExists(serviceMetaData.extends, 'functions')){
						for(var functionItem in serviceMetaData.extends.functions){
							arrayAppend(serviceFunctions, functionItem);
						}
					}
					if(arrayLen(serviceFunctions)){
						for(var functionItem in serviceFunctions){
							if(
								(!structKeyExists(functionItem,'access') || functionItem.access == 'public')
								&& lcase(left(functionItem.name,7))=='process'
							){
								var processObjectName = mid(functionItem.name,8,len(functionItem.name));
				    			var entityName = listFirst(processObjectName,'_');
				    			var processName = listLast(processObjectName,"_");
				    			if(!structKeyExists(variables.entitiesProcessContexts,entityName)){
				    				variables.entitiesProcessContexts[entityName] = [];
				    			}
				    			if(!arrayFind(variables.entitiesProcessContexts[entityName],processName)){
									arrayAppend(variables.entitiesProcessContexts[entityName],processName);
				    			}
							}
						}
					}

				}
		    }
	    	return variables.entitiesProcessContexts;
	    }
		
		// =====================  END: Cached Entity Meta Data Methods ============================
		
		
		// ============================== START: Logical Methods ==================================
		
		// @hint returns an array of ID columns based on the entityName
		public array function getIdentifierColumnNamesByEntityName( required string entityName ) {
			return getEntityORMMetaDataObject( arguments.entityName ).getIdentifierColumnNames();
		}
		
		// @hint returns the primary id property name of a given entityName
		public string function getPrimaryIDPropertyNameByEntityName( required string entityName ) {
			arguments.entityName = getProperlyCasedShortEntityName(arguments.entityName);
			var cacheKey = 'getPrimaryIDPropertyNameByEntityName'&arguments.entityName;
			if(!structKeyExists(variables,cacheKey)){
				var propertiesStruct = getPropertiesStructByEntityName(arguments.entityName);
				for(var propertyKey in propertiesStruct){
					if(
						isStruct(propertiesStruct[propertyKey])
						&& structKeyExists(propertiesStruct[propertyKey],'fieldtype') 
						&& propertiesStruct[propertyKey].fieldtype=='id'
						&& structKeyExists(propertiesStruct[propertyKey],'name')
					){
						variables[cacheKey]=propertiesStruct[propertyKey]['name'];
						break;
					}
				}
			}
			return variables[cacheKey];
		}
		
		// @hint returns the primary id property name of a given entityName
		public string function getPrimaryIDColumnNameByEntityName( required string entityName ) {
			var cacheKey = 'getPrimaryIDColumnNameByEntityName'&arguments.entityName;
			
			if(!structKeyExists(variables,cacheKey)){
				var idColumnNames = getIdentifierColumnNamesByEntityName( arguments.entityName );
			
				if( arrayLen(idColumnNames)) {
					var shortEntityName = getProperlyCasedShortEntityName(arguments.entityName);
					shortEntityName = lcase(shortEntityName.charAt(0)) & shortEntityName.subString(1);
					variables[cacheKey] = replaceNoCase(replaceNoCase(idColumnNames[1],shortEntityName,shortEntityName),"code","Code");
				}
			}
			return variables[cacheKey];
		}

		
		// @hint returns true or false based on an entityName, and checks if that property exists for that entity 
		public boolean function getEntityHasPropertyByEntityName( required string entityName, required string propertyName ) {
			return structKeyExists(getPropertiesStructByEntityName(arguments.entityName), arguments.propertyName );
		}
		
		public boolean function getPropertyIsObjectByEntityNameAndPropertyIdentifier(required string entityName, required string propertyIdentifier, ignoreAttributeCheck=false){
		
			var cacheKey = 'getPropertyIsObjectByEntityNameAndPropertyIdentifier'&arguments.entityName&arguments.propertyIdentifier&arguments.ignoreAttributeCheck;
		
			if(!structKeyExists(variables,cacheKey)){
				var hasAttributeByEntityNameAndPropertyIdentifier=getHasAttributeByEntityNameAndPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier);
			
				if(!hasAttributeByEntityNameAndPropertyIdentifier || arguments.ignoreAttributeCheck){
					
					var lastEntityNameInPropertyIdentifier = getLastEntityNameInPropertyIdentifier(
						arguments.entityName, 
						arguments.propertyIdentifier
					);
					
					var propertiesStructByEntityName = getPropertiesStructByEntityName(
						lastEntityNameInPropertyIdentifier
					);
					
					var lastItemInPropertyIdentfier = listLast(arguments.propertyIdentifier, ".");
					
					
					variables[cacheKey] = structKeyExists(propertiesStructByEntityName,lastItemInPropertyIdentfier) && structKeyExists(
						propertiesStructByEntityName[lastItemInPropertyIdentfier],'cfc'
					);
				} else {
					variables[cacheKey] = false;
				}
			
			}
			return variables[cacheKey];
			
		}
		
		// @hint leverages the getEntityHasPropertyByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
		public boolean function getHasPropertyByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			var cacheKey = 'getHasPropertyByEntityNameAndPropertyIdentifier'&arguments.entityName&arguments.propertyIdentifier;
			
			if(!structKeyExists(variables,cacheKey)){
				try {
					variables[cacheKey] = getEntityHasPropertyByEntityName( entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), propertyName=listLast(arguments.propertyIdentifier, ".") );	
				} catch(any e) {
					variables[cacheKey] = false;	
				}
			}
			return variables[cacheKey];
		}
		
		
		// @hint traverses a propertyIdentifier to find the last entityName in the list... this is then used by the hasProperty and hasAttribute methods()
		public string function getLastEntityNameInPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			var cacheKey = 'getLastEntityNameInPropertyIdentifier'&arguments.entityName&arguments.propertyIdentifier;
			
			if(!structKeyExists(variables,cacheKey)){
				if(listLen(arguments.propertyIdentifier, ".") gt 1) {
					var propertiesSruct = getPropertiesStructByEntityName( arguments.entityName );
					if( !structKeyExists(propertiesSruct, listFirst(arguments.propertyIdentifier, ".")) || !structKeyExists(propertiesSruct[listFirst(arguments.propertyIdentifier, ".")], "cfc") ) {
						throw("The Property Identifier #arguments.propertyIdentifier# is invalid for the entity #arguments.entityName#");
					}
					return getLastEntityNameInPropertyIdentifier( entityName=listLast(propertiesSruct[listFirst(arguments.propertyIdentifier, ".")].cfc, "."), propertyIdentifier=right(arguments.propertyIdentifier, len(arguments.propertyIdentifier)-(len(listFirst(arguments.propertyIdentifier, "._"))+1)));	
				}
				variables[cacheKey] = arguments.entityName;
			}
			
			
			return variables[cacheKey];
		}
		
			
		public any function getTableTopSortOrder(required string tableName, string contextIDColumn, string contextIDValue) {
			return getHibachiDAO().getTableTopSortOrder(argumentcollection=arguments);
		}
		
		public string function getTableNameByEntityName(required string entityName){
			entityMetaData = getEntityMetaData( arguments.entityName );
			return entityMetaData.table; 
		}
	
		public any function updateRecordSortOrder(required string recordIDColumn, required string recordID, required string entityName, required numeric newSortOrder) {
			var entityMetaData = getEntityMetaData( arguments.entityName );
			arguments.tableName = entityMetaData.table;
			getHibachiDAO().updateRecordSortOrder(argumentcollection=arguments);
		}
		
		public boolean function getEntityHasCalculatedPropertiesByEntityName(required string entityName){
			var cacheKey = 'getEntityHasCalculatedPropertiesByEntityName#arguments.entityName#';
			
			if(structKeyExists(variables,cacheKey)){
				return variables[cacheKey];
			}
			
			if(!structKeyExists(variables,cacheKey)){
				var properties = getPropertiesByEntityName(arguments.entityName);
				for(var property in properties) {
			        // Look for any that start with the calculatedXXX naming convention
			         if (
			        	( left(property.name, 10) == "calculated" && ( !structKeyExists(property, "persistent") || property.persistent == "true" ) ) 
			        	||
			        	( structKeyExists(property, "hb_cascadeCalculate") && property.hb_cascadeCalculate ) 
			        ) {
			        	variables[cacheKey] = true;
			        	break;
			        }
				}
			}
			//if still not defined then cache as false
			if(!structKeyExists(variables,cacheKey)){
				variables[cacheKey] = false;
			}
			return variables[cacheKey];
			
			
		}
		
		// @hint leverages the getEntityHasAttributeByEntityName() by traverses a propertyIdentifier first using getLastEntityNameInPropertyIdentifier()
		public boolean function getHasAttributeByEntityNameAndPropertyIdentifier( required string entityName, required string propertyIdentifier ) {
			var cacheKey = 'getHasAttributeByEntityNameAndPropertyIdentifier'&arguments.entityName&arguments.propertyIdentifier;
			if(!structKeyExists(variables,cacheKey)){
				variables[cacheKey] = getEntityHasAttributeByEntityName( 
					entityName=getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier), 
					attributeCode=listLast(arguments.propertyIdentifier, "._") 
				);
			}
			
			return variables[cacheKey];
		}
		
		// @hint returns true or false based on an entityName, and checks if that entity has an extended attribute with that attributeCode
		public boolean function getEntityHasAttributeByEntityName( required string entityName, required string attributeCode ) {
			var attributeCodesList = getHibachiCacheService().getOrCacheFunctionValue("attributeService_getAttributeCodesListByAttributeSetType_ast#getProperlyCasedShortEntityName(arguments.entityName)#", "attributeService", "getAttributeCodesListByAttributeSetType", {1="ast#getProperlyCasedShortEntityName(arguments.entityName)#"});
			
			if(listFindNoCase(attributeCodesList, arguments.attributeCode)) {
				return true;
			}
			
			return false; 
		}		
		
		//used by the rest api to return default property values
		public any function getDefaultPropertiesByEntityName(required string entityName){
			// First Check the application cache
			if( hasApplicationValue("classDefaultPropertyCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#") ) {
				return getApplicationValue("classDefaultPropertyCache_#getProperlyCasedFullClassNameByEntityName( arguments.entityName )#");
			}
			
			// Pull the meta data from the object (which in turn will cache it in the application for the next time)
			return getEntityObject( arguments.entityName ).getDefaultCollectionProperties();
		}
		
		
		public array function getOptionsByEntityNameAndPropertyIdentifier(
			required any collectionList, required string entityName, required string propertyIdentifier, string inversePropertyIdentifier
		){
			var cacheKey = 'getOptionsByEntityNameAndPropertyIdentifier'&hash(serializeJson(arguments.collectionList.getCollectionConfigStruct()),'md5');
			cacheKey &=arguments.entityName&arguments.propertyIdentifier;
			if(structKeyExists(arguments,'inversePropertyIdentifier')){
				cacheKey&= arguments.inversePropertyIdentifier;
			}
			if(!structKeyExists(variables,cacheKey)){
				var entityCollectionList = getOptionsCollectionListByEntityNameAndPropertyIdentifier(argumentCollection=arguments);
				variables[cacheKey]={
					hql=entityCollectionList.getHQL(),
					params=entityCollectionList.getHQLParams()
				};
				
			}
			return ormExecuteQuery(variables[cacheKey].hql,variables[cacheKey].params);
		}
		
		public struct function getOptionsByEntityNameAndPropertyIdentifierAndDiscriminatorProperty(required any collectionList, required string entityName, required string propertyIdentifier, required string discriminatorProperty, required string inversePropertyIdentifier){
			var propertyMetaData = {};
			
			var lastEntityName = getLastEntityNameInPropertyIdentifier(arguments.entityName, arguments.propertyIdentifier & '.' & discriminatorProperty);
			var propsStruct = getPropertiesStructByEntityName(lastEntityName);
			var relatedEntity = arguments.discriminatorProperty;
			propertyMetaData = propsStruct[relatedEntity];
			var discriminatorRecords = getOptionsByEntityName(propertyMetaData.cfc);
			var primaryIDName = getPrimaryIDPropertyNameByEntityName(propertyMetaData.cfc);
			var optionData = {};
			var cacheKey = 'getOptionsByEntityNameAndPropertyIdentifierAndDiscriminatorProperty'&hash(serializeJson(arguments.collectionList.getCollectionConfigStruct()),'md5');
			cacheKey &=arguments.entityName&arguments.propertyIdentifier&arguments.discriminatorProperty&arguments.inversePropertyIdentifier;
			for(var record in discriminatorRecords){
				var recordCacheKey = cacheKey&record['value'];
				if(!structKeyExists(variables,recordCacheKey)){
					var optionsCollectionList = getOptionsCollectionListByEntityNameAndPropertyIdentifier(argumentCollection=arguments);
					optionsCollectionList.setInlistDelimiter(arguments.collectionList.getInlistDelimiter());
					optionsCollectionList.addFilter(arguments.propertyIdentifier&'.'&arguments.discriminatorProperty&'.#primaryIDName#',record['value']);
					optionsCollectionList.applyData(data=url,excludesList=arguments.propertyIdentifier);
					
					var cacheData = {
						hql= optionsCollectionList.getHQL(),
						params=optionsCollectionList.getHQLParams()
					};
					variables[recordCacheKey]=cacheData;
				}
				var optionsCollectionRecords = ormExecuteQuery(variables[recordCacheKey].hql,variables[recordCacheKey].params);
				
				
				optionData[record['name']] = optionsCollectionRecords;
			}
			
			return optionData;
			
		}
		
		private array function getOptionsByEntityName(required string entityName){
			return getOptionsCollectionListByEntityName(arguments.entityName).getRecords();
		}
		
		private any function getOptionsCollectionListByEntityName(required string entityName){
			
			var optionsCollectionList = this.getCollectionList(arguments.entityName);
			var primaryIDName = getPrimaryIDPropertyNameByEntityName(arguments.entityName);
			var simpleRepresentationName = getSimpleRepresentationPropertyNameByEntityName(arguments.entityName);
			var displayProperties = "";
			displayProperties = listAppend(displayProperties,primaryIDName&'|value');
			displayProperties = listAppend(displayProperties,simpleRepresentationName&'|name');
			optionsCollectionList.setDisplayProperties(displayProperties);
			optionsCollectionList.setOrderBy(simpleRepresentationName);
			optionsCollectionList.setApplyOrderBysToGroupBys(false);
			
			return optionsCollectionList;
		}
		
		
		
		public any function getOptionsCollectionListByEntityNameAndPropertyIdentifier(required any collectionList, required string entityName, required string propertyIdentifier, required string inversePropertyIdentifier){
			
			var entityCollectionList = this.invokeMethod('get#arguments.entityname#CollectionList');
			entityCollectionList.setInlistDelimiter(arguments.collectionList.getInlistDelimiter());
			
			var displayProperties = '';
			var propertyMetaData = {};
			var lastEntityName = getLastEntityNameInPropertyIdentifier(arguments.entityName,arguments.propertyIdentifier);
			var propsStruct = getPropertiesStructByEntityName(lastEntityName);
			var relatedEntity = listLast(arguments.propertyIdentifier,'.');
			propertyMetaData = propsStruct[relatedEntity];
			
			
			if(getPropertyIsObjectByEntityNameAndPropertyIdentifier(arguments.entityName,arguments.propertyIdentifier,true)){
				var primaryIDName = getPrimaryIDPropertyNameByEntityName(propertyMetaData.cfc);
				var simpleRepresentationName = getSimpleRepresentationPropertyNameByEntityName(propertyMetaData.cfc);
			}
			
			var displayProperties = "";
			if(structKeyExists(propertyMetaData,'fieldtype')){
				//applyfilters by inversePropertyIdentifier
				var entityMetaData = getEntityMetaData(propertyMetaData.cfc);
				if(structKeyExists(arguments.collectionList.getCollectionConfigStruct(),'filterGroups')){
					entityCollectionList.applyRelatedFilterGroups(arguments.inversePropertyIdentifier,duplicate(arguments.collectionList.getCollectionConfigStruct()['filterGroups']));
					entityCollectionList.removeFilter(arguments.propertyIdentifier&'.'&primaryIDName);
				}
				
				
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'.'&primaryIDName&'|value');
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'.'&simpleRepresentationName&'|name');
				if(structKeyExists(entityMetaData,'hb_parentPropertyName')){
					var primaryIDNamePath = '#primaryIDName#Path';
					displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'.'&primaryIDNamePath&'|IDPath');
				}
				
				switch(propertyMetaData.fieldtype){
					case 'many-to-one':
						break;
					case 'one-to-many':
						
						break;
					case 'many-to-many':
						break;
				}
				entityCollectionList.setDisplayProperties(displayProperties);
				var excludesList = arguments.propertyIdentifier&'.'&primaryIDName;
				//filter out bad data
				entityCollectionList.addFilter(arguments.propertyIdentifier&'.'&simpleRepresentationName,'NULL','IS NOT');
				entityCollectionList.addFilter(arguments.propertyIdentifier&'.'&simpleRepresentationName,' ','!=');
				entityCollectionList.addFilter(arguments.propertyIdentifier&'.'&simpleRepresentationName,'','!=');
				
				
				entityCollectionList.setDistinct(true);
				
				//entityCollectionList.addDisplayAggregate(getPrimaryIDPropertyNameByEntityName(entityCollectionList.getCollectionObject()),'Count','count',true);
				entityCollectionList.setOrderBy(arguments.propertyIdentifier&'.'&simpleRepresentationName);
				
			}else if(structKeyExists(propertyMetaData,'ormtype')) {
				
				if(structKeyExists(arguments.collectionList.getCollectionConfigStruct(),'filterGroups')){
					entityCollectionList.setCollectionConfigStruct(duplicate(arguments.collectionList.getCollectionConfigStruct()));
					entityCollectionList.removeFilter(arguments.propertyIdentifier);
				}
				
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'|value');
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'|name');
				switch(propertyMetaData.ormtype){
					case 'big_decimal':
						break;
					case 'string':
						break;
					case 'integer':
						break;
				}
				entityCollectionList.setDisplayProperties(displayProperties);
				entityCollectionList.setDistinct(true);
				var excludesList = arguments.propertyIdentifier;
				//filter out bad data
				entityCollectionList.addFilter(arguments.propertyIdentifier,'NULL','IS NOT');
				entityCollectionList.addFilter(arguments.propertyIdentifier,' ','!=');
				entityCollectionList.addFilter(arguments.propertyIdentifier,'','!=');
				entityCollectionList.setOrderBy(arguments.propertyIdentifier);
				
			}
			entityCollectionList.applyData(data=url,excludesList=excludesList);
			entityCollectionList.setDirtyReadFlag(true);
			entityCollectionList.setApplyOrderBysToGroupBys(false);
			
			
			return entityCollectionList;
		}
		
		public array function getOptionsByEntityNameAndPropertyIdentifierAndRangeData(required any collectionList, required string entityName, required string propertyIdentifier, required array rangeData){
			var options = [];
			var primaryIDName = getPrimaryIDPropertyNameByEntityName(arguments.entityName); 
			for(var range in rangeData){
				
				var option = {};
				option['name'] = "";
				option['value'] = "";
				
				if(structKeyExists(range,'minValue')){
					option['name'] &= range.minValue;
					option['value'] &= range.minValue;
				}
				option['name'] &= '-';
				option['value'] &= '^';
				if(structKeyExists(range,'maxValue')){
					option['name'] &= range.maxValue;
					option['value'] &= range.maxValue;
				}
				
				if(structKeyExists(range,'displayValue')){
					option['name'] = range['displayValue'];
				}
				
				var entityCollectionList = this.invokeMethod('get#arguments.entityname#CollectionList');
				
				if(structKeyExists(arguments.collectionList.getCollectionConfigStruct(),'filterGroups')){
					entityCollectionList.setCollectionConfigStruct(duplicate(arguments.collectionList.getCollectionConfigStruct()));
				}
				entityCollectionList.applyData(data=url,excludesList=arguments.propertyIdentifier);
				var filterGroupIndex = arraylen(entityCollectionList.getCollectionConfigStruct().filterGroups);
				entityCollectionList.setDisplayProperties('productID');
				entityCollectionList.removeFilter(propertyIdentifier=arguments.propertyIdentifier,filterGroupIndex=filterGroupIndex);
				if(structKeyExists(range,'minValue')){
					entityCollectionList.addFilter(arguments.propertyIdentifier,range.minValue,'>=');
				}
				if(structKeyExists(range,'maxValue')){
					entityCollectionList.addFilter(arguments.propertyIdentifier,range.maxValue,'<=');
				}
				//calling getRecords until getRecordsCount behaves correctly aka knowing when to group by
				
				//option['count'] = entityCollectionList.getRecordsCount();
				
				arrayAppend(options,option);
			}
			
			return options;
		}
		
		public string function getAttributeCacheKey(){
			var attributeCacheKey = '';
			var modelCacheKey = "attributeService_getAttributeModel_CacheKey";
			if(getService('HibachiCacheService').hasCachedValue(modelCacheKey)){
				attributeCacheKey = getService('HibachiCacheService').getCachedValue(modelCacheKey);
			}else if (hasService('attributeService')){
				var attributeMetaData = getService('attributeService').getAttributeModel();
				attributeCacheKey = hash(serializeJson(attributeMetaData),'MD5');
				getService('HibachiCacheService').setCachedValue(modelCacheKey,attributeCacheKey);
			}
			return attributeCacheKey;
		}
		
		public array function getSelectedOptionsByApplyData(required any collectionList, required string entityName, required string propertyIdentifier){
			var entityCollectionList = getService('HibachiService').getCollectionList(arguments.entityName);
			entityCollectionList.setDistinct(true);
			entityCollectionList.setInlistDelimiter(arguments.collectionList.getInlistDelimiter());
			var displayProperties = '';
			var propertyMetaData = {};
			var lastEntityName = getLastEntityNameInPropertyIdentifier(arguments.entityName,arguments.propertyIdentifier);
			var propsStruct = getPropertiesStructByEntityName(lastEntityName);
			var relatedEntity = listLast(arguments.propertyIdentifier,'.');
			propertyMetaData = propsStruct[relatedEntity];
			if(getPropertyIsObjectByEntityNameAndPropertyIdentifier(arguments.entityName,arguments.propertyIdentifier,true)){
				var primaryIDName = getPrimaryIDPropertyNameByEntityName(propertyMetaData.cfc);
				var simpleRepresentationName = getSimpleRepresentationPropertyNameByEntityName(propertyMetaData.cfc);
			}
			
			var displayProperties = "";
			if(structKeyExists(propertyMetaData,'fieldtype')){
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'.'&primaryIDName&'|value');
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'.'&simpleRepresentationName&'|name');
				switch(propertyMetaData.fieldtype){
					case 'many-to-one':
						break;
					case 'one-to-many':
						
						break;
					case 'many-to-many':
						break;
				}
				entityCollectionList.setDisplayProperties(displayProperties);
				entityCollectionList.setOrderBy(arguments.propertyIdentifier&'.'&simpleRepresentationName);
				
			}else if(structKeyExists(propertyMetaData,'ormtype')) {
				
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'|value');
				displayProperties = listAppend(displayProperties,arguments.propertyIdentifier&'|name');
				switch(propertyMetaData.ormtype){
					case 'big_decimal':
						break;
					case 'string':
						break;
					case 'integer':
						break;
				}
				entityCollectionList.setDisplayProperties(displayProperties);
				entityCollectionList.setOrderBy(arguments.propertyIdentifier);
			}
			entityCollectionList.applyData(data=url,excludesList=arguments.propertyIdentifier);
			return entityCollectionList.getRecords();
		}
		
		public void function updateCalculatedPropertiesByEntityName(required any entity){
			arguments.entity.updateCalculatedProperties(true);
		}
		
		public void function batchUpdateCalculatedPropertiesByEntityName(required struct rc){
			
			var entitySmartList = getHibachiScope().getService('HibachiService').invokeMethod('get#arguments.rc.entityName#SmartList');
			entitySmartList.addOrder('modifiedDateTime','ASC');
			
			//you can choose to do this in larger batches but you data better be valid boi
			entitySmartList.setPageRecordsShow(1);
			var currentPageCount = 1;
			var totalPages = entitySmartList.getTotalPages()-arguments.rc.totalPagesComplete;
			var entityService = getHibachiScope().getService('HibachiService').getServiceByEntityName( entityName=arguments.rc.entityName );
			logHibachi('#arguments.rc.entityName#',true);
			while(currentPageCount <= totalPages && currentPageCount < 250){
				
				
				entitySmartList.setCurrentPageDeclaration(currentPageCount);
				var recordsBatchToProcess = entitySmartList.getPageRecords(true);
				
				
				
				for(var entity in recordsBatchToProcess){
					var primaryIDValue = entity.getPrimaryIDValue();
					var threadName = 'runentity'&createUUID();
					thread name="#threadName#" 
						entityName="#arguments.rc.entityName#" 
						entityID="#primaryIDValue#" 
						currentPageCount="#currentPageCount#"
						totalPages="#totalPages#"
					{
						getHibachiScope().getService("HibachiTagService").cfsetting(requesttimeout="1200");
						try{
							logHibachi('currentPage:#attributes.currentPageCount# of #attributes.totalPages# for #attributes.entityName#',true);
							var entityService = getHibachiScope().getService('HibachiService').getServiceByEntityName( entityName=attributes.entityName );
							var entity = entityService.invokeMethod('get#attributes.entityName#',{1=attributes.entityID});
							entity.setModifiedDateTime(now());
					
							//entityService.invokeMethod('save#arguments.rc.entityName#',{1=entity});
							entitySave(entity);
							entity.updateCalculatedProperties(true);
							logHibachi('flushed',true);
							//commit batch
							ormFlush();
							
						}catch(any e){
							logHibachi('#attributes.entityID# - error #e.message#',true);
							throw(e);
						}
						
					}
					
				}
				if(currentPageCount % 150 == 0){
					threadJoin();
				}
				
				currentPageCount++;
			}
			if(currentPageCount < totalPages && arguments.rc.totalPagesComplete != 0 && arguments.rc.totalPagesComplete % 5000 >= 250 ){
				arguments.rc.totalPagesComplete += 250;
				this.batchUpdateCalculatedPropertiesByEntityName(arguments.rc);
			}else{
				arguments.rc.maxTotalPages = entitySmartList.getTotalPages();
			}
		}
		
		
	</cfscript>
</cfcomponent>
