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
component extends="Slatwall.integrationServices.BaseImporterService" persistent="false" accessors="true" output="false"{
	
	property name="erpOneIntegrationCFC";
	
	property name="hibachiTagService";
	property name="hibachiDataService";
	property name="hibachiCacheService";
	property name="hibachiUtilityService";
	
	property name="skuService";
	property name="typeService";
	property name="orderService";
	property name="addressService";
	
	
	public any function getIntegration(){
		if( !structKeyExists( variables, 'integration') ){
			variables.integration = this.getIntegrationByIntegrationPackage('erpone');
		}
		return variables.integration;
	}
	
	public struct function getAvailableSampleCsvFilesIndex(){
		return this.getImporterMappingService().getMappingNamesIndex();
	}
	
	public any function uploadCSVFile( required any data ){
		
		var importFilesUploadDirectory = this.getVirtualFileSystemPath() & '/importcsv/'; 

		try{
			var uploadData = FileUpload( importFilesUploadDirectory, "uploadFile", "text/csv", "makeunique");
		
			if ( !listFindNoCase("csv", uploadData.serverFileExt) ){
				this.getHibachiScope().showMessage("The uploaded file is not of type CSV.", "error");
			}
		   
			var uploadedFilePath = uploadData.serverdirectory & '/' & uploadData.serverfile;
			
			var result = this.getHibachiDataService().csvFileToQuery(
				'csvFilePath'           = uploadedFilePath,
				'useHeaderRowAsColumns' = true
			);
			 // Adding this check so it doesn't mess with the UI
			if( result.errors.len() <= 10 ){
				
				for( var error in result.errors ){
					this.getHibachiScope().addError( "line-#error.line#", "Invalid data at Line-#error.line#, #ArrayToList(error.record)#" );
				}
				
			} else {
				
				this.getHibachiScope().addError( "Errors in CSV", "CSV has invalid data at #result.errors.len()# lines" );
			}
			
			
			if( result.query.recordCount ){

				var batch = this.pushRecordsIntoImportQueue( data.mappingCode, result.query );
				
				if( batch.getEntityQueueItemsCount() == batch.getInitialEntityQueueItemsCount() ){
					this.getHibachiScope().showMessage("All #batch.getInitialEntityQueueItemsCount()# items has been pushed to import-queue Successfully", "success");
				} 
				else {
					this.getHibachiScope().showMessage("#batch.getEntityQueueItemsCount()# out of #batch.getInitialEntityQueueItemsCount()# items has been pushed to import-queue", "warning");
				}
			} 
			// if there's no record count in the query, then there were some issues in the parsing 
			else {
				this.getHibachiScope().showMessage("Nothing got imported", "warning");
				this.getHibachiScope().showErrorsAndMessages();
			}
			
			//delete uploaded file
			fileDelete( uploadedFilePath );
			
			if( !isNull(batch) ){
				return batch;
			}
		} 
		catch ( any e ){ 
			this.getHibachiUtilityService().logException( e );
			this.getHibachiScope().showMessage("An error occurred while uploading your file - " & e.Message, "error");
		}
		
	}
	
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return this.getErpOneIntegrationCFC().setting( argumentCollection=arguments );
	}
	
	
	
	
	
	
	public any function getGrantToken(){
		if( !this.getHibachiCacheService().hasCachedValue('grantToken') ){
			this.createAndSetGrantToken();
		}
		return this.getHibachiCacheService().getCachedValue('grantToken');
	}
	
	public any function getAccessToken(){
		if(!this.getHibachiCacheService().hasCachedValue('accessToken')){
			this.createAndSetAccessToken();
		}
		return this.getHibachiCacheService().getCachedValue('accessToken');
	}
	
	public any function createAndSetGrantToken(){
		this.logHibachi("ERPONE - called createAndSetGrantToken");

		var httpRequest = this.createHttpRequest('distone/rest/service/authorize/grant');
		
		// Authentication headers
		if(!this.setting("devMode")){
			httpRequest.addParam( type='formfield', name='client',  value= this.setting('prodClient'));
			httpRequest.addParam( type='formfield', name='company', value= this.setting("prodCompany"));
			httpRequest.addParam( type='formfield', name='username', value= this.setting("prodUsername"));
			httpRequest.addParam( type='formfield', name='password', value= this.setting("prodPassword"));
		}
		else{
			httpRequest.addParam( type='formfield', name='client', value= this.setting('devClient'));
			httpRequest.addParam( type='formfield', name='company', value= this.setting("devCompany"));
			httpRequest.addParam( type='formfield', name='username', value=this.setting("devUsername"));
			httpRequest.addParam( type='formfield', name='password', value=this.setting("devPassword"));
		}
		
		var rawRequest = httpRequest.send().getPrefix();
		
		try{
		
			if( !IsJson(rawRequest.fileContent) ){
				throw("createAndSetGrantToken: API response is not valid json | Status Code: #rawRequest.statuscode#");
			}
			
			var response = DeSerializeJson(rawRequest.fileContent);
			
			if(!structKeyExists(response, 'grant_token') ){
				throw("createAndSetGrantToken: No grant token exist in the API response");   
			}
			
			this.getHibachiCacheService().setCachedValue( 
				'grantToken', 
				response.grant_token, 
				DateAdd("n",60,now()) 
			);
			
		} catch ( any e ){
			this.getHibachiUtilityService().logException(e);
			rethrow;
		}
	}
	
	public any function createAndSetAccessToken(){
		this.logHibachi("ERPONE - called createAndSetAccessToken");

		var grantToken = this.getGrantToken();
		var httpRequest = this.createHttpRequest('distone/rest/service/authorize/access');
		
		// Authentication headers
		if( !this.setting("devMode") ){
			httpRequest.addParam( type='formfield', name='client', value= this.setting('prodClient'));
			httpRequest.addParam( type='formfield', name='company', value= this.setting("prodCompany"));
		} else {
			httpRequest.addParam( type='formfield', name='client', value= this.setting('devClient'));
			httpRequest.addParam( type='formfield', name='company', value= this.setting("devCompany"));
		}
		
		httpRequest.addParam( type='formfield', name='grant_token', value=grantToken );
		
		var rawRequest = httpRequest.send().getPrefix();
		
		try{
			
			if( !IsJson(rawRequest.fileContent) ){
				throw("createAndSetAccessToken: API response is not valid json");
			}
			
			var response = DeSerializeJson(rawRequest.fileContent);
			
			if(!structKeyExists(response, 'access_token') ){
				throw("createAndSetAccessToken: No access token exist in the API response");   
			}
			
			this.getHibachiCacheService().setCachedValue( 
				'accessToken', 
				response.access_token, 
				DateAdd("n",60,now()) 
			);
			
		} catch ( any e ){
			this.getHibachiUtilityService().logException(e);
			rethrow;
		}
	}
	
	public any function createHttpRequest(required string endPointUrl, string requestType="POST", string requestContentType="application/x-www-form-urlencoded"){
		if(!this.setting("devMode")){
			var requestURL = this.setting("prodGatewayURL") & arguments.endPointUrl;
		}
		else{
			var requestURL = this.setting("devGatewayURL") & arguments.endPointUrl;
		}
		var httpRequest = new http();
		httpRequest.setMethod(arguments.requestType);
		httpRequest.setCharset("utf-8");
		httpRequest.setUrl(requestURL);
		if(len(arguments.requestContentType)){
			httpRequest.addParam( type='header', name='Content-Type', value=arguments.requestContentType);
		}
		return httpRequest;
	}
	
	public any function callErpOneGetDataApi( required struct requestData, string endpoint="data/read" ){
	    
	    this.logHibachi("ERPONE:: called callErpOneGetDataApi endPoint: #arguments.endPoint#, requestData: #serializeJSON(arguments.requestData)#" );
	    
		this.getHibachiTagService().cfsetting(requesttimeout=100000);
		var httpRequest = this.createHttpRequest('distone/rest/service/'&arguments.endpoint);
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		
		for( var key in arguments.requestData ){
			httpRequest.addParam( type='formfield', name= key, value = arguments.requestData[key] );
		}
		var rawRequest = httpRequest.send().getPrefix();
		if( !IsJson(rawRequest.fileContent) ){
			throw("ERPONE - callErpOneGetDataApi: API response is not valid json for request: #Serializejson(arguments.requestData)# response: #rawRequest.fileContent#");
		}
			
		return DeSerializeJson(rawRequest.fileContent);
	}

	public any function callErpOneUpdateDataApi( required any requestData, string endpoint="create" ){
	    this.logHibachi("ERPONE:: called callErpOneUpdateDataApi endPoint: #arguments.endPoint#, requestData: #serializeJSON(arguments.requestData)#" );

		var httpRequest = this.createHttpRequest('distone/rest/service/data/'&arguments.endpoint,"POST","application/json; charset=UTF-8");
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		httpRequest.addParam(type="body", value=serializeJSON(requestData));
		var rawRequest = httpRequest.send().getPrefix();
		if( !IsJson(rawRequest.fileContent) ){
			throw("ERPONE - callErpOneUpdateDataApi: API response is not valid json for request: #Serializejson(arguments.requestData)# response: #rawRequest.fileContent#");
		}
		return DeSerializeJson(rawRequest.fileContent);
	}
	
	public any function debugDataApi( required struct requestData, string endpoint="data/read", string requestType = "POST" ){
	    
	    this.logHibachi("ERPONE:: called debugDataApi endPoint: #arguments.requestType# #arguments.endPoint#, requestData: #serializeJSON(arguments.requestData)#" );
	    
		this.getHibachiTagService().cfsetting(requesttimeout=100000);
		
		var queryString = '';
		var requestContentType = '';
		if(arguments.requestType == 'GET' && structKeyExists(arguments.requestData, 'query')){
			queryString  = '/?' & arguments.requestData.query;
		}
		
		if(arguments.requestType == 'POST'){
			
			if(arguments.endpoint == 'data/read'){
				requestContentType = 'application/x-www-form-urlencoded';
			}else{
				requestContentType = 'application/json; charset=UTF-8';
			}
		}
		
		var httpRequest = this.createHttpRequest('distone/rest/service/'&arguments.endpoint&queryString, arguments.requestType, requestContentType);
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		if(arguments.requestType == 'POST'){
			
			if(arguments.endpoint != 'data/read'){
				httpRequest.addParam( type='body', value = arguments.requestData.query );
			}else{
				for( var key in arguments.requestData ){
					httpRequest.addParam( type='formfield', name= key, value = arguments.requestData[key] );
				}
			}
		}
		var rawRequest = httpRequest.send().getPrefix();
		if( !IsJson(rawRequest.fileContent) ){
			return rawRequest;
		}
			
		return DeSerializeJson(rawRequest.fileContent);
	}
	
	
	
	
	
	
	public any function trackErpTableChanges( required string tableName, boolean enabled=true){
		this.getHibachiTagService().cfsetting(requesttimeout=100000);
	    var endPoint = 'distone/rest/service/change-tracker/update/?table=#arguments.tableName#&update=#arguments.enabled#';
	    var httpRequest = this.createHttpRequest( endpoint, "GET", "" );
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
	   
	    this.logHibachi("ERPONE:: called trackErpTableChanges httpRequest: #serializeJson(httpRequest)#" );

		return httpRequest.send().getPrefix().fileContent;
	}
	
	public any function getErpTableChangeTrackingStatus( required string tableName){
		var endPoint = 'distone/rest/service/change-tracker/details/?table=#arguments.tableName#';
	    var httpRequest = this.createHttpRequest( endpoint, "GET", "" );
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		
	    this.logHibachi("ERPONE:: called getErpTableChangeTrackingStatus httpRequest: #serializeJson(httpRequest)#" );

		return httpRequest.send().getPrefix().fileContent;
	}
	
	public string function dateTimeToISOString(required any dateTime ){
	    var fmt = SERVER.keyExists("lucee") ? "iso8601" : "iso" ;
	    return dateTimeFormat( arguments.dateTime, fmt );
	}
	
	public any function processIntegration_importChanges( required any processObject, struct data){
	    
	    this.logHibachi("ERPONE:: called processIntegration_importChanges :: Tracker: #arguments.processObject.getTracker()#, DateTimeSince: #arguments.processObject.getDateTimeSince()# " );
	    
	    if(arguments.processObject.getTracker() == 'accounts'){
	        return this.importErpOneAccountChanges(arguments.processObject.getDateTimeSince() );
	    }
	    
	    if(arguments.processObject.getTracker() == 'orders'){
	        return this.importErpOneOrderChanges(arguments.processObject.getDateTimeSince() );
	    }
	    
	    if(arguments.processObject.getTracker() == 'orderItems'){
	        return this.importErpOneOrderItemChanges(arguments.processObject.getDateTimeSince() );
	    }
	    
	    if(arguments.processObject.getTracker() == 'orderPayments'){
	        return this.importErpOneOrderPaymentChanges(arguments.processObject.getDateTimeSince() );
	    }
	    
	    if(arguments.processObject.getTracker() == 'orderDeliveries'){
	        return this.importErpOneOrderShipmentChanges(arguments.processObject.getDateTimeSince() );
	    }
        
	}
	
	public any function callErpOneGetChangesApi( 
	    required string tableName, 
	    required string columns,
	    required any  dateTimeSince, 
	    string  filter  = '', 
	    numeric skip    = 0, 
	    numeric take    = 500
	){

		this.getHibachiTagService().cfsetting(requesttimeout=100000);

	    this.logHibachi("ERPONE:: called callErpOneGetChangesApi tableName: #arguments.tableName#, columns: #arguments.columns#, since: #arguments.dateTimeSince#, filter: #arguments.filter#, skip: #arguments.skip#, take: #arguments.take# " );

	    var httpRequest = this.createHttpRequest( 'distone/rest/service/change-tracker/fetch/', "POST", "application/x-www-form-urlencoded; charset=UTF-8" );
        
        arguments.dateTimeSince = this.dateTimeToISOString( arguments.dateTimeSince );
        
        // Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		
		
		httpRequest.addParam( type='formfield', name= "columns", value = arguments.columns );
		httpRequest.addParam( type='formfield', name= "filter",  value = arguments.filter );
		httpRequest.addParam( type='formfield', name= "table",   value = arguments.tableName );
		httpRequest.addParam( type='formfield', name= "since",   value = arguments.dateTimeSince );
		httpRequest.addParam( type='formfield', name= "skip",    value = arguments.skip );
		httpRequest.addParam( type='formfield', name= "take",    value = arguments.take );
		
				
		var rawRequest = httpRequest.send().getPrefix();
		
		if( !IsJson(rawRequest.fileContent) ){
			throw("ERPONE - callErpOneGetChangesApi: API response is not valid json for request: #Serializejson(arguments)# response: #rawRequest.fileContent#");
		}
		return DeSerializeJson(rawRequest.fileContent);
	}
	
	
	
	
	
	
	public any function getLivePrices( required array requestData){
		
		var httpRequest = this.createHttpRequest('distone/rest/service/price/fetch', 'POST', 'application/json; charset=UTF-8');
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );

		httpRequest.addParam( type='body', value = serializeJSON(arguments.requestData));
			
		var rawRequest = httpRequest.send().getPrefix();
		if( !IsJson(rawRequest.fileContent) ){
			return rawRequest;
		}
			
		return DeSerializeJson(rawRequest.fileContent);
	}
	
	public any function getLiveListingPrices(required array data, required string skuCodeKey="skuCode", required string priceKeys="skuPrice" , string customerCode = ""){
		var pricePayload = [];
		for(var item in arguments.data){
			var priceData = { 
				'item': item[arguments.skuCodeKey], 
				'quantity' : 1, 
				'unit': 'EACH'
			};
			
			if(len(arguments.customerCode)){
				priceData['customer'] = customerCode;
			}
			arrayAppend(pricePayload, priceData);
		}
		var livePrices = getLivePrices(pricePayload);
		
		for(var item in arguments.data){
			
			for(var livePrice in livePrices){
				if(livePrice['item'] == item[arguments.skuCodeKey]){
					for(var priceKey in arguments.priceKeys){
						item[priceKey] = round(livePrice['price'],2);
					}
					break;
				}
			}
		}
		return arguments.data;
	}
	
	
	
	
	/**
	 * An utility function to import all of the items inline, and skip the entity-queue lifecycle;
	 * - Supposed to import sub-relations; like order-items/payments/deliveries;
	 * - it is gonn bail out as soon as it encounters the very first error
	 * will return a struct containing 2 arrays, `errors` and `importedItems`
	 * 
	*/
	public any function fetchAndImportInline(
	    required string erpOneQuery, 
	    required string columns, 
	    required struct mapping, 
	    required function recordFormatterFunction
	){
	    
	    // get all items
		var itemsArray = this.callErpOneGetDataApi({
			"query": arguments.erpOneQuery,
			"columns" : arguments.columns
		});
		
		var entityName = arguments.mapping.entityName;
	    var entityService = this.getHibachiService().getServiceByEntityName( entityName );
	    var primaryIDPropertyName = this.getHibachiService().getPrimaryIDPropertyNameByEntityName( entityName );
	    
	    this.logHibachi("ERPONE - Starting fetchAndImportInline- #entityName#-[#arguments.mapping.mappingCode#], Query: #arguments.erpOneQuery#, Columns: #arguments.columns#");

	    var result = {
	        data = {
    	        'source'        : {},
    	        'formatted'     : {},
    	        'transformed'   : {}
    	   },
          'errors' : {},
          'importedItems': [],
	    };
	    

		for( var i=1; i<= itemsArray.len(); i++ ){
		    
		    var thisItem = itemsArray[i];
		    var dataKey = entityName & '-' & i;
		    
		    result.data.source[ dataKey ] = thisItem;
		    
		    var formattedData = arguments.recordFormatterFunction(thisItem);
		    
            result.data.formatted[ dataKey ] = formattedData ?: "NULL";
            
		    if( isNull(formattedData) ){
		        this.logHibachi("ErpOneService:: fetchAndImportInline, skipping Item #SerializeJson(thisItem)# as the recordFormatterFunction returned NULL");
		        continue; // currently ignoring bad data
		    }
		    
	        // validate
	        var validation = this.validateMappingData( 
                data          = formattedData,
                mapping       = arguments.mapping,
                collectErrors = true
            );
            
            if(!validation.isValid){
                result.errors.append( validation.errors );
                break;
            }
            
            var transformedData = this.transformMappingData( 
    	        data           = formattedData,
    	        mapping        = arguments.mapping,
    	        emptyRelations = validation.emptyRelations
    	    );
    	    
            result.data.transformed[ dataKey ] = transformedData;
            
    	    // find or create a new entity
    	    var primaryIDValue = transformedData[primaryIDPropertyName];
    	    if( primaryIDValue.len() ){
			    // not passing the 2nd argument as true to return a new entity, so that it throws for bad entity-IDs;
			    var thisEntity = entityService.invokeMethod("get#entityName#", { 1=primaryIDValue} );
            } else {
                var thisEntity = entityService.invokeMethod("new#entityName#");
            }
            
	        // process
        	var processedEntity = this.processEntityImport( thisEntity, transformedData, arguments.mapping );
        	
        	if( processedEntity.hasErrors() ){
        	    result.errors.append( processedEntity.getErrors() );
                break;
        	}
        	
        	result.importedItems.append(processedEntity);
	    }
	    
        this.logHibachi("ERPONE - Finished fetchAndImportInline - Entity-#entityName#. Mapping-[#arguments.mapping.mappingCode#]");
	    
	    result['isNotSuccessful'] = !result.errors.isEmpty();
	    
	    return result;
	}
	

	/**
	 * An utility function to pagimant over an ERP-one API, and import all of the items in one batch;
	 * 
	*/
	public any function paginateAndImportToQueue(
	    required string erpOneQuery, 
	    required string columns, 
	    required struct mapping, 
	    required function recordFormatterFunction,
	    
	    numeric pageSize = 500
	){
	    
	    this.logHibachi("ERPONE - Starting paginating and importing - #arguments.mapping.entityName#-[#arguments.mapping.mappingCode#], Query: #arguments.erpOneQuery#, Columns: #arguments.columns#");
		
		var pageNumber = 1;
		var hasPages = true;
		var total = 0;
		
		// create a batch
		var thisBatch = this.createNewImportBatch(
	        mapping = arguments.mapping,
	        batchItemsCount = 0,
	        batchDescription = "ERPONE - Paginate and Import Batch - #arguments.mapping.entityName#-[#arguments.mapping.mappingCode#], PageSize-#arguments.pageSize# "
	    );
		
		// paginate
		while(hasPages){
			
			this.logHibachi("ERPONE - Paginating #pageNumber#");
			
			// get data
			var itemsArray = this.callErpOneGetDataApi({
				"skip" : ( pageNumber - 1 ) * arguments.pageSize,
				"take" : arguments.pageSize,
				"query": arguments.erpOneQuery,
				"columns" : arguments.columns
			});
			
			this.logHibachi("ERPONE - skip #( pageNumber - 1 ) * arguments.pageSize# | take: #arguments.pageSize# = Returned : #arrayLen(itemsArray)#");
			
			// call formatter function;
			var formatedItems = [] ;
			for(var thisItem in itemsArray){
			    var formatRecord = arguments.recordFormatterFunction(thisItem);
			    if(!isNull(formatRecord)){
			        formatedItems.append(formatRecord);
			    }
			}
			
			var formatedItemsLen = formatedItems.len();
            
			if( formatedItemsLen ){
    			this.pushRecordsIntoImportQueue( arguments.mapping.mappingCode, formatedItems, thisBatch );
    		}
    		
    		if( formatedItemsLen < arguments.pageSize){
				hasPages = false;
			}

			total += formatedItemsLen;
		    pageNumber++;
		}
		
		// set the 
		thisBatch.setInitialEntityQueueItemsCount( total );
		this.getHibachiEntityQueueService().saveBatch(thisBatch);

	    this.logHibachi("ERPONE - Finished paginating and importing - Entity-#arguments.mapping.entityName#. Mapping-[#arguments.mapping.mappingCode#]");
		
		return thisBatch;
	}
	
	public any function paginateAndImportChangesToQueue(
	    required string tableName, 
	    required string columns, 
	    required struct mapping, 
	    required string filter, 
	    required any dateTimeSince,
	    required function recordFormatterFunction,
	    
	    numeric pageSize = 500
	){
	    
	    this.logHibachi("ERPONE - Starting paginating and importing changes - #arguments.mapping.entityName#-[#arguments.mapping.mappingCode#], Table: #arguments.tableName#, Columns: #arguments.columns#, Filter: #arguments.filter#, Since: #arguments.dateTimeSince#");
		
		var pageNumber = 1;
		var hasPages = true;
		var total = 0;
		
		// create a batch
		var thisBatch = this.createNewImportBatch(
	        mapping = arguments.mapping,
	        batchItemsCount = 0,
	        batchDescription = "ERPONE - Paginate and Import Changes Batch - #arguments.mapping.entityName#-[#arguments.mapping.mappingCode#], PageSize-#arguments.pageSize# "
	    );
		
		// paginate
		while(hasPages){
			
			this.logHibachi("ERPONE - Paginating #pageNumber#");
			
			// get data
			var itemsArray = this.callErpOneGetChangesApi(
				"skip"          = ( pageNumber - 1 ) * arguments.pageSize,
				"take"          = arguments.pageSize,
				"filter"        = arguments.filter,
				"columns"       = arguments.columns,
				"tableName"     = arguments.tableName,
				"dateTimeSince" = arguments.dateTimeSince
			);
			
			this.logHibachi("ERPONE - skip #( pageNumber - 1 ) * arguments.pageSize# | take: #arguments.pageSize# = Returned : #arrayLen(itemsArray)#");
			
			// call formatter function;
			var formatedItems = [] ;
			for(var thisItem in itemsArray){
			    var formatRecord = arguments.recordFormatterFunction(thisItem);
			    if(!isNull(formatRecord)){
			        formatedItems.append(formatRecord);
			    }
			}
			
			var formatedItemsLen = formatedItems.len();
            
			if( formatedItemsLen ){
    			this.pushRecordsIntoImportQueue( arguments.mapping.mappingCode, formatedItems, thisBatch );
    		}
    		
    		if( formatedItemsLen < arguments.pageSize){
				hasPages = false;
			}

			total += formatedItemsLen;
		    pageNumber++;
		}
		
		// set the 
		thisBatch.setInitialEntityQueueItemsCount( total );
		this.getHibachiEntityQueueService().saveBatch(thisBatch);

	    this.logHibachi("ERPONE - Finished paginating and importing changes - Entity-#arguments.mapping.entityName#. Mapping-[#arguments.mapping.mappingCode#]");
		
		return thisBatch;
	}
	
	
	
	
	
	
	public any function importErpOneAccounts(){
		
		this.logHibachi("ERPONE - Starting importing importErpOneAccounts");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var getAccountsQueryString = 'FOR EACH customer WHERE customer.active = YES AND customer.company_cu = "#company#"';
		var columns = "name,country_code,email_address,phone,Active,company_cu,customer,tax_code,adr[1],adr[2],adr[3],adr[4],adr[5],state,postal_code";
	    var erpOneAccountMapping = this.getMappingByMappingCode('ErpOneAccountImport');
	    
	    var accountImportBatch = this.paginateAndImportToQueue( 
		    erpOneQuery             = getAccountsQueryString,
		    columns                 = columns,
		    mapping                 = erpOneAccountMapping,
		    recordFormatterFunction = erpOneAccountFormatterFunction,
		    pageSize                = 100
		);
		
		
		this.logHibachi("ERPONE - Finish importing Accounts");
		
		return accountImportBatch;
	}
	
	public any function importErpOneAccountChanges( any dateTimeSince = now() - 1 ){
	    
	    // first ask the ERP to calculate the changes
	    this.trackErpTableChanges('customer', true);
		
		this.logHibachi("ERPONE - Starting importing importErpOneAccountChanges");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var filter = 'customer.active = YES AND customer.company_cu = "#company#"';
		var columns = 'name,country_code,email_address,phone,Active,company_cu,customer,tax_code,adr[1],adr[2],adr[3],adr[4],adr[5],state,postal_code';
		var tableName = 'customer';
	    var erpOneAccountMapping = this.getMappingByMappingCode('ErpOneAccountImport');
	    
	    var accountImportBatch = this.paginateAndImportChangesToQueue( 
		    tableName               = tableName,
		    columns                 = columns,
		    mapping                 = erpOneAccountMapping,
		    filter                  = filter,
		    recordFormatterFunction = erpOneAccountFormatterFunction,
		    dateTimeSince           = arguments.dateTimeSince,
		    pageSize                = 100
		);
		
		
		this.logHibachi("ERPONE - Finish importing Account changes");
		
		return accountImportBatch;
	}
	
	public any function erpOneAccountFormatterFunction(required struct account){
	    
        if(isNull(arguments.account['customer'])){
            return; // can't import accounts not having `customer` value, as it's the remoteID
        }

        var formattedAccountData =  {
			"remoteAccountID" : arguments.account['customer'],
			"remoteAccountAddressID" : arguments.account['customer'],
			"remoteAddressID" : arguments.account['customer'],
			"firstName" : arguments.account['name'] ?: '',
			"lastName" : "",
			"companyName" : arguments.account['name'] ?: '',
			"phoneNumber" : arguments.account['phone'] ?: '',
			"companyCode" : arguments.account['customer'],
			"taxExemptFlag" : arguments.account['tax_code'] == 'EXEMPT',
			"organizationFlag" : true,
			"name"             : "Default address",
			"addressNickName"  : "Default",
			"streetAddress"    : arguments.account['adr_1'] ?: '',
			"street2Address" : "",
			"city" : arguments.account['adr_4'] ?: '',
			"stateCode" : arguments.account['state'] ?: '',
			"postalCode" : arguments.account['postal_code'] ?: '',
			"countryCode" : "US"
		};
		
		if(!isNull(arguments.account['email_address'])){
			formattedAccountData['email'] = arguments.account['email_address'];
		}

        var company =  this.setting("devMode") ? this.setting("devCompany") : this.setting("prodCompany");

		var syAccountsArray = this.callErpOneGetDataApi({
			"query": 'FOR EACH sy_contact WHERE sy_contact.company_sy = "#company#" AND sy_contact.contact_type = "customer" AND sy_contact.key1 = "'&arguments.account.customer&'"',
			"columns" : "First_Name,Last_Name,key1,key2,contact,cell,contact_type"
		});
		
		
		if(arrayLen(syAccountsArray)){
		    var syAccount = syAccountsArray[1];
		    
			formattedAccountData['remoteContactID'] = arguments.account.customer;
			
			if( !isNull(syAccount["First_Name"]) ){
				formattedAccountData["firstName"] = syAccount["First_Name"];
			}
			
			if( !isNull(syAccount["Last_Name"]) ){
				formattedAccountData["lastName"] = syAccount["Last_Name"];
			}
			
			if( 
			    ( isNull(formattedAccountData['phoneNumber']) || !len(formattedAccountData['phoneNumber']) )
			    && !isNull(syAccount["cell"])
			){
				formattedAccountData["phoneNumber"] = syAccount["cell"];
			}
		}
		
		return formattedAccountData;
    }


	
	/**
	 * 
	 * Order Import flow:
	 * 1- fetch order and add to queue
	 * 2- at the time of processing of the order pull order-items, order-shipments and order-payments, import inline
	 * 
	*/
	public any function importErpOneOrders(){
		
		this.logHibachi("ERPONE - Starting importing importErpOneOrders");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}


		var getOrdersQueryString = 'FOR EACH oe_head NO-LOCK WHERE company_oe = "#company#" AND rec_type = "O" ';
        var columns = [ 
            'order',
            'ord_ext', 
            'customer',
            
            'name',
            'adr',
            'email',
            'phone',
            'state',
            'postal_code',
            'country_code',
            
            'ship_via_code', // fulfimment
            'ord_class',
            
            'ord_date',
            'opn',
            'stat',
            'rec_seq',
            
            'cancel_date',

            'currency_code'
        ].toList();

	    var erpOneOrderMapping = this.getMappingByMappingCode('ErpOneOrderImport');
	    
		var orderImportBatch = this.paginateAndImportToQueue( 
		    erpOneQuery             = getOrdersQueryString,
		    columns                 = columns,
		    mapping                 = erpOneOrderMapping,
		    recordFormatterFunction = erpOneOrderFormatterFunction
		);
		
		return orderImportBatch;
	}
	
	public any function importErpOneOrderChanges( any dateTimeSince = now() - 1 ){
		
		// first ask the ERP to calculate the changes
	    this.trackErpTableChanges('oe_head', true);
		
		this.logHibachi("ERPONE - Starting importing importErpOneOrderChanges");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var tableName = 'oe_head';
		var filter = ' company_oe = "#company#" AND rec_type = "O" ';
		var columns = [ 
            'order',
            'ord_ext', 
            'customer',
            
            'name',
            'adr',
            'email',
            'phone',
            'state',
            'postal_code',
            'country_code',
            
            'ship_via_code', // fulfimment
            'ord_class',
            
            'ord_date',
            'opn',
            'stat',
            'rec_seq',
            
            'cancel_date',

            'currency_code'
        ].toList();

	    var erpOneOrderMapping = this.getMappingByMappingCode('ErpOneOrderImport');
	    
	    var ordersImportBatch = this.paginateAndImportChangesToQueue( 
		    tableName               = tableName,
		    columns                 = columns,
		    mapping                 = erpOneOrderMapping,
		    filter                  = filter,
		    recordFormatterFunction = erpOneOrderFormatterFunction,
		    dateTimeSince           = arguments.dateTimeSince
		);
		
		this.logHibachi("ERPONE - Finish importing Orders changes");
		
		return ordersImportBatch;
	}

	public any function erpOneOrderFormatterFunction(required struct erponeOrder){
    	
    	if(isNull(arguments.erponeOrder['order'])){
            return; // erp returns a lot of empty objects, need to filter those out
        }
    	
	    if(left(arguments.erponeOrder['order'], 1) == '-'){
	        return; // if it's not a complete order
	    }
	     
	    var formattedOrderData =  {
			'currencyCode' : arguments.erponeOrder['currency_code'] ?: 'USD',
			//'EstimatedDeliveryDateTime' : ,
			//'OrderCloseDateTime' : ,
			//'OrderIPAddress' : ,
			//'OrderNotes' : ,
			'remoteOrderID'     : arguments.erponeOrder['order'],
			'remoteAccountID'   : arguments.erponeOrder['customer'],
			'orderOpenDateTime' : arguments.erponeOrder['ord_date']
		};
		
		
		if( !isNUll(arguments.erponeOrder['ord_ext']) && len( arguments.erponeOrder['ord_ext'] ) ){
		    
		    // set the remoteID on Slatwall's order, orderItems and order-fulfillment
		    this.updateSlatwallOrdrRemoteIDsWithERPOrder( arguments.erponeOrder['ord_ext'], arguments.erponeOrder['order'] );
		    
		    formattedOrderData['orderNumber']             = arguments.erponeOrder['ord_ext']; // slatwall's order number
            formattedOrderData['orderSiteCode']           = "stoneAndBerg"; // make-sure the site is created with this code
		    formattedOrderData['remoteOrderOriginName']   = "Web";
            
		} else {
            
            formattedOrderData['remoteOrderOriginName']   = "ERP"; 
		    formattedOrderData['orderNumber'] = arguments.erponeOrder['order'];
		    
		}

		// status
		if( !isNull( arguments.erponeOrder['cancel_date'] ) ){
		    arguments.erponeOrder['stat']  = "canceled";
		    formattedOrderData['canceledDateTime'] = arguments.erponeOrder['cancel_date'];
		}
		
        formattedOrderData['orderTypeCode']      = "otSalesOrder";
        formattedOrderData['orderStatusCode']    = 'ostNew'; // The order-status get's updated at the end of the `processOrderImport()`
		formattedOrderData['erpOrderStatusCode'] = arguments.erponeOrder['stat']; // carying forward this data to processOrderImport
    
		// Set billing and shipping addresses
	    var address = {
			'streetAddress'     : arguments.erponeOrder['adr'][1],
			'street2Address'    : arguments.erponeOrder['adr'][2] & " " & arguments.erponeOrder['adr'][3],
			'city'              : arguments.erponeOrder['adr'][4],
			'postalCode'        : arguments.erponeOrder['postal_code'],
			'stateCode'         : arguments.erponeOrder['state'],
			'countryCode'       : 'US',
			'email'             : arguments.erponeOrder['email'],
			'phoneNumber'       : arguments.erponeOrder['phone']
	    }
	    
	    address["name"] =  this.getAddressService().getAddressName(address);
	    
		var utilityService = this.getHibachiUtilityService();

	    var billingAddress = utilityService.prefixStructKeys(address, 'billingAddress_');
	    billingAddress['billingAddress_addressNickName'] = "Billing Address" & address["name"];
	    billingAddress['billingAddress_remoteAddressID'] = 'billing_'&arguments.erponeOrder['order'];
	    
	    var shippingAddress = utilityService.prefixStructKeys(address, 'shippingAddress_');
	    shippingAddress['shippingAddress_addressNickName'] = "Billing Address" & address["name"];
	    shippingAddress['shippingAddress_remoteAddressID'] = 'shipping_'&arguments.erponeOrder['order'];
			
		formattedOrderData.append(billingAddress);
		formattedOrderData.append(shippingAddress);
		
		return formattedOrderData;
	}

	public array function generateERPOneOrderOrderFulfillments( struct data,  struct mapping,  struct propertyMetaData ){
	    
	    // ERP does not have a concept of fulfillemnts, so we're creating a default fulfillment to support Slatwall's functionality;
	    var remoteID = this.getSlatwallOrderFulfillmentRemoteIDByErpOneOrderNo(arguments.data.remoteOrderID);
	    
	    // try to find the previous one in case, the order is getting re-imported
	    var orderFulfillmentID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        "entityName"  = 'OrderFulfillment',
	        "uniqueKey"   = 'remoteID',
	        "uniqueValue" = remoteID
	    );
	    
	    var fulfillmentMethodID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        "entityName"  = 'FulfillmentMethod',
	        "uniqueKey"   = 'fulfillmentMethodName',
	        "uniqueValue" = 'Freight' // this default FulfillmentMethod is `Freight` 
	    );
	    
	    var shippingMethodID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        "entityName"  = 'ShippingMethod',
	        "uniqueKey"   = 'shippingMethodCode',
	        "uniqueValue" = 'erpOneShippingMethod' // this default ShippingMethod is `erpOneShippingMethod` 
	    );
	    
	    var fulfillment = { 
	        "remoteID"				   : remoteID,
            "currencyCode"			   : arguments.data.currencyCode,
	        "orderFulfillmentID"       : orderFulfillmentID ?: '',
            "fulfillmentMethod"        : {
            	"fulfillmentMethodID"  : fulfillmentMethodID 
            },
            "shippingMethod" : {
                'shippingMethodID' : shippingMethodID
            }
	    };
    	
    	// TODO:
        // "handlingFee" ?? // not known 
        // statusCode    ?? // not known
    	
		fulfillment['shippingAddress'] = this.getHibachiUtilityService().getSubStructByKeyPrefix(arguments.data, 'shippingAddress_');
		
	    return [ fulfillment ];
    }

	public any function updateSlatwallOrdrRemoteIDsWithERPOrder(required any slatwallOrderNumber, required any remoteOrderID ){
	    this.logHibachi("called updateSlatwallOrdrRemoteIDsWithERPOrder, slatwallOrderNumbe: #slatwallOrderNumber#, remoteOrderID: #remoteOrderID#" );
	    // make the import-remote-id, so the importer can find the same order
	    var orderImportRemoteID = this.createMappingImportRemoteID( 
	        data    = { "remoteOrderID": arguments.remoteOrderID }, 
	        mapping = this.getMappingByMappingCode('ErpOneOrderImport')
	    );


        /*      this query does not work
        
                UPDATE swOrder 
    	        SET remoteID = xxx
    	        WHERE orderNumber = 78 AND remoteID IS NULL
                
                
                
                but this does [strange...., I've even tried manually setting the remoteID to NULL ]
                
                UPDATE swOrder 
    	        SET remoteID = xxx
    	        WHERE orderNumber = 78 
        */
	    // Slatwall's order
	    QueryExecute( 
	        sql = "
    	        UPDATE swOrder 
    	        SET remoteID = :remoteOrderID, importRemoteID = :orderImportRemoteID
    	        WHERE orderNumber = :slatwallOrderNumber
    	    ",
	        params = {
		        'remoteOrderID':       { 'type': 'string', 'value': arguments.remoteOrderID },
		        'slatwallOrderNumber':  { 'type': 'string', 'value': arguments.slatwallOrderNumber },
		        'orderImportRemoteID':  { 'type': 'string', 'value': orderImportRemoteID }
	        }
        );
        
        // Slatwall's fulfillment
        var fulfillmentRemoteID = this.getSlatwallOrderFulfillmentRemoteIDByErpOneOrderNo(arguments.remoteOrderID);
        QueryExecute( 
	        sql = "
	            UPDATE swOrderFulfillment f
	                INNER JOIN swOrder o
	                    ON f.orderID = o.orderID 
	                    AND o.orderNumber = :slatwallOrderNumber 
	            SET f.remoteID = :fulfillmentRemoteID
	        ",
	        params = {
		        'fulfillmentRemoteID': { 'type': 'string', 'value': fulfillmentRemoteID },
		        'slatwallOrderNumber': { 'type': 'string', 'value': arguments.slatwallOrderNumber },
	        }
        );
        
        // Slatwall's Order's order-items
        // the logic here needs to be consistent with `getSlatwallOrderItemRemoteID`
        QueryExecute( 
	        sql = "
	            UPDATE swOrderItem oi
                INNER JOIN swOrder o ON oi.orderID = o.orderID
                	AND o.orderNumber = :slatwallOrderNumber
                INNER JOIN swSku s ON oi.skuID = s.skuID
                
                SET oi.remoteID = CONCAT( o.remoteID , '_', s.remoteID ),
                oi.importRemoteID = LOWER( MD5( CONCAT( o.remoteID , '_', s.remoteID ) ) )
	        ",
	        params = {
		        'slatwallOrderNumber': { 'type': 'string', 'value': arguments.slatwallOrderNumber }
	        }
        );  
        
        //
        // no need to update the payment, as we only authorize in slatwall, and payment is captured in ERP.
        //
        // no need to update anything else, as that's the END of order lifecycle in Slatwall
        //
	}


    
    
    public any function processOrderImport( required any entity, required struct entityQueueData, struct mapping ){
	   
	    this.logHibachi("ERPONE - Starting processOrderImport - Mapping-[#arguments.mapping.mappingCode#]");

		var previousTransactionIsolation = ORMGetSession().connection().getTransactionIsolation();
	    var connection = ORMGetSession().connection().setTransactionIsolation( ORMGetSession().connection().TRANSACTION_READ_UNCOMMITTED );
	    
	    var thisOrmTransaction = ORMGetSession().beginTransaction(); 
        
        var order = this.genericProcessEntityImport(argumentCollection=arguments);
		this.getOrderService().saveOrder(order);
		
        try { 
    	    
    	    if(order.hasErrors()){
    	       throw "order has errors"; 
    	    }
    	    // to make order-id and changes available in the DB;
            this.getHibachiDAO().flushORMSession();
        
            arguments.entityQueueData["__debugData"] = {};
            
    		// order items
    		
            var result = this.importErpOneOrderItems(arguments.entityQueueData.remoteID, true);
            arguments.entityQueueData["__debugData"]['orderItems'] = result.data;

    		if(result.isNotSuccessful){
    		    order.addErrors(result.errors);
    		    throw "Got errors while trying to import order-items"& serializeJson(result.errors);
    		}
    		
    		for(var orderItem in result.importedItems){
    		    orderItem.setOrder(order);
    		    this.getOrderService().saveOrderItem(orderItem);
    		    if(orderItem.hasErrors() ){
    		        order.addErrors( orderItem.getErrors() );
        		    throw "Got errors while saving order-items" & serializeJson(orderItem.getErrors());
    		    }
    		}
    		
    		this.getOrderService().saveOrder(order);
    		if(order.hasErrors()){
    	       throw "invalid"; 
    	    }
    	    
            this.getHibachiDAO().flushORMSession();
    		
    		
    		// order deliveries
    		result = this.importErpOneOrderShipments(arguments.entityQueueData.remoteID, true);
            arguments.entityQueueData["__debugData"]['deliveries'] = result.data;
    		if(result.isNotSuccessful){
    		    order.addErrors(result.errors);
    		    throw "Got errors while trying to import order-deliveries"& serializeJson(result.errors);
    		}
    		
    		for(var orderDelivery in result.importedItems){
    		    orderDelivery.setOrder(order);
    		    this.getOrderService().saveOrderDelivery(orderDelivery);
    		    if(orderDelivery.hasErrors() ){
    		        order.addErrors( orderDelivery.getErrors() );
        		    throw "Got errors while saving order-delivery" & serializeJson(orderDelivery.getErrors());
    		    }
    		}
    		
    		this.getOrderService().saveOrder(order);
    		if(order.hasErrors()){
    	       throw "invalid"; 
    	    }
    	    
            this.getHibachiDAO().flushORMSession();
    		
    		
    	    // order payments
    	    
    		result = this.importErpOneOrderPayments(arguments.entityQueueData.remoteID, true);
            arguments.entityQueueData["__debugData"]['payments'] = result.data; 
            // TODO, figure-out a way to make it available in the UI, maybe add a column
    		if(result.isNotSuccessful){
    		    order.addErrors(result.errors);
    		    throw "Got errors while trying to import order-payments"& serializeJson(result.errors);
    		}
    		for(var orderPayment in result.importedItems){
    		    orderPayment.setOrder(order);
    		    
    		    // manually set a captured transaction amount
    		    var t = orderPayment.getPaymentTransactions()[1]; // there's only one transaction per payment
    		    t.setamountAuthorized( orderPayment.getAmount() );
    		    t.setamountReceived( orderPayment.getAmount() );
    		    t.setTransactionType("ERP-one Transaction");
    		    t.setTransactionSuccessFlag(true);
    		    
    		    this.getOrderService().saveOrderPayment(orderPayment);
    		    if(orderPayment.hasErrors() ){
    		        order.addErrors( orderPayment.getErrors() );
        		    throw "Got errors while saving order-payment" & serializeJson(orderPayment.getErrors());
    		    }
    		}
    		this.getOrderService().saveOrder(order);
    		if(order.hasErrors()){
    	       throw "invalid"; 
    	    }
            this.getHibachiDAO().flushORMSession();
 
            // set order status type
            var orderStatusTypeCode = this.getSlatwallOrderStatusCodeByERPOrderStatusCode( arguments.entityQueueData['erpOrderStatusCode'] );
            order.setOrderStatusType( this.getTypeService().getTypeBySystemCode(orderStatusTypeCode) );
 
    		this.getOrderService().saveOrder(order);
            if(order.hasErrors()){
    	       throw "invalid"; 
    	    }
            this.getHibachiDAO().flushORMSession();
 
 
            this.logHibachi('ErpOneService :: processOrderImport, successfully importer Order: #order.getOrderID()# ');
    	    
    	    // commit the transaction
            thisOrmTransaction.commit();
            
        } catch(any e) { 
                
                thisOrmTransaction.rollback();

                var errorMessage = (e.message ?: '') & " : " & ( e.details ?: '' ); 
                
                order.addError("ERPONE - processOrderImport", errorMessage);
                
        	    this.logHibachi("ERPONE - Encountered Error while processOrderImport - "&errorMessage);
        	    this.logHibachiException(e);
            } 
            
	    this.logHibachi("ERPONE - Finished processOrderImport - Mapping-[#arguments.mapping.mappingCode#]");
	    
	    ORMGetSession().connection().setTransactionIsolation( previousTransactionIsolation );
        return order;
        
	}

	
	
	
	
	public string function getSlatwallOrderStatusCodeByERPOrderStatusCode(required string erpOrderStatusCode){
		/*
			 ERP One Order Status:
			 
				OrderHeader Status codes
				
				CH - credit hold
				CL - closed
				HO - order hold
				
				IJ - invoice journal (posted)
				IP - invoice printed
				IV - invoice (not yet printed)
				
				OE - Order Entry
				OP - Order Printed
				QP - Quote Printed
		*/  
		
		/*	
			Slatwall's Order Statuses:

			
				typeName="Not Placed"                               systemCode="ostNotPlaced"
    			typeName="New"                                      systemCode="ostNew"
    			typeName="Processing"                               systemCode="ostProcessing"
    
    			typeName="On Hold"                                  systemCode="ostOnHold" 
    			typeName="Closed"                                   systemCode="ostClosed" 
    			typeName="Canceled"                                 systemCode="ostCanceled" 
    
    			typeName="Processing - Payment Declined"            systemCode="ostProcessing"  typeCode="paymentDeclined" 
    			
    			typeName="Received"                                 systemCode="ostProcessing"  typeCode="rmaReceived"
    			typeName="Approved"                                 systemCode="ostProcessing"  typeCode="rmaApproved"
    			typeName="Released"                                 systemCode="ostClosed"      typeCode="rmaReleased"
			
		*/
		
		
		if( [ 'OE', 'OP', 'QP', 'IJ', 'IP', 'IV'  ].find(arguments.erpOrderStatusCode) ){
		    return 'ostNew';
		}
		
		if( 'canceled' == arguments.erpOrderStatusCode ){
		    return 'ostCanceled';
		}
		
		if( [ 'HO', 'CH' ].find(arguments.erpOrderStatusCode) ){
		    return 'ostOnHold';
		}
		
		if( 'CL' == arguments.erpOrderStatusCode ){
		    return 'ostClosed';
		}
			
	}
	
	public string function getSlatwallOrderFulfillmentRemoteIDByErpOneOrderNo( required string erpOneOrderNo ){
	    return 'Fulfillment_'&arguments.erpOneOrderNo;
	}
	
	public string function getSlatwallOrderPaymentRemoteIDByErpOneOrder( required string erpOneOrderNo, required numeric recordSeq ){
	    return 'Payment_'&arguments.erpOneOrderNo&'_'&arguments.recordSeq;
	}
	
	public string function getSlatwallOrderDelivderyRemoteIDByErpOneOrder( required string erpOneOrderNo, required numeric recordSeq ){
	    return 'Delivery_'&arguments.erpOneOrderNo&'_'&arguments.recordSeq;
	}
	
	public string function getSlatwallOrderItemRemoteID( required string erpOneOrderNo, required string remoteSkuID){
	    return arguments.erpOneOrderNo&'_'&arguments.remoteSkuID;
	}
	
	public string function getSlatwallDeliveryItemRemoteID( required string erpOneOrderNo, required string remoteSkuID, required numeric quantityOrdered, required numeric sequence, required numeric quantityDelivered){
	    return arguments.erpOneOrderNo&'_'&arguments.remoteSkuID&'_'&arguments.quantityOrdered&'_'&arguments.sequence&'_'&arguments.quantityDelivered;
	}



    public any function erpOneOrderItemFormatterFunction(required struct erponeOrderItem){
        
        if(isNull(arguments.erponeOrderItem['order'])){
            return; // erp returns a lot of empty objects, need to filter those out
        }
    	    
	    if(left(arguments.erponeOrderItem['order'], 1) == '-'){
	        return; // if it's not a complete order
	    }
	    
	     var erponeOrderItemStructKeyMap = {
			"line"       : "line",
			"item"       : "remoteSkuID",
			"order"      : "remoteOrderID",
			"price"      : "price",
			"q_ord"      : "quantity",
			"list_price" : "skuPrice",
			"rec_seq"    : "sequence"
		};
	    
	    var transformedItem = this.getHibachiUtilityService().swapStructKeys( erponeOrderItem, erponeOrderItemStructKeyMap);
    	
    	// make remote ids
    	transformedItem['remoteOrderItemID'] = this.getSlatwallOrderItemRemoteID( transformedItem.remoteOrderID, transformedItem.remoteSkuID);
    	
    	transformedItem['remoteOrderFulfillmentID'] = this.getSlatwallOrderFulfillmentRemoteIDByErpOneOrderNo( transformedItem.remoteOrderID );
    
    	// defaults
    	transformedItem['orderItemTypeCode']    = 'oitSale';
    	transformedItem['orderItemStatusCode']  = 'oistNew';

    	transformedItem['currencyCode']         = 'USD';
    	transformedItem['userDefinedPriceFlag'] = true; // so that Slatwall does-not update the `price` 

    	return transformedItem;
	}

	public any function importErpOneOrderItems( any orderNumber, boolean processInLine = false){
	    
	    var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
	    
		var getOrderItemsQueryString = "FOR EACH oe_line NO-LOCK WHERE oe_line.company_oe = '#company#' AND oe_line.rec_type = 'O'";
        if( !isNull(arguments.orderNumber) ){
            getOrderItemsQueryString &= " AND oe_line.order = '#arguments.orderNumber#'";
        }
            
		var columns = "order,line,item,descr,price,list_price,q_ord,item_stat,rec_seq,o_ext";
	    var erpOneOrderItemMapping = this.getMappingByMappingCode('ErpOneOrderItemImport');
		      
		      
		this.logHibachi("ERPONE - importing order-items for order: #arguments.orderNumber ?: 'All'#, Query: #getOrderItemsQueryString#, Columns: #columns#");
		
    	
    	if(processInLine){
    	    return this.fetchAndImportInline( 
    	        erpOneQuery             = getOrderItemsQueryString,
    		    columns                 = columns,
    		    mapping                 = erpOneOrderItemMapping,
    		    recordFormatterFunction = erpOneOrderItemFormatterFunction
		    );  
    	}
    	
    	var orderItemsImportBatch = this.paginateAndImportToQueue( 
		    erpOneQuery             = getOrderItemsQueryString,
		    columns                 = columns,
		    mapping                 = erpOneOrderItemMapping,
		    recordFormatterFunction = erpOneOrderItemFormatterFunction
		);
		
		return orderItemsImportBatch;
	}

	public any function importErpOneOrderItemChanges( any dateTimeSince = now() - 1 ){
        
        	// first ask the ERP to calculate the changes
	    this.trackErpTableChanges('oe_line', true);
	
	
		this.logHibachi("ERPONE - Starting importing importErpOneOrderItemChanges");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var tableName = 'oe_line';
		var filter = " oe_line.company_oe = '#company#' AND oe_line.rec_type = 'O' ";
		var columns = "order,line,item,descr,price,list_price,q_ord,item_stat,rec_seq,o_ext";
	    var erpOneOrderItemMapping = this.getMappingByMappingCode('ErpOneOrderItemImport');
		
	    var orderItemsImportBatch = this.paginateAndImportChangesToQueue( 
		    tableName               = tableName,
		    columns                 = columns,
		    filter                  = filter,
		    mapping                 = erpOneOrderItemMapping,
		    recordFormatterFunction = erpOneOrderItemFormatterFunction,
		    dateTimeSince           = arguments.dateTimeSince
		);
		
		this.logHibachi("ERPONE - Finish importing Order Items changes");
		
		return orderItemsImportBatch;
	}

	
	
    public any function erpOneOrderPaymentFormatterFunction(required struct erponeOrderPayment){
	    
	    if(isNull(arguments.erponeOrderPayment['order'])){
            return; // erp returns a lot of empty objects, need to filter those out
        }
	    if(left(arguments.erponeOrderPayment['order'], 1) == '-'){
	        return; // if it's not a complete order
	    }
	    
	    var remoteID = this.getSlatwallOrderPaymentRemoteIDByErpOneOrder(arguments.erponeOrderPayment['order'], arguments.erponeOrderPayment['rec_seq'] );
	    
	    // try to find the previous one in case, the order is getting re-imported
	    var orderPaymentID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        'entityName'  = 'OrderPayment',
	        'uniqueKey'   = 'remoteID',
	        'uniqueValue' = remoteID
	    );
	    
	    var orderPayment = { 
    	    'amount'                : arguments.erponeOrderPayment['i_tot_gross'],
	        'rec_seq'               : arguments.erponeOrderPayment['rec_seq'], // needed for transaction generator function
            'currencyCode'			: arguments.erponeOrderPayment['currency_code'] ?: 'USD',
	        'remoteOrderID'         : arguments.erponeOrderPayment['order'],
	        'orderPaymentID'        : orderPaymentID ?: '',
	        'orderPaymentTypeCode'  : 'optCharge',
    	    'remoteOrderPaymentID'	: remoteID
	    };
	    
	    
	    orderPayment['orderPaymentStatusTypeCode'] = 'opstActive';
    	if( !isNull(arguments.erponeOrderPayment['cu_po']) && arguments.erponeOrderPayment['cu_po'].len() ){
    	    orderPayment['paymentTerm']   = 'ERP One default PO term';
    	    orderPayment['paymentMethod'] = 'Purchase Order';
    	    orderPayment['termPaymentAccountRemoteID'] =  arguments.erponeOrderPayment['customer'];
    	} else {
    	    orderPayment['paymentMethod'] = 'ERP payment method';
    	}
    	
    	// Set billing and shipping addresses			
	    var address = {
			'streetAddress'     : arguments.erponeOrderPayment['adr'][1],
			'street2Address'    : arguments.erponeOrderPayment['adr'][2] & " " & arguments.erponeOrderPayment['adr'][3],
			'city'              : arguments.erponeOrderPayment['adr'][4],
			'email'             : arguments.erponeOrderPayment['email'],
			'phoneNumber'       : arguments.erponeOrderPayment['phone'],
			'stateCode'         : arguments.erponeOrderPayment['state'],
			'postalCode'        : arguments.erponeOrderPayment['postal_code'],
			'countryCode'       : arguments.erponeOrderPayment['country_code'] ?: 'US'
	    }
	    
	    address["name"] =  this.getAddressService().getAddressName(address);
	    address['addressNickName'] = "Billing Address" & address["name"];
	    address['remoteAddressID'] = 'billing_'&orderPayment['remoteOrderPaymentID'];
	    
	    var billingAddress = this.getHibachiUtilityService().prefixStructKeys(address, 'billingAddress_');
    	orderPayment.append(billingAddress);
    	
    	return orderPayment;
	}

	public any function importErpOneOrderPayments( any orderNumber, boolean processInLine = false){
		var utilityService = this.getHibachiUtilityService();

	    var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var getOrderPaymentsQueryString = "FOR EACH oe_head NO-LOCK WHERE company_oe = '#company#' AND rec_type = 'I'";
		if( !isNull(arguments.orderNumber) ){
		    getOrderPaymentsQueryString &= " AND order = '#arguments.OrderNumber#'";
		}
		          
        var columns = [ 
            
            'order',
            'customer',
            'rec_seq',
            'currency_code',
            
            'adr',
            'state',
            'email',
            'phone',
            'country_code',
            'postal_code',
            
            'created_date',
            'created_time',
            
            'cu_po',
            'c_tot_code',
            'c_tot_code_amt',
            
            
            'i_tot_gross',
            'i_tot_net_ar',
            
            // 'invc_date',
            // 'invc_seq',
            // 'invoice',
            
            'stat'
        ].toList();        
        
		this.logHibachi("ERPONE - importing order-payments for order: #arguments.orderNumber ?: 'all' #, Query: #getOrderPaymentsQueryString#, Columns: #columns#");
		
	    var erpOneOrderPaymentMapping = this.getMappingByMappingCode('ErpOneOrderPaymentImport');

    	
    	if(processInLine){
    	    return this.fetchAndImportInline( 
    	        erpOneQuery             = getOrderPaymentsQueryString,
    		    columns                 = columns,
    		    mapping                 = erpOneOrderPaymentMapping,
    		    recordFormatterFunction = erpOneOrderPaymentFormatterFunction
		    );  
    	}
    	
    	var orderPaymentsImportBatch = this.paginateAndImportToQueue( 
		    erpOneQuery             = getOrderPaymentsQueryString,
		    columns                 = columns,
		    mapping                 = erpOneOrderPaymentMapping,
		    recordFormatterFunction = erpOneOrderPaymentFormatterFunction
		);
		
		return orderPaymentsImportBatch;
	}
	
	public any function importErpOneOrderPaymentChanges( any dateTimeSince = now() - 1 ){
        
        // first ask the ERP to calculate the changes
	    this.trackErpTableChanges('oe_head', true);
	
		this.logHibachi("ERPONE - Starting importing importErpOneOrderPaymentChanges");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var tableName = 'oe_head';
		var filter = " company_oe = '#company#' AND rec_type = 'I'";
        var columns = [ 
            
            'order',
            'customer',
            'rec_seq',
            'currency_code',
            
            'adr',
            'state',
            'email',
            'phone',
            'country_code',
            'postal_code',
            
            'created_date',
            'created_time',
            
            'cu_po',
            'c_tot_code',
            'c_tot_code_amt',
            
            
            'i_tot_gross',
            'i_tot_net_ar',
            
            // 'invc_date',
            // 'invc_seq',
            // 'invoice',
            
            'stat'
        ].toList();        

	    var erpOneOrderPaymentMapping = this.getMappingByMappingCode('ErpOneOrderPaymentImport');
		
	    var orderPaymentsImportBatch = this.paginateAndImportChangesToQueue( 
		    tableName               = tableName,
		    columns                 = columns,
		    filter                  = filter,
		    mapping                 = erpOneOrderPaymentMapping,
		    recordFormatterFunction = erpOneOrderPaymentFormatterFunction,
		    dateTimeSince           = arguments.dateTimeSince
		);
		
		this.logHibachi("ERPONE - Finish importing Order Payments changes");
		
		return orderPaymentsImportBatch;
	}
	
	public array function generateErpOneOrderPaymentTransactions( struct data,  struct mapping,  struct propertyMetaData ){
	    // ERP does not have a concept of transacrtions, so we're creating one default transaction  per payment;
	    var remoteID = "Transaction_"&arguments.data.remoteOrderPaymentID;
	    
	    // try to find the previous one in case, the order is getting re-imported
	    var paymentTransactionID = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
	        "entityName"  = 'PaymentTransaction',
	        "uniqueKey"   = 'remoteID',
	        "uniqueValue" = remoteID
	    );
	    
	    var transactionData = { 
            'amount'                : arguments.data.amount,
    	    "remoteID"				: remoteID,
	        "paymentTransactionID"  : paymentTransactionID ?: ''
	    };
        
        if(structKeyExists(arguments.data, 'providerTransactionID')){
            transactionData['providerTransactionID'] = arguments.data.providerTransactionID;
        }
        if(structKeyExists(arguments.data, 'authorizationCode')){
            transactionData['authorizationCode'] = arguments.data.authorizationCode;
        }
        
        return [ transactionData ];
	}




    public any function erpOneOrderShipmentFormatterFunction(required struct erponeOrderPayment){
	    
	    if(isNull(arguments.erponeOrderPayment['order'])){
            return; // erp returns a lot of empty objects, need to filter those out
        }
	    if(left(arguments.erponeOrderPayment['order'], 1) == '-'){
	        return; // if it's not a complete order
	    }
	    
	    var remoteID = this.getSlatwallOrderDelivderyRemoteIDByErpOneOrder(arguments.erponeOrderShipment['order'], arguments.erponeOrderShipment['rec_seq'] );
    	    
	    var orderDelivery = { 
	        'rec_seq'               : arguments.erponeOrderShipment['rec_seq'],
    	    'remoteOrderID'         : arguments.erponeOrderShipment['order'],
    	    'remoteOrderDeliveryID'	: remoteID,
    	    'warehouseLocationCode' : 'default',
    	    'shippingMethodCode'    : 'erpOneShippingMethod',
    	    'fulfillmentMethodName' : "Freight"
	    };
    	
    	// TODO 
    	/*
    	    statusCode       // not known
    	    trackingUrl,     // not known
    	    trackingNumber,  // not known
        */
        
    	// Set shipping addresses			
	    var address = {
			'streetAddress'     : arguments.erponeOrderShipment['adr'][1],
			'street2Address'    : arguments.erponeOrderShipment['adr'][2] & " " & arguments.erponeOrderShipment['adr'][3],
			'city'              : arguments.erponeOrderShipment['adr'][4],
			'email'             : arguments.erponeOrderShipment['email'],
			'phoneNumber'       : arguments.erponeOrderShipment['phone'],
			'stateCode'         : arguments.erponeOrderShipment['state'],
			'postalCode'        : arguments.erponeOrderShipment['postal_code'],
			'countryCode'       : arguments.erponeOrderShipment['country_code'] ?: 'US'
	    };
	    
	    address["name"] =  this.getAddressService().getAddressName(address);
	    address['addressNickName'] = "Shipping Address" & address["name"];
	    address['remoteAddressID'] = 'shipping_'&orderDelivery['remoteOrderDeliveryID'];
	   
	    var shippingAddress = this.getHibachiUtilityService().prefixStructKeys(address, 'shippingAddress_');
    	orderDelivery.append(shippingAddress);
    	
    	return orderDelivery;
    }

	public any function importErpOneOrderShipments(any orderNumber, boolean processInLine = false){
	    
	    var utilityService = this.getHibachiUtilityService();

	    var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var getOrderShipmentsQueryString = "FOR EACH oe_head NO-LOCK WHERE company_oe = '#company#' AND rec_type = 'S'";
		if( !isNull(arguments.orderNumber) ){
		    getOrderShipmentsQueryString &= " AND order = '#arguments.OrderNumber#'";
		}
		    
        var columns = [ 
            "customer",
            "invc_seq", "invoice",
            "rec_seq", "created_date", "created_time",
            "order", "opn", "stat", "ord_ext", "ord_date",
            "ship_date", "num_pages", "manifest_id", "warehouse", "ship_via_code",
            "adr", "phone", "email", "state", "country_code", "postal_code"
        ].toList();   
       
	    var erpOneOrderShipmentMapping = this.getMappingByMappingCode('ErpOneOrderShipmentImport');
		
		this.logHibachi("ERPONE - importing order-payments for order: #arguments.orderNumber ?: 'all' #, Query: #getOrderShipmentsQueryString#, Columns: #columns#");
		
    	if(processInLine){
    	    return this.fetchAndImportInline( 
    	        erpOneQuery             = getOrderShipmentsQueryString,
    		    columns                 = columns,
    		    mapping                 = erpOneOrderShipmentMapping,
    		    recordFormatterFunction = erpOneOrderShipmentFormatterFunction
		    );  
    	}
    	
    	var orderShipmentImportBatch = this.paginateAndImportToQueue( 
		    erpOneQuery             = getOrderShipmentsQueryString,
		    columns                 = columns,
		    mapping                 = erpOneOrderShipmentMapping,
		    recordFormatterFunction = erpOneOrderShipmentFormatterFunction
		);

		return orderShipmentImportBatch;
	}
	
	public any function importErpOneOrderShipmentChanges( any dateTimeSince = now() - 1 ){
        
    	// first ask the ERP to calculate the changes
	    this.trackErpTableChanges('oe_head', true);
	
		this.logHibachi("ERPONE - Starting importing importErpOneOrderShipmentChanges");
		
		var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var tableName = 'oe_head';
		var filter = " company_oe = '#company#' AND rec_type = 'S'";
        var columns = [ 
            "customer",
            "invc_seq", "invoice",
            "rec_seq", "created_date", "created_time",
            "order", "opn", "stat", "ord_ext", "ord_date",
            "ship_date", "num_pages", "manifest_id", "warehouse", "ship_via_code",
            "adr", "phone", "email", "state", "country_code", "postal_code"
        ].toList(); 
        
	    var erpOneOrderShipmentMapping = this.getMappingByMappingCode('ErpOneOrderShipmentImport');
		
	    var orderShipmentsImportBatch = this.paginateAndImportChangesToQueue( 
		    tableName               = tableName,
		    columns                 = columns,
		    filter                  = filter,
		    mapping                 = erpOneOrderShipmentMapping,
		    recordFormatterFunction = erpOneOrderShipmentFormatterFunction,
		    dateTimeSince           = arguments.dateTimeSince
		);
		
		this.logHibachi("ERPONE - Finish importing Order Shipments changes");
		
		return orderShipmentsImportBatch;
	}

	public any function generateErpOneOrderDeliveryItems(struct data,  struct mapping,  struct propertyMetaData ){
	    
	    var isDevModeFlag = this.setting("devMode");
		var company =  this.setting("prodCompany")
		if(isDevModeFlag){
			company = this.setting("devCompany");
		}
		
		var query = "
            FOR EACH oe_line NO-LOCK  
                WHERE oe_line.company_oe = '#company#' 
            AND oe_line.rec_type = 'S' 
            AND oe_line.order = '#arguments.data.remoteOrderID#'
		";
		          
        var columns = "order,line,item,descr,price,q_ord,q_comm,rec_seq";        
        
		this.logHibachi("ERPONE - fetching order-shipment-items for order: #arguments.data.remoteOrderID#, Query: #query#, Columns: #columns#");
			 
		var orderShipmentItems = this.callErpOneGetDataApi({
			"query": query,
			"columns" : columns
		});
		
		var transformedItems = [];

		for(var erponeItem in  orderShipmentItems ){
		    
		    var deliveryItemRemoteID = this.getSlatwallDeliveryItemRemoteID( 
		        erponeItem.order, 
		        erponeItem.item, 
		        erponeItem.q_ord,
		        erponeItem.rec_seq,
		        erponeItem.q_comm
		    );
		  
		    var orderDeliveryItemID   = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
    	        "entityName"  : 'OrderDeliveryItem',
    	        "uniqueKey"   : 'remoteID',
    	        "uniqueValue" : deliveryItemRemoteID
    	    );
	        
	        
	        var transformedItem = {
	            'remoteID'              : deliveryItemRemoteID,
	            'quantity'              : erponeItem['q_comm'],                // quantity delivered
	            'orderDeliveryItemID'   : orderDeliveryItemID ?: ''
	        };
	        
            // find and link the orderItem
            var remoteOrderItemID  = this.getSlatwallOrderItemRemoteID( erponeItem.order, erponeItem.item);
            var orderItemID   = this.getHibachiService().getPrimaryIDValueByEntityNameAndUniqueKeyValue(
                "entityName"  : 'OrderItem',
                "uniqueKey"   : 'remoteID',
                "uniqueValue" : remoteOrderItemID,
                "useORM"      : true
            );
            
            transformedItem['orderItem']    = { 'orderItemID':  orderItemID };
            
            // find and link stock, will use the default location
            transformedItem['stock'] = this.generateOrderDeliveryItemStock(
                data = { 'remoteOrderItemID' : remoteOrderItemID},
                propertyMetaData = { "useORM" : true }
            );
            
            
            transformedItems.append(transformedItem);
		}
		
		return transformedItems;
    };







    // TODO: refactor to use paginate and import
	public any function importErpOneInventoryItems(){

		logHibachi("ERPONE - Starting importing ErpOneInventoryItems");
		
		var pageSize = 100;
		
		var skuCollection = getSkuService().getSkuCollectionList();
		skuCollection.setDisplayProperties(displayPropertiesList='skuCode');
		var totalRecordsCount = skuCollection.getRecordsCount();
		skuCollection.setPageRecordsShow(pageSize);
		
		var totalPages = floor(totalRecordsCount / pageSize);

		for(var i = 1; i <= totalPages; i++){
			// try {
				skuCollection.setCurrentPageDeclaration(i);
				var skus = skuCollection.getPageRecords(refresh=true);
				var skuData = '';
				for(var sku in skus) {
					//sku['skuCode']=reReplace(reReplace(sku['skuCode'], "--" , "/", "all" ),"__", " ", "all");
					skuData = listAppend(skuData, sku['skuCode']);

				}
				var inventoryArray = this.callErpOneGetDataApi({
					'items'			: skuData,
					'warehouses'	: '01',
					'format'		: 'array'
				},'item/availability');
				
				if(arrayLen(inventoryArray)){
					
					for(var inventoryItem in inventoryArray){
						var test = queryExecute(
							sql = 'UPDATE swSku set calculatedQATS = :qnt WHERE skuCode = :skuCode',
							params = {
								'skuCode' : {
									'value' : inventoryItem['item'],
									'type' : 'varchar'
								},
								'qnt' : {
									'value' : inventoryItem['available'],
									'type' : 'numeric'
								},
							}
						);
					
					}
					
					
				}
				

			// } catch(e){
	
			// 	this.logHibachi("Got error while trying to call getItemInventoryData for CurrentPage: #currentPage# and PageSize: #pageSize#");
			// 	this.getHibachiUtilityService().logException(e);
			// }
		

		}
	
			
		this.logHibachi("ERPONE - Finish importing ErpOneInventoryItems");
	}
	
	
	/**
	 * @hint helper function, to push Data into @thisIntegration/Data.cfc for further processing, from EntityQueue
	 * 
	**/ 
	public void function pushAccountDataToErpOne(required any entity, any data ={}){
		logHibachi("ERPOne - Start pushData - Account: #arguments.entity.getAccountID()#");
		
		var customerChanges = {
			"name" : arguments.entity.getFirstName()&" "&arguments.entity.getLastName(),
			"company_cu" : this.setting("devMode") ? this.setting("devCompany") : this.setting("prodCompany"),
			"customer" : arguments.entity.getCompanyCode()
		};
		if(!isNull(entity.getAddress())){
			var address = entity.getAddress();
			customerChanges['adr[1]'] = address.getStreetAddress();
			customerChanges['adr[2]'] = address.getStreet2Address();
			customerChanges['adr[4]'] = address.getCity();
			customerChanges['state'] = address.getStateCode();
			customerChanges['postal_code'] = address.getPostalCode();
		}
		
		if(!isNull(entity.getPrimaryPhoneNumber())){
			customerChanges['phone'] = entity.getPrimaryPhoneNumber().getPhoneNumber();
		}
		

		if( len(arguments.entity.getRemoteID()) ){
			
			customerChanges['__rowid'] = arguments.entity.getRemoteID();
			var accountResponse = this.callErpOneUpdateDataApi({
				"table"	   : "customer",
				"triggers" : "true",
				"changes"  : [ customerChanges ]
			}, "update" );
			
			/** Format error:
			 * typical error response: { "errordetail": "error", "filecontent": "null"};
			 * typical successful response: {"table":"customer","updated":1,"triggers":false}
			*/
		
			if( structKeyExists(accountResponse, 'updated') && accountResponse.updated > 0 ){
				logHibachi("ERPOne - Successfully updated Account Data");
			} else {
				throw("ERPONE - callErpOnePushAccountApi: API response is not valid json");
			}
			
			if( len(entity.getRemoteContact()) ){

				
				var contactResponse = this.callErpOneUpdateDataApi({
					"table"	 : "sy_contact",
					"triggers" : "true",
					"changes"	 : [ 
						{
							"__rowid" : entity.getRemoteContact(),
							"company_sy" : this.setting("devMode") ? this.setting("devCompany") : this.setting("prodCompany"),
							"First_Name" : entity.getFirstName(),
							"Last_Name" : entity.getLastName()
						} 
					]
				}, "update" );
				
				/** Format error:
				 * typical error response: { "errordetail": "error", "filecontent": "null"};
				 * typical successful response: {"table":"customer","updated":1,"triggers":false}
				*/
			
				if( structKeyExists(contactResponse, 'updated') && contactResponse.updated > 0 ){
					logHibachi("ERPOne - Successfully updated Sy_contact Data");
				} else {
					throw("ERPONE - callErpOnePushSy_contactApi: Error occured while updating `sy_contact`");
				}
			}
			
		} else {
			
			var response = this.callErpOneUpdateDataApi({
				"table"	   : "customer",
				"triggers" : "true",
				"records"  : [ customerChanges ]
			}, "create" );
			/** Format error:
			 * typical error response: { "errordetail": "error", "filecontent": "null"};
			 * typical successful response: {"table":"customer","updated":1,"triggers":false}
			*/
			if( structKeyExists(response, 'created') && response.created > 0 ){
				
				logHibachi("ERPOne - Successfully created Account on Erpone with rowID #response.rowids[1]#");
				
				entity.setRemoteID(response.rowids[1]);
				entity.setImportRemoteID(lcase(hash(response.rowids[1], 'MD5')));

				
				var contactResponse = this.callErpOneUpdateDataApi({
					"table"	 : "sy_contact",
					"triggers" : "true",
					"records"	 : [ {
						"company_sy" : this.setting("devMode") ? this.setting("devCompany") : this.setting("prodCompany"),
						"First_Name" : entity.getFirstName(),
						"Last_Name" : entity.getLastName()
					} ]
				}, "create" );
				
				/** Format error:
				 * typical error response: { "errordetail": "error", "filecontent": "null"};
				 * typical successful response: {"table":"customer","updated":1,"triggers":false}
				*/
				logHibachi("ERPOne - Successfully created sy_contact on Erpone with rowID #contactResponse.rowids[1]#");
				
				if( structKeyExists(contactResponse, 'created') && contactResponse.created > 0 ){

					var prospectResponse = this.callErpOneUpdateDataApi({
    					"table" : "cu_prospect",
    					"triggers" : "true",
    					"records" : [{
        					"company_cu" : this.setting("devMode") ? this.setting("devCompany") : this.setting("prodCompany"),
        					"customer" : arguments.entity.getCompanyCode()
    					}] 
					}, "create" );

					entity.setRemoteContact(contactResponse.rowids[1]);
					
					logHibachi("ERPOne - Successfully created cu_prospect on Erpone with rowID #prospectResponse.rowids[1]#");
					
				} else {
					throw("ERPONE - callErpOnePushSy_contactApi: Unable to create sy_contact on Erpone");
				}
				
			
			} else {
				throw("ERPONE - callErpOnePushAccountApi: Unable to create Account on Erpone response: #Serializejson(response)#");
			}
		}
		
		logHibachi("ERPOne - End Account pushData");
	}
	
	// Preprocess Functions - Process data as per slatwall
	
	public struct function preProcessProductData(required struct data ){

		if( !structKeyExists(arguments.data, 'Price') || this.hibachiIsEmpty(arguments.data.Price) ) {
			
			arguments.data.Price=arguments.data.ListPrice;
		}
		
		if( !structKeyExists(arguments.data, 'ListPrice') || this.hibachiIsEmpty(arguments.data.ListPrice) ) {
			
			arguments.data.ListPrice=arguments.data.Price;
		}
		
		// using -- so we can revert it when sending data back to erpone
		
		if( structKeyExists(arguments.data, 'ProductCode') ){
			
			arguments.data.ProductCode=arguments.data.ProductCode;
		}

		if( !structKeyExists(arguments.data, 'SkuCode') || this.hibachiIsEmpty( arguments.data.SkuCode ) ){
			
			arguments.data.SkuCode = arguments.data.ProductCode;
		}else{
			
			arguments.data.SkuCode = arguments.data.SkuCode;
		}
		
		if( !structKeyExists(arguments.data, 'RemoteProductID') || this.hibachiIsEmpty(arguments.data.RemoteProductID) ){
			// var productCode = arguments.data.ProductCode;
			// var remoteProductIDArray = this.callErpOneGetDataApi({
			//  	    "query": "FOR EACH item WHERE item= '#productCode#' AND company_it = 'SB'",
			//  	    "columns" : "__rowids"
			//  	})
			// arguments.data.RemoteProductID=remoteProductIDArray[1].__rowids;
			arguments.data.RemoteProductID = arguments.data.ProductCode;
		}
		
		if( !structKeyExists(arguments.data, 'RemoteSkuID') || this.hibachiIsEmpty( arguments.data.RemoteSkuID ) ){
			arguments.data.RemoteSkuID = arguments.data.SkuCode;
		}
		
		if( !structKeyExists(arguments.data, 'skuName') || this.hibachiIsEmpty( arguments.data.skuName ) ){
			arguments.data.skuName = arguments.data.productName;
		}
		
		return arguments.data;
	}
	
	
	public void function pushOrderDataToErpOne(required any entity, any data ={}){
		this.logHibachi("ERPOne - Start pushData - Order: #arguments.entity.getOrderID()#");
		
		var isDevModeFlag = this.setting("devMode");
		
		if( !len(arguments.entity.getRemoteID()) ){
			
			arguments.data.payload = {
				'order_ext' : arguments.entity.getOrderNumber(),
	            'customer' : arguments.entity.getAccount().getCompanyCode(),
			}
			
			for( var orderPayment in arguments.entity.getOrderPayments() ){
				if(orderPayment.getStatusCode() == "opstActive"){
					if(orderPayment.getPaymentMethod().getPaymentMethodType() == 'termPayment'){
						arguments.data.payload['cu_po'] = orderPayment.getPurchaseOrderNumber();
						break;
					}else if(orderPayment.getPaymentMethod().getPaymentMethodType() == 'creditCard'){
						
						arguments.data.payload['Cred_card'] = '************' & orderPayment.getCreditCardLastFour();
						
						var expiration = '20';
						if(len(orderPayment.getExpirationYear()) == 4){
							expiration = orderPayment.getExpirationYear();
						}else{
							expiration &= orderPayment.getExpirationYear();
						}
						expiration &= '/' & numberFormat(orderPayment.getExpirationMonth(),'00') & '/01';
						
						arguments.data.payload['Cred_card_exp'] = expiration;
						arguments.data.payload['Cred_card_type'] = 'CC'; //Value: Valid credit card code in the system. Example: “CC” or “VI”
						arguments.data.payload['Auth_type'] = 'A'; // Value: Preauth indicator “A”
						arguments.data.payload['Auth_asv'] = 'Y';
						
						arguments.data.payload['Auth_amount'] = orderPayment.getAmountAuthorized();
						
						var paymentTransactions = orderPayment.getPaymentTransactions();
						for(var i=1; i<=arrayLen(paymentTransactions); i++) {
							if(paymentTransactions[i].getAmountAuthorized() > 0 &&(isNull(paymentTransactions[i].getAuthorizationCodeInvalidFlag()) || !paymentTransactions[i].getAuthorizationCodeInvalidFlag())) {
								arguments.data.payload['Auth_date'] = dateFormat(paymentTransactions[i].getTransactionDateTime(), 'yyyy-mm-dd');
								arguments.data.payload['Auth_time'] = timeFormat(paymentTransactions[i].getTransactionDateTime(), 'h:mm TT');
								arguments.data.payload['Auth_memo'] = 'This transaction has been approved';
								arguments.data.payload['Auth_number'] = paymentTransactions[i].getAuthorizationCode();
								arguments.data.payload['Auth_trans_number'] = paymentTransactions[i].getAuthorizationCode();
								break;
							}
						}
						
					}
					
					break;
				}
			}
			
			if(!arguments.entity.getShippingAddress().getNewFlag()){
	            arguments.data.payload['s_name'] =  arguments.entity.getShippingAddress().getName();
	            arguments.data.payload['s_adr'] = [
	                arguments.entity.getShippingAddress().getStreetAddress(),
	                arguments.entity.getShippingAddress().getStreet2Address(),
	                arguments.entity.getShippingAddress().getLocality(),
	                arguments.entity.getShippingAddress().getCity()
	            ];
	            arguments.data.payload['s_st'] = arguments.entity.getShippingAddress().getStateCode();
	            arguments.data.payload['s_postal_code'] = arguments.entity.getShippingAddress().getPostalCode();
	            arguments.data.payload['s_country_code'] = arguments.entity.getShippingAddress().getCountryCode();
			}
			
			if(isDevModeFlag){
				arguments.data.payload['company_cu'] = this.setting("devCompany");
				arguments.data.payload['company_oe'] = this.setting("devCompany");
			}else{
				arguments.data.payload['company_cu'] = this.setting("prodCompany");
				arguments.data.payload['company_oe'] = this.setting("prodCompany");
			}
			var response = this.callErpOneUpdateDataApi({
			  "table"	 : "ec_oehead",
			  "triggers" : "true",
			  "records"	 : [ arguments.data.payload ]
			}, "create" );
			
			if(structKeyExists(response, 'created') && response.created == 1){
			    // the order in th ERP is not gonna have an order number, until it has been processed there
			    // and we need ERP's order-number as the remove ID, that's what used to figure-out and link the order relations
				
				// arguments.entity.setRemoteID(response.rowids[1]);
				
				// so instead of trying to set the remote-id here, we'd send a DAO query to update the Slatwall's order
				// while importing an puting th orders in the queue; it's safe as once created the order-number is not going to change.
				
			}else{
				throw("ERPONE - pushOrderDataToErpOne #arguments.entity.getOrderNumber()#: Error: #Serializejson(response)#");
			}
		}

		var orderItemsData = [];
		var lineNumber = 0;
		for(var orderItem in arguments.entity.getOrderItems()){
			lineNumber++;
			if(len(orderItem.getRemoteID())){
				continue;
			}
			 var itemData = {
	            'order_ext' : arguments.entity.getOrderNumber(),
	            'customer' : arguments.entity.getAccount().getCompanyCode(),
	            'line' : lineNumber,
	            'item' : orderItem.getSku().getRemoteID(),
	            'qty_ord' : orderItem.getQuantity(),
	            'unit_price' : orderItem.getExtendedUnitPriceAfterDiscount(),
	            'override_price' : 'yes'
			}
			
			if(isDevModeFlag){
				itemData['company_it'] = this.setting("devCompany");
				itemData['company_cu'] = this.setting("devCompany");
				itemData['company_oe'] = this.setting("devCompany");
			}else{
				itemData['company_it'] = this.setting("prodCompany");
				itemData['company_cu'] = this.setting("prodCompany");
				itemData['company_oe'] = this.setting("prodCompany");
			}
			orderItemsData.append(itemData);
			lineNumber++;
		}
		
		if(arrayLen(orderItemsData)){
			var response = this.callErpOneUpdateDataApi({
			  "table"	 : "ec_oeline",
			  "triggers" : "false",
			  "records"	 : orderItemsData
			}, "create" );

			if(structKeyExists(response, 'created') && response.created > 0){
			    // as we won't have the ERP's order no yet, we can't create the remote IDs yet 
			    
				// var lineNumber = 1;
				// for(var orderItem in arguments.entity.getOrderItems()){
				// 	if(len(orderItem.getRemoteID())){
				// 		continue;
				// 	}
				// 	orderItem.setRemoteID(response.rowids[lineNumber]);
				// 	lineNumber++;
					
				// }
			}
		}
		logHibachi("ERPOne - End Order pushData");
	}
	
	public any function preProcessInventoryData(required struct data ){
	    var erponeMapping = {
			"item" 			: "remoteSkuID",
			"warehouse"		: "remoteLocationID",
			"available"		: "quantityIn"
		};

	    var transformedItem = this.getHibachiUtilityService().swapStructKeys( arguments.data, erponeMapping);
    	if( structKeyExists(transformedItem, 'remoteSkuID') ){
			transformedItem.remoteSkuID=reReplace(reReplace(transformedItem.remoteSkuID, "(\\|/)", "--", "all" ),"\s", "__", "all");
			transformedItem.remoteInventoryID=transformedItem.remoteLocationID&"--"&reReplace(reReplace(transformedItem.remoteSkuID, "(\\|/)", "--", "all" ),"\s", "__", "all");
    	}
    	return transformedItem;
	}
}
