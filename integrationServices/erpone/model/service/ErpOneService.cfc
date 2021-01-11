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
	
	property name="integrationService";
	property name="erpOneIntegrationCFC";
	property name="hibachiCacheService";
	property name="hibachiDataService";
	property name="hibachiUtilityService";
	
	public any function getIntegration(){
	    if( !structKeyExists( variables, 'integration') ){
	        variables.integration = this.getIntegrationByIntegrationPackage('erpone');
	    }
        return variables.integration;
    }
	
	public struct function getAvailableSampleCsvFilesIndex(){
  	    
  	    if( !structKeyExists(variables, 'availableSampleCsvFilesIndex') ){
  	        
            //creating struct for fast-lookups
            variables.sampleCSVFilesOptions = {
                "Sku"   		: "sku",
                "Product"		: "product"
                
            };
            // TODO, need a way to figureout which entity-mappings are allowed to be import, 
            // Account vs account-phone-number
  	    }
  	    
  	    return variables.sampleCSVFilesOptions;
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

			    var batch = this.pushRecordsIntoImportQueue( data.entityName, result.query );
			    
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
			createAndSetGrantToken();
		}
		return getHibachiCacheService().getCachedValue('grantToken');
    }
    
    public any function getAccessToken(){
		if(!getHibachiCacheService().hasCachedValue('accessToken')){
			createAndSetAccessToken();
		}
		return getHibachiCacheService().getCachedValue('accessToken');
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
    
    
    
        
    public any function createHttpRequest(required string endPointUrl, string requestType="POST"){
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
    	httpRequest.addParam( type='header', name='Content-Type', value='application/x-www-form-urlencoded');
    	return httpRequest;
    }
    
    public any function getErpOneData( required struct requestData, string endpoint="read" ){
        
    	var httpRequest = this.createHttpRequest('distone/rest/service/data/'&arguments.endpoint);
		
		// Authentication headers
		httpRequest.addParam( type='header', name='authorization', value=this.getAccessToken() );
		
		for( var key in arguments.requestData ){
		    httpRequest.addParam( type='formfield', name= key, value = arguments.requestData[key] );
		}
		
        var rawRequest = httpRequest.send().getPrefix();
        
        if( !IsJson(rawRequest.fileContent) ){
		    throw("ERPONE - getErpOneData: API responde is not valid json for request: #Serializejson(arguments.requestData)# response: #rawRequest.fileContent#");
		}
			
	    return DeSerializeJson(rawRequest.fileContent);
    }
    
    	
	public array function transformedErpOneItems(required array items, required struct erponeMapping ){
		var transformedData = [];
		
	    for( var thisItem in arguments.items ){
	    	
	    	var transformedItem = {};
	    	
	    	for( var sourceKey in arguments.erponeMapping ){
	    		var destinationKey = arguments.erponeMapping[ sourceKey ];
	    		
	    		if( structKeyExists(thisItem, sourceKey) ){
	        	    transformedItem[ destinationKey ] = thisItem[ sourceKey ];
	    		}
	    		
	    	}
	    	
	    	transformedData.append(transformedItem);
	    }
	    
	    return transformedData;
	}
    
    public any function getAccountData(numeric pageNumber = 1, numeric pageSize = 50 ){
    	logHibachi("ERPONE - called getAccountData with pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");

    	var accountsArray = this.getErpOneData({
    	    "skip" : ( arguments.pageNumber - 1 ) * arguments.pageSize,
    	    "take" : arguments.pageSize,
    	    "query": "FOR EACH customer WHERE customer.active = YES",
    	    "columns" : "name,country_code,email_address,phone,Active,company_cu,customer"
    	})
    	
		
		if( accountsArray.len() > 0 ){
		
		    this.logHibachi("ERPONE - Start pushing accounts to import-queue ");
			var batch = this.pushRecordsIntoImportQueue( "Account", this.transformErpOneAccounts( accountsArray ) );
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
    
	public any function transformErpOneAccounts( required array accountDataArray ){
	    var erponeMapping = {
	        "__rowids" : "remoteAccountID",
	         "country_code" : "countryCode",
	        "customer" : "companyCode",
	        "email_address" : "email",
	        "phone" : "phone",
	        "Active" : "accountActiveFlag",
	        "name" : "companyName"
	    };
	    
	    return this.transformedErponeItems( arguments.accountDataArray, erponeMapping);
	}
	
	public any function importErpOneAccounts(){
		
		logHibachi("ERPONE - Starting importing importErpOneAccounts");
		
		var response = this.getErpOneData({
    	    "table" : "customer"
    	}, "count");
    	
		var totalRecordsCount = response.count;
		var currentPage = 1;
		var pageSize = 50;

		var recordsFetched = 0;
		
		while ( recordsFetched < totalRecordsCount ){
			
			try {
				
				this.getAccountData( currentPage, pageSize	);
				this.logHibachi("Successfully called getAccountData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				
			} catch(e){
			
				this.logHibachi("Got error while trying to call getAccountData for CurrentPage: #currentPage# and PageSize: #pageSize#");
				this.getHibachiUtilityService().logException(e);
			}
			
			// increment rgardless of success or failure;
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
			// var remoteProductIDArray = this.getErpOneData({
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
