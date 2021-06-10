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
	property name="skuService";
	
	property name="accountDAO" type="any";
	property name= "addressService";
	
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
		getService('hibachiTagService').cfsetting(requesttimeout=100000);
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

	public any function debugDataApi( required struct requestData, string endpoint="data/read", string requestType = "POST" ){
		getService('hibachiTagService').cfsetting(requesttimeout=100000);
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
	
	
	public any function callErpOneUpdateDataApi( required any requestData, string endpoint="create" ){
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
	

	public any function getOrderData(numeric pageNumber = 1, numeric pageSize = 50 ){
		logHibachi("ERPONE - called getOrderData with pageNumber = #arguments.pageNumber# and pageSize= #arguments.pageSize#");
		//still working to get order numbers without hyphen so pass one order for testing
		var OrdersArray = this.callErpOneGetDataApi({
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
		var OrdersArray = this.callErpOneGetDataApi({
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
		
		
		//Change company name as per our environment in API query
	//	if( !this.setting("devMode") ){
		 var requestQuery = 'FOR EACH customer WHERE customer.active = YES AND customer.company_cu = "SB"';
	//	} else {
	//		var requestQuery = 'FOR EACH customer WHERE customer.active = YES AND customer.company_cu = "DC"';
	//	}
	
		var pageNumber = 1;
		var pageSize = 1000;
		var hasPages = true;
		
		
		var formatedAccounts = [];
		
		while(hasPages){
			
			logHibachi("ERPONE - Paginating #pageNumber#");
			
			var accountsArray = this.callErpOneGetDataApi({
				"skip" : ( pageNumber - 1 ) * pageSize,
				"take" : pageSize,
				"query": requestQuery,
				"columns" : "name,country_code,email_address,phone,Active,company_cu,customer,tax_code,adr[1],adr[2],adr[3],adr[4],adr[5],state,postal_code"
			});
			
			
			logHibachi("ERPONE - skip #( pageNumber - 1 ) * pageSize# | take: #pageSize# = Returned : #arrayLen(accountsArray)#");
			for(var account in accountsArray){
				
				var accountData =  {
					"remoteAccountID" : account['__rowids'],
					"remoteAccountAddressID" : account['__rowids'],
					"remoteAddressID" : account['__rowids'],
					"firstName" : account['name'],
					"lastName" : "",
					"companyName" : account['name'],
					"phoneNumber" : account['phone'],
					"companyCode" : account['customer'],
					"taxExemptFlag" : account['tax_code'] == 'EXEMPT',
					"organizationFlag" : true,
					"addressNickName" : "Default",
					"streetAddress" : account['adr_1'],
					"street2Address" : "",
					"city" : account['adr_4'],
					"stateCode" : account['state'],
					"postalCode" : account['postal_code'],
					"countryCode" : "US"
				};
				
				if(len(account['email_address'])){
					accountData['email'] = account['email_address'];
				}
	
				var syAccountsArray = this.callErpOneGetDataApi({
					"query": 'FOR EACH sy_contact WHERE sy_contact.company_sy = "SB" AND sy_contact.contact_type = "customer" AND sy_contact.key1 = "'&account.customer&'"',
					"columns" : "First_Name,Last_Name,key1,key2,contact,cell,contact_type"
				});
				
				
				if(arrayLen(syAccountsArray)){
					accountData['remoteContactID'] = syAccountsArray[1]['__rowids'];
					if(len(syAccountsArray[1]["First_Name"])){
						accountData["firstName"] = syAccountsArray[1]["First_Name"];
					}
					
					if(len(syAccountsArray[1]["Last_Name"])){
						accountData["lastName"] = syAccountsArray[1]["Last_Name"];
					}
					
					if(!len(accountData['phoneNumber']) && len(syAccountsArray[1]["cell"])){
						accountData["phoneNumber"] = syAccountsArray[1]["cell"];
					}
				}
				
				dd(accountData);
				arrayAppend(formatedAccounts,accountData)
			}
			
			if(arrayLen(accountsArray) < pageSize){
				hasPages = false;
			}
			pageNumber++;
			
		}
		if(arrayLen(formatedAccounts)){
			this.pushRecordsIntoImportQueue( "Account", formatedAccounts );
		}
		
		this.logHibachi("ERPONE - Finish importing Accounts");
	}
	
	public any function importErpOneOrders(){
		
		logHibachi("ERPONE - Starting importing importErpOneOrders");
			
		var response = this.callErpOneGetDataApi({
			"table" : "oe_head"
		}, "data/count");
		
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

		var response = this.callErpOneGetDataApi({
			"table" : "oe_line"
		}, "data/count");
		
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
	
	
	/**
	 * @hint helper function, to push Data into @thisIntegration/Data.cfc for further processing, from EntityQueue
	 * 
	**/ 
	public void function pushAccountDataToErpOne(required any entity, any data ={}){
		logHibachi("ERPOne - Start pushData - Account: #arguments.entity.getAccountID()#");
		
		var customerChanges = {
			"name" : arguments.entity.getFirstName()&" "&arguments.entity.getLastName(),
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
					"records" : [ {
					"company_cu" : this.setting("devMode") ? this.setting("devCompany") : this.setting("prodCompany"),
					"customer" : arguments.entity.getCompanyCode()
					} ]
					}, "create" );
					entity.setRemoteContact(contactResponse.rowids[1]);
					
					logHibachi("ERPOne - Successfully created cu_prospect on Erpone with rowID #prospectResponse.rowids[1]#");
					
				} else {
					throw("ERPONE - callErpOnePushSy_contactApi: API response is not valid json");
				}
				
			
			} else {
				throw("ERPONE - callErpOnePushAccountApi: API response is not valid json for request: #Serializejson(arguments.data.payload)#");
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
		logHibachi("ERPOne - Start pushData - Order: #arguments.entity.getOrderID()#");
		

		var isDevModeFlag = this.setting("devMode");
		if(!len(arguments.entity.getRemoteID())){
			
			
			
			arguments.data.payload = {
				'order' : arguments.entity.getOrderNumber(),
				'order_ext' : arguments.entity.getOrderNumber(),
	            'customer' : arguments.entity.getAccount().getCompanyCode(),
			}
			
			
			for(var orderPayment in arguments.entity.getOrderPayments()) {
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
				arguments.entity.setRemoteID(response.rowids[1]);
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
				var lineNumber = 1;
				for(var orderItem in arguments.entity.getOrderItems()){
					if(len(orderItem.getRemoteID())){
						continue;
					}
					orderItem.setRemoteID(response.rowids[lineNumber]);
					lineNumber++;
					
				}
			}
		}
		logHibachi("ERPOne - End Order pushData");
	}
	
	public any function preProcessOrderData(required struct data ){
		//dump(data);abort;
		if( left(arguments.data.order, 1) == '-' ){
			return;
		}
		var erponeMapping = {
			"order" 		: "orderNumber",
			"ord_date"		: "orderOpenDateTime",
			"customer"		: "RemoteAccountID",
			"currency_code" : "currency_code",
			"country_code"  : "countryCode",
			"postal_code"	: "postalCode",
			"adr"			: "Address",
			"state" 		: "stateCode"
		};
		
		var transformedItem = this.transformedErponeItem( arguments.data, erponeMapping);
		transformedItem.remoteOrderID = transformedItem.OrderNumber;
		transformedItem["FullAddress"] = {
				  "streetAddress"  : transformedItem.Address[2],
				  "street2Address" : transformedItem.Address[1],
				  "city"           : transformedItem.Address[4],
				  "countryCode"	   : transformedItem.countryCode,
				  "stateCode"	   : transformedItem.stateCode,
				  "postalCode"	   : transformedItem.postalCode,
		};
		
		//Billing address transform data
		transformedItem["BillingAddress_remoteAddressID"] = "bill_"&transformedItem.OrderNumber;
		transformedItem["BillingAddress_name"]			  = getAddressService().getAddressName(transformedItem.FullAddress);
		transformedItem["BillingAddress_streetAddress"]   = transformedItem.Address[2];
		transformedItem["BillingAddress_street2Address"]  = transformedItem.Address[1];
		transformedItem["BillingAddress_city"]     	      = transformedItem.Address[4];
		transformedItem["BillingAddress_countryCode"]     = transformedItem.countryCode;
		transformedItem["BillingAddress_stateCode"]	      = transformedItem.stateCode;
		transformedItem["BillingAddress_postalCode"]	  = transformedItem.postalCode;
		
		//Shipping address transform data
		transformedItem["ShippingAddress_remoteAddressID"] 		= "ship_"&transformedItem.OrderNumber;
		transformedItem["ShippingAddress_name"]					= getAddressService().getAddressName(transformedItem.FullAddress);
		transformedItem["ShippingAddress_streetAddress"]   		= transformedItem.Address[2];
		transformedItem["ShippingAddress_street2Address"]  		= transformedItem.Address[1];
		transformedItem["ShippingAddress_city"]     			= transformedItem.Address[4];
		transformedItem["ShippingAddress_countryCode"]	    	= transformedItem.countryCode;
		transformedItem["ShippingAddress_stateCode"]	    	= transformedItem.stateCode;
		transformedItem["ShippingAddress_postalCode"] 			= transformedItem.postalCode;
		
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

		var transformedItem = this.transformedErponeItem( arguments.data, erponeMapping);
		
		transformedItem.remoteOrderItemID = transformedItem.RemoteOrderID&"_"&transformedItem.Line;
		return transformedItem;
	}
	
	public any function preProcessInventoryData(required struct data ){
	var erponeMapping = {
			"item" 			: "remoteSkuID",
			"warehouse"		: "remoteLocationID",
			"available"		: "quantityIn"
		};

	var transformedItem = this.transformedErponeItem( arguments.data, erponeMapping);
	if( structKeyExists(transformedItem, 'remoteSkuID') ){
			
			transformedItem.remoteSkuID=reReplace(reReplace(transformedItem.remoteSkuID, "(\\|/)", "--", "all" ),"\s", "__", "all");
			transformedItem.remoteInventoryID=transformedItem.remoteLocationID&"--"&reReplace(reReplace(transformedItem.remoteSkuID, "(\\|/)", "--", "all" ),"\s", "__", "all");
	}
	return transformedItem;
	}
}
