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
	property name="hibachiCacheService";
	property name="hibachiDataService";
	property name="hibachiUtilityService";
	
	property name="accountDAO" type="any";
	
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
			    throw("createAndSetGrantToken: API responde is not valid json");
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
			    throw("createAndSetAccessToken: API responde is not valid json");
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
    	httpRequest.addParam( type='header', name='Content-Type', value=arguments.requestContentType);
    	return httpRequest;
    }
    
    public any function callErpOneGetDataApi( required struct requestData, string endpoint="read" ){
		getService('hibachiTagService').cfsetting(requesttimeout=100000);
    	var httpRequest = this.createHttpRequest('distone/rest/service/data/'&arguments.endpoint);
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		
		for( var key in arguments.requestData ){
		    httpRequest.addParam( type='formfield', name= key, value = arguments.requestData[key] );
		}
        var rawRequest = httpRequest.send().getPrefix();
        if( !IsJson(rawRequest.fileContent) ){
		    throw("ERPONE - callErpOneGetDataApi: API responde is not valid json for request: #Serializejson(arguments.requestData)# response: #rawRequest.fileContent#");
		}
			
	    return DeSerializeJson(rawRequest.fileContent);
    }
    
    public any function callErpOneUpdateDataApi( required any requestData, string endpoint="create" ){
    	var httpRequest = this.createHttpRequest('distone/rest/service/data/'&arguments.endpoint,"POST","application/json");
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		httpRequest.addParam(type="body", value=serializeJSON(requestData));
        var rawRequest = httpRequest.send().getPrefix();
        if( !IsJson(rawRequest.fileContent) ){
		    throw("ERPONE - callErpOneUpdateDataApi: API responde is not valid json for request: #Serializejson(arguments.requestData)# response: #rawRequest.fileContent#");
		}
			
	    return DeSerializeJson(rawRequest.fileContent);
    }
    	
	public struct function transformedErpOneItem(required struct item, required struct erponeMapping ){

		var transformedItem = {};
	    	
	    	for( var sourceKey in arguments.erponeMapping ){
	    		var destinationKey = arguments.erponeMapping[ sourceKey ];
	    		
	    		if( structKeyExists(arguments.item, sourceKey) ){
	        	    transformedItem[ destinationKey ] = arguments.item[ sourceKey ];
	    		}
	    	}
	    
	    return transformedItem;
	}
    
    // get data API call
    
    public any function getAccountData(numeric pageNumber = 1, numeric pageSize = 50 ){
    	logHibachi("ERPONE - called getAccountData with pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		// comment out the functionallity as we dont have data for DC on dev DB 
		
		// Change company name as per our environment in API query
		// if( !this.setting("devMode") ){
		//  var requestQuery = 'FOR EACH customer WHERE customer.active = YES AND customer.company_cu = "SB"';
		// } else {
		// 	var requestQuery = 'FOR EACH customer WHERE customer.active = YES AND customer.company_cu = "DC"';
		// }
		var requestQuery = 'FOR EACH customer WHERE customer.active = YES AND customer.company_cu = "SB"';	
    	var accountsArray = this.callErpOneGetDataApi({
    	    "skip" : ( arguments.pageNumber - 1 ) * arguments.pageSize,
    	    "take" : arguments.pageSize,
			"query": requestQuery,
    	    "columns" : "name,country_code,email_address,phone,Active,company_cu,customer"
    	})
    	
		
		if( accountsArray.len() > 0 ){
		
		    this.logHibachi("ERPONE - Start pushing accounts to import-queue ");
			var batch = this.pushRecordsIntoImportQueue( "Account", accountsArray );
			this.logHibachi("ERPONE - Finish pushing accounts to import-queue, Created new import-batch: #batch.getBatchID()#, pushed #batch.getEntityQueueItemsCount()# of #batch.getInitialEntityQueueItemsCount()# into import queue");

		} else {
		    this.logHibachi("ERPONE - No data recieve from getAccountData API for pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		}
		
    }

	public any function getOrderData(numeric pageNumber = 1, numeric pageSize = 50 ){
    	logHibachi("ERPONE - called getOrderData with pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		//still working to get order numbers without hyphen so pass one order for testing
    	var OrdersArray = this.getErpOneData({
    	    "skip" : ( arguments.pageNumber - 1 ) * arguments.pageSize,
    	    "take" : arguments.pageSize,
    	    "query": "FOR EACH oe_head",
    	    "columns" : "order,ord_date,customer,adr,currency_code,country_code,postal_code,state"
    	})

		if( OrdersArray.len() > 0 ){

		    this.logHibachi("ERPONE - Start pushing Orders to import-queue ");
			var batch = this.pushRecordsIntoImportQueue( "Order", OrdersArray );
			this.logHibachi("ERPONE - Finish pushing Orders to import-queue, Created new import-batch: #batch.getBatchID()#, pushed #batch.getEntityQueueItemsCount()# of #batch.getInitialEntityQueueItemsCount()# into import queue");

		} else {
		    this.logHibachi("ERPONE - No data recieve from getOrderData API for pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		}
		
    }
    
    public any function getOrderItemData(numeric pageNumber = 1, numeric pageSize = 50 ){
    	logHibachi("ERPONE - called getOrderItemData with pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		//still working to get order numbers without hyphen so pass one order for testing
    	var OrdersArray = this.getErpOneData({
    	    "skip" : ( arguments.pageNumber - 1 ) * arguments.pageSize,
    	    "take" : arguments.pageSize,
    	    "query": "FOR EACH oe_line",
    	    "columns" : "order,price,list_price,item,line"
    	})

		if( OrdersArray.len() > 0 ){

		    this.logHibachi("ERPONE - Start pushing OrderItem to import-queue ");
			var batch = this.pushRecordsIntoImportQueue( "OrderItem", OrdersArray );
			this.logHibachi("ERPONE - Finish pushing OrderItem to import-queue, Created new import-batch: #batch.getBatchID()#, pushed #batch.getEntityQueueItemsCount()# of #batch.getInitialEntityQueueItemsCount()# into import queue");

		} else {
		    this.logHibachi("ERPONE - No data recieve from getOrderItemData API for pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		}

    }
	
	// Importer Functions - Paginated data API call
	
	public any function importErpOneAccounts(){
		
		logHibachi("ERPONE - Starting importing importErpOneAccounts");
		
		var response = this.callErpOneGetDataApi({
    	    "table" : "customer"
    	}, "count");
    	
		var totalRecordsCount = response.count;
		var currentPage = 1;
		var pageSize = 100;

		var recordsFetched = 0;
		
		 while ( recordsFetched < totalRecordsCount ){
			
			try {
				
				this.getAccountData( currentPage, pageSize	);
				this.logHibachi("Successfully called getAccountData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				
			} catch(e){
			
				this.logHibachi("Got error while trying to call getAccountData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				this.getHibachiUtilityService().logException(e);
			}
			
			//increment rgardless of success or failure;
			recordsFetched += pageSize;
			currentPage += 1;
		}
		
	    this.logHibachi("ERPONE - Finish importing importErpOneOrders for totalRecordsCount: #totalRecordsCount#, recordsFetched: #recordsFetched#");
	}
	
	public any function importErpOneOrders(){
		
		logHibachi("ERPONE - Starting importing importErpOneOrders");
			
		var response = this.getErpOneData({
    	    "table" : "oe_head"
    	}, "count");
    	
		var totalRecordsCount = response.count;
		var currentPage = 1;
		var pageSize = 100;
		var recordsFetched = 0;
		
		while ( recordsFetched < totalRecordsCount ){
			
			try {
				this.getOrderData( currentPage, pageSize );
				this.logHibachi("Successfully called getOrderData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				
			} catch(e){
			
				this.logHibachi("Got error while trying to call getOrderData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				this.getHibachiUtilityService().logException(e);
			}
			
			//increment regardless of success or failure;
			recordsFetched += pageSize;
			currentPage += 1;
		}
		
	    this.logHibachi("ERPONE - Finish importing importErpOneOrders for totalRecordsCount: #totalRecordsCount#, recordsFetched: #recordsFetched#");
	}
	
	public any function importErpOneOrderItems(){

		logHibachi("ERPONE - Starting importing ErpOneOrderItems");

		var response = this.getErpOneData({
    	    "table" : "oe_line"
    	}, "count");
		
		var totalRecordsCount = response.count;
		var currentPage = 1;
		var pageSize = 100;
		var recordsFetched = 0;

		while ( recordsFetched < totalRecordsCount ){

			try {
				this.getOrderItemData( currentPage, pageSize );
				this.logHibachi("Successfully called getOrderItemData for CurrentPage: #currentPage# and PageSize: #pageSize#");

			} catch(e){

				this.logHibachi("Got error while trying to call getOrderItemData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				this.getHibachiUtilityService().logException(e);
			}

			//increment regardless of success or failure;
			recordsFetched += pageSize;
			currentPage += 1;
		}

	    this.logHibachi("ERPONE - Finish importing ErpOneOrderItems for totalRecordsCount: #totalRecordsCount#, recordsFetched: #recordsFetched#");
	}
	
	/**
	 * @hint helper function to create a struct of properties+values from @entity/Account.cfc.
	 * 
	 * @account, @enty/Account.cfc 
	 * @returns, Struct of account properties+values required by Erpone createUser API.
	**/ 
	public any function convertSwAccountToErponeAccount(required any account){
		var accountPropList =  "accountID,firstName,lastName,activeFlag,username,remoteID,company,primaryEmailAddress.emailAddress,primaryPhoneNumber.phoneNumber";
		var addressPropList = 	this.getHibachiUtilityService().prefixListItem("streetAddress,street2Address,city,postalCode,stateCode,countryCode", "primaryAddress.address.");

		accountPropList = accountPropList & ',' & addressPropList;
		var swAccountStruct = arguments.account.getStructRepresentation( accountPropList );
		var mapping = {
			"remoteID" : "__rowid",
	        "primaryAddress_address_countryCode" : "country_code",
	        "primaryEmailAddress_emailAddress" : "email_address",
	        "primaryPhoneNumber_phoneNumber" : "phone",
	        "activeFlag" : "Active",
	        "customer" : "companyCode",
	        "company" : "name"
		};

		var erponeAccount = {};

		for(var fromKey in mapping){
			if( StructKeyExists( swAccountStruct, fromKey ) && !IsNull(swAccountStruct[fromKey]) ){
				erponeAccount[mapping[fromKey]] = swAccountStruct[fromKey];
			}
		}

		return erponeAccount;			
	}
	
	public any function convertSwAccountToErponeSyconatcAccount(required any account){
		var accountPropList =  "accountID,firstName,lastName,activeFlag,username,remoteID,company,primaryEmailAddress.emailAddress,primaryPhoneNumber.phoneNumber";
		var addressPropList = 	this.getHibachiUtilityService().prefixListItem("streetAddress,street2Address,city,postalCode,stateCode,countryCode", "primaryAddress.address.");

		accountPropList = accountPropList & ',' & addressPropList;
		var swAccountStruct = arguments.account.getStructRepresentation( accountPropList );
		var mapping = {
	        "contact" : "companyCode",
	        "firstName" : "First_Name",
	        "lastName" : "Last_Name",
	        "primaryAddress_address_streetAddress" : "adr_1",
	        "primaryAddress_address_street2Address" : "adr_2",
	        "primaryAddress_address_city" : "adr_4",
	        "primaryAddress_address_stateCode" : "state",
	        "primaryAddress_address_postalCode" : "postal_code"
		};

		var erponeAccount = {};

		for(var fromKey in mapping){
			if( StructKeyExists( swAccountStruct, fromKey ) && !IsNull(swAccountStruct[fromKey]) ){
				erponeAccount[mapping[fromKey]] = swAccountStruct[fromKey];
			}
		}

		return erponeAccount;			
	}
	
	/**
	 * @hint helper function, to push Data into @thisIntegration/Data.cfc for further processing, from EntityQueue
	 * 
	**/ 
	public void function pushAccountDataToErpOne(required any entity, any data ={}){
		logHibachi("ERPOne - Start pushData - Account: #arguments.entity.getAccountID()#");
		
		arguments.data.payload = this.convertSwAccountToErponeAccount(arguments.entity);
		arguments.data.sycontactData = this.convertSwAccountToErponeSyconatcAccount(arguments.entity);
		arguments.create = false;
		
		//push to remote endpoint
		
        var payload = {
		  "table"	 : "customer",
		  "triggers" : "true",
		  "changes"	 : [ arguments.data.payload ]
		};
			
		if( !this.hibachiIsEmpty(arguments.entity.getRemoteID()) ){
			var accountResponse = this.callErpOneUpdateDataApi(payload, "update" );
			
			/** Format error:
			 * typical error response: { "errordetail": "error", "filecontent": "null"};
			 * typical successful response: {"table":"customer","updated":1,"triggers":false}
			*/
		
			if( structKeyExists(accountResponse, 'updated') && accountResponse.updated > 0 ){
				logHibachi("ERPOne - Successfully updated Account Data");
			}
			else {
				throw("ERPONE - callErpOnePushAccountApi: API responde is not valid json for request: #Serializejson(arguments.data.payload)#");
			}
			
			if( structKeyExists(arguments.data.sycontactData, 'First_Name') && !this.hibachiIsEmpty(arguments.data.sycontactData.First_Name) ){
				var sycontactPayload = {
				  "table"	 : "sy_contact",
				  "triggers" : "true",
				  "changes"	 : [ arguments.data.sycontactData ]
				};
				
				var sy_conatctUpdateresponse = this.callErpOneUpdateDataApi(sycontactPayload, "update" );
				
				/** Format error:
				 * typical error response: { "errordetail": "error", "filecontent": "null"};
				 * typical successful response: {"table":"customer","updated":1,"triggers":false}
				*/
			
				if( structKeyExists(sy_conatctUpdateresponse, 'updated') && sy_conatctUpdateresponse.updated > 0 ){
					logHibachi("ERPOne - Successfully updated Sy_contact Data");
				}
				else {
					throw("ERPONE - callErpOnePushSy_contactApi: Error occured while updating `sy_contact`, request: #Serializejson(arguments.data.payload)#");
				}
			}
			
		} else {
			var payload = {
			  "table"	 : "customer",
			  "triggers" : "true",
			  "records"	 : [ arguments.data.payload ]
			};
			var response = this.callErpOneUpdateDataApi(payload, "create" );
			/** Format error:
			 * typical error response: { "errordetail": "error", "filecontent": "null"};
			 * typical successful response: {"table":"customer","updated":1,"triggers":false}
			*/
			if( structKeyExists(response, 'created') && response.created > 0 ){
				
				logHibachi("ERPOne - Successfully created Account on Erpone with rowID #response.rowids[1]#");
				
				//Added remoteAccountID to get importRemoteID for the account
				if( !structKeyExists(arguments.data.payload, 'remoteAccountID') || this.hibachiIsEmpty(arguments.data.payload.remoteAccountID) ) {
				
				arguments.data.payload.remoteAccountID = arguments.entity.getAccountID();
				}
				
				var accountUpdation = getAccountDAO().getUpdateRemoteIDForNewAccount(
					accountID = arguments.entity.getAccountID() , 
					remoteID = response.rowids[1] , 
					importRemoteID = this.genericCreateEntityImportRemoteID( arguments.data.payload , this.getEntityMapping( 'Account' )) );
					
				logHibachi("ERPOne - Successfully updated Slatwall account with accountID #arguments.entity.getAccountID()#");
				
				if( structKeyExists(arguments.data.sycontactData, 'First_Name') && !this.hibachiIsEmpty(arguments.data.sycontactData.First_Name) ){
					var sycontactPayload = {
					  "table"	 : "sy_conatct",
					  "triggers" : "true",
					  "records"	 : [ arguments.data.sycontactData ]
					};
					
					var sy_conatctUpdateresponse = this.callErpOneUpdateDataApi(sycontactPayload, "create" );
					
					/** Format error:
					 * typical error response: { "errordetail": "error", "filecontent": "null"};
					 * typical successful response: {"table":"customer","updated":1,"triggers":false}
					*/
				
					if( structKeyExists(sy_conatctUpdateresponse, 'created') && sy_conatctUpdateresponse.created > 0 ){
						logHibachi("ERPOne - Successfully created Sy_contact Data with rowID #response.rowids[1]#");
					}
					else {
						throw("ERPONE - callErpOnePushSy_contactApi: API responde is not valid json for request: #Serializejson(arguments.data.payload)#");
					}
				}
			
			}
			else {
				throw("ERPONE - callErpOnePushAccountApi: API responde is not valid json for request: #Serializejson(arguments.data.payload)#");
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
			
			arguments.data.ProductCode=reReplace(reReplace(arguments.data.ProductCode, "(\\|/)", "--", "all" ),"\s", "__", "all");
		}

		if( !structKeyExists(arguments.data, 'SkuCode') || this.hibachiIsEmpty( arguments.data.SkuCode ) ){
			
			arguments.data.SkuCode = arguments.data.ProductCode;
		}else{
			
			arguments.data.SkuCode = Replace(arguments.data.SkuCode, " " , "--");
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
	
	public any function preProcessAccountData(required struct data ){
		logHibachi("ERPONE - called getSy_contactAccountData");
		// comment out the functionallity as we dont have data for DC on dev DB
		
		// Change company name as per our environment in API query
		// if( !this.setting("devMode") ){
		// var requestQuery = 'FOR EACH sy_contact WHERE sy_contact.company_sy = "SB" AND sy_contact.contact_type = "customer" AND sy_contact.contact = "'&arguments.data.customer&'"';
		// } else {
		// 	var requestQuery = 'FOR EACH sy_contact WHERE sy_contact.company_sy = "DC" AND sy_contact.contact_type = "customer" AND sy_contact.contact = "'&arguments.data.customer&'"';
		// }
		var requestQuery = 'FOR EACH sy_contact WHERE sy_contact.company_sy = "SB" AND sy_contact.contact_type = "customer" AND sy_contact.contact = "'&arguments.data.customer&'"';	
    	var syAccountsArray = this.callErpOneGetDataApi({
			"query": requestQuery,
    	    "columns" : "First_Name,Last_Name,key1,key2,contact,adr[1],adr[2],adr[3],adr[4],adr[5],country_code,cell,contact_type,state,postal_code"
    	})
    	
    	if(!this.hibachiIsEmpty(syAccountsArray)){
    		syAccountsArray = syAccountsArray[1];
    		arguments.data.append(syAccountsArray, false);
    		
	    	if( !structKeyExists(arguments.data, 'First_Name') || this.hibachiIsEmpty(arguments.data.First_Name) ) {
				
				arguments.data.First_Name = arguments.data.key1;
			}
			
			if( !structKeyExists(arguments.data, 'phone') || this.hibachiIsEmpty(arguments.data.phone) ) {
				
				arguments.data.phone = arguments.data.cell;
			}
			
			if( !structKeyExists(arguments.data, 'remoteAccountAddressID') || this.hibachiIsEmpty(arguments.data.remoteAccountAddressID) ) {
				
				arguments.data["accountAddressID"] = arguments.data.__rowids;
			}
			
			if( !structKeyExists(arguments.data, 'remoteAddressID') || this.hibachiIsEmpty(arguments.data.remoteAddressID) ) {
				
				arguments.data["addressID"] = arguments.data.__rowids;
			}
			
			if( !structKeyExists(arguments.data, 'addressName') || this.hibachiIsEmpty(arguments.data.addressName) ) {
				
				arguments.data["addressName"] = "Default";
			}
    	}
    	
		if( !structKeyExists(arguments.data, 'First_Name') || this.hibachiIsEmpty(arguments.data.First_Name) ) {
				
				arguments.data.organizationFlag = true;
		}
		
		if( !structKeyExists(arguments.data, 'Last_Name') || this.hibachiIsEmpty(arguments.data.Last_Name) ) {
				
				arguments.data["organizationFlag"] = true;
		}
		var erponeMapping = {
	        "__rowids" : "remoteAccountID",
	         "country_code" : "countryCode",
	        "customer" : "companyCode",
	        "email_address" : "email",
	        "phone" : "phone",
	        "Active" : "accountActiveFlag",
	        "name" : "companyName",
	        "First_Name" : "firstName",
	        "Last_Name" : "lastName",
	        "cell" : "phone1",
	        "adr_1" : "streetAddress",
	        "adr_2" : "street2Address",
	        "adr_4" : "city",
	        "state" : "stateCode",
	        "postal_code" : "postalCode",
	        "organizationFlag" : "organizationFlag",
	        "accountAddressID" : "remoteAccountAddressID",
	        "addressID" : "remoteAddressID",
	        "addressName" : "name"
	        
	    };
	    
		var transformedItem = this.transformedErponeItem( arguments.data, erponeMapping);
	    return transformedItem;
	}
	
	public any function preProcessOrderData(required struct data ){
		
		if( left(arguments.data.order, 1) == '-' ){
			return;
		}
			var erponeMapping = {
		        "order" 		: "orderNumber",
		        "ord_date"		: "orderOpenDateTime",
		        "customer"		: "RemoteAccountID",
		        "currency_code" : "currency_code",
		        "country_code"  : "BillingAddress_countryCode",
		        "postal_code"	: "BillingAddress_postalCode",
		        "adr"			: "Address",
		        "state" 		: "BillingAddress_stateCode"
		    };

	    	var transformedItem = {};

	    	for( var sourceKey in erponeMapping ){
	    		var destinationKey = erponeMapping[ sourceKey ];

	    		if( structKeyExists(arguments.data, sourceKey) ){
	        	    transformedItem[ destinationKey ] = arguments.data[ sourceKey ];
	    		}

	    	}

	    	transformedItem.remoteOrderID = transformedItem.OrderNumber;
	    	transformedItem.BillingAddress_streetAddress = transformedItem.Address[2];
	    	transformedItem.BillingAddress_street2Address = transformedItem.Address[1];
	    	transformedItem.BillingAddress_city = transformedItem.Address[4];
			transformedItem.Address = {
					  "streetAddress"  : transformedItem.Address[2],
	                  "street2Address" : transformedItem.Address[1],
	                  "city"           : transformedItem.Address[4],
	                  "countryCode"	   : transformedItem.BillingAddress_countryCode,
	                  "stateCode"	   : transformedItem.BillingAddress_stateCode,
	                  "postalCode"	   : transformedItem.BillingAddress_postalCode,
			};
		    return transformedItem;
	}
	
	public any function preProcessOrderItemData(required struct data ){

		if( left(arguments.data.order, 1) == '-' ){
			return;
		}
			var erponeMapping = {
		        "order" : "RemoteOrderID",
		        "price" : "Price",
		        "list_price" : "SkuPrice",
		        "item" : "RemoteSkuID",
		        "line" : "Line"
		    };

	    	var transformedItem = {};

	    	for( var sourceKey in erponeMapping ){
	    		var destinationKey = erponeMapping[ sourceKey ];

	    		if( structKeyExists(arguments.data, sourceKey) ){
	        	    transformedItem[ destinationKey ] = arguments.data[ sourceKey ];
	    		}

	    	}

	    	transformedItem.remoteOrderItemID = transformedItem.RemoteOrderID&"_"&transformedItem.Line;
		    return transformedItem;
	}
}
