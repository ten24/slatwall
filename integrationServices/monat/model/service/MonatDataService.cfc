component extends="Slatwall.model.service.HibachiService" accessors="true" {
    property name="productService";
	property name="settingService";
	property name="addressService";
	property name="accountService";
	property name="typeService";
	property name="settingService";
	property name="integrationService";
	property name="siteService";
	property name="promotionService";
	property name="orderService";
	property name="priceGroupService";
	property name="commentService";
	property name="skuService";
	property name="paymentService";
	property name="locationService";
	property name="stockService";
	property name="fulfillmentService";
	property name="shippingService";
	property name="inventoryService";
	
    // @hint helper function to return the integration
    public any function getIntegration(){
        return getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
    }
    
    // @hint helper function to return the packagename of this integration
	public any function getPackageName() {
		return lcase(listGetAt(getClassFullname(), listLen(getClassFullname(), '.') - 2, '.'));
	}
    
    // @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(structKeyExists(getIntegration().getSettings(), arguments.settingName)) {
			return getService('settingService').getSettingValue(settingName='integrationMonat#arguments.settingName#', object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
		}
		return getService('settingService').getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}
	
    public array function getProductReviews(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.productID" default="";
        
        if(!len(arguments.data.productID)){
            return [];
        }
        
        var productReviewCollection = getProductReviewCollection(arguments.data);

        return productReviewCollection.getPageRecords();
    }
    
    public struct function getMarketPartners(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";
        
        if(isNull(arguments.data.search) && isNull(arguments.data.stateCode)){
            return [];
        }
        
        var marketPartnerCollection = this.getAccountCollection(arguments.data);
        
        return this.getAccountCollection(arguments.data);
    }
    
    private any function getAccountCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";

        var accountCollection = getService('HibachiService').getAccountCollectionList();
        
        var searchableDisplayProperties = 'accountNumber,firstName,lastName,userName';
        accountCollection.setDisplayProperties(searchableDisplayProperties, {isSearchable=true, comparisonOperator="exact"});
        accountCollection.addDisplayProperty('accountID','accountID', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.city','primaryAddress_address_city', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.countryCode','primaryAddress_address_countryCode', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.stateCode','primaryAddress_address_stateCode', {isVisible:true, isSearchable:false});
        accountCollection.addFilter( 'accountNumber', 'NULL', 'IS NOT');
        accountCollection.addFilter( 'accountStatusType.typeID', '2c9180836dacb117016dad11ebf2000e'); //'astGoodStanding'
        
        if(arguments.data.accountSearchType == 'VIP'){
            accountCollection.addFilter(
                propertyIdentifier = 'accountType', 
                value = 'VIP', 
                filterGroupAlias = 'accountTypeFilter'
            );
            
            accountCollection.addFilter(
                propertyIdentifier = 'accountType', 
                value = 'marketPartner', 
                logicalOperator = 'OR',
                filterGroupAlias = 'accountTypeFilter'
            );
        }

        if(arguments.data.accountSearchType == 'marketPartner'){
          accountCollection.addFilter('accountType', 'marketPartner', '=');  
        }
        
        if ( len( arguments.data.countryCode ) &&  (!getHibachiScope().hasSessionValue('ownerAccountNumber') || !len( getHibachiScope().getSessionValue('ownerAccountNumber')))) {
            accountCollection.addFilter( 'primaryAddress.address.countryCode', arguments.data.countryCode );
        }
        
        if ( len( arguments.data.stateCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.stateCode', arguments.data.stateCode );
        }
        if(!isNull(arguments.data.search) && len(arguments.data.search)){
         
            accountCollection.setKeywords(arguments.data.search);
        }
        
        
        accountCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        accountCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        
        //Just to remove Order By CreatedDateTime
        accountCollection.addOrderBy('accountType|ASC');
        
        var pageRecords = accountCollection.getPageRecords(formatRecords=false);
        var recordsCount = arrayLen(pageRecords);
        
        if(recordsCount == arguments.data.pageRecordsShow){
            recordsCount = accountCollection.getRecordsCount();
        }
        
        var returnObject = {
            accountCollection: pageRecords,
            recordsCount: recordsCount
        }
        return returnObject; 
    }
    
    public numeric function getProductReviewCount(required struct data){
        var productReviewCollection = getProductReviewCollection(arguments.data);
        return productReviewCollection.getRecordsCount();
    }
    
    private any function getProductReviewCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=5;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.productID" default="";
        
        var productReviewCollection = getService('productService').getProductReviewCollectionList();
        productReviewCollection.setDisplayProperties('reviewerName,review,rating,createdDateTime');
        productReviewCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        productReviewCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        productReviewCollection.addFilter("product.productID", arguments.data.productID, "=");
        productReviewCollection.addFilter("activeFlag", 1, "=");
        productReviewCollection.addFilter("productReviewStatusType.typeID", "9c60366a4091434582f5085f90d81bad");
        return productReviewCollection;
    }
    //getOrderUpdatesData
    
	public any function getDateFromString(date) {
		return	createDate(
			datePart("yyyy",date), 
			datePart("m",date),
			datePart("d",date));
	}
	
	private any function getData(pageNumber,pageSize,dateFilterStart,dateFilterEnd,endpoint){
		logHibachi("getData - #endpoint# between #dateFilterStart# - #dateFilterEnd#", true); 
	    var uri = setting('baseImportURL') & endpoint;
		var authKeyName = "authkey";
		var authKey = setting(authKeyName);
	    var fsResponse = {hasErrors: false};
	    var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#pageNumber#"
			},
			"Filters": {
			    "StartDate": arguments.dateFilterStart,
	            "EndDate": arguments.dateFilterEnd
			}
		};

	    httpService = new http(method = "POST", charset = "utf-8", url = uri);
		httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
		httpService.addParam(name = "Accept", type = "header", value = "text/plain");
		httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");

		var shipmentJson = httpService.send().getPrefix();
		var apiData = deserializeJson(shipmentJson.fileContent);

		if (structKeyExists(apiData, "Data") && structKeyExists(apiData.Data, "Records")){
			fsResponse = apiData.Data;
			fsResponse.hasErrors = false;
		    return fsResponse;
		}
writedump(apiData); abort;
		logHibachi("Could not import #endpoint#(s) on this page: PS-#arguments.pageSize# PN-#pageNumber#", true);
		fsResponse.hasErrors = true;


		return fsResponse;
	}
	
	private any function getShippingMethod(required string shipMethodCode) {
		if(!structKeyExists(variables, "shippingMethods")) {
			variables.shippingMethods = {};
		}
		if(!structKeyExists(variables.shippingMethods, arguments.shipMethodCode)) {
			variables.shippingMethods[arguments.shipMethodCode] = getShippingService().getShippingMethodByShippingMethodCode(arguments.shipMethodCode);
		}
		return variables.shippingMethods[arguments.shipMethodCode];
	}
	
	
	private any function getLocation(required string currencyCode) {
		if(!structKeyExists(variables, "locationStruct")) {
			variables.locationStruct = {};
		}
		if(!structKeyExists(variables.locationStruct, arguments.currencyCode)) {
			variables.locationStruct[arguments.currencyCode] = getLocationService().getLocationByCurrencyCode(arguments.currencyCode);
		}
		return variables.locationStruct[arguments.currencyCode];
	}
	
	
	
	public void function importOrderShipments(){ 
		param name="arguments.rc.pageNumber" default=1;
		param name="arguments.rc.pageSize" default=50;
		param name="arguments.rc.hours" default=1;


		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		
		logHibachi("importOrderShipments - Start", true);

		if(!structKeyExists(arguments.rc, 'pageMax')){
			var response = getData(
				pageNumber = arguments.rc.pageNumber,
				pageSize = arguments.rc.pageSize,
				dateFilterStart = DateTimeFormat( DateAdd('h', arguments.rc.hours * -1, now()), "yyyy-mm-dd'T'HH:NN:SS'.000Z'" ),
				dateFilterEnd = DateTimeFormat( now(), "yyyy-mm-dd'T'HH:NN:SS'.000Z'" ),
			endpoint = 'SWGetShipmentInfo'
			);
			arguments.rc.pageMax = response.totalPages ?: 0;
		}
		
		logHibachi("importMonatProducts - Total Pages: #arguments.rc.pageMax#", true);
		
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		var tx = ormStatelessSession.beginTransaction();

        var SHIPPED = getTypeService().getTypeByTypeName("Shipped");
        
		for(var index = arguments.rc.pageNumber; index <= arguments.rc.pageMax; index++){
			var persist = false;
		    
		    logHibachi("importMonatProducts - Current Page #index#", true); 
			var shipmentResponse = getData(
				pageNumber = arguments.rc.pageNumber,
				pageSize = arguments.rc.pageSize,
				dateFilterStart = DateTimeFormat( DateAdd('h', arguments.rc.hours * -1, now()), "yyyy-mm-dd'T'HH:NN:SS'.000Z'" ),
				dateFilterEnd = DateTimeFormat( now(), "yyyy-mm-dd'T'HH:NN:SS'.000Z'" ),
				endpoint = 'SWGetShipmentInfo'
			);
			
			for(var shipment in shipmentResponse['Records'] ){
				
				logHibachi("importOrderShipments - Checking: #shipment.shipmentNumber#", true);
				
				if(isNull(shipment.OrderNumber) || isNull(shipment.Packages) || !len(shipment.OrderNumber) || !arrayLen(shipment.Packages) || !arrayLen(shipment.Items)){
					logHibachi("importOrderShipments - Delivery #shipment.shipmentId# required data missing", true);
					continue;
				}
				
				var countOrderDelivery = QueryExecute('SELECT count(*) total FROM sworderdelivery WHERE remoteID = :remoteID',{ 
					 'remoteID' = { value=shipment.shipmentId, cfsqltype="cf_sql_varchar"},
				});
				
				if(countOrderDelivery['total'] > 0){
					logHibachi("importOrderShipments - Delivery #shipment.shipmentId# Already Exists - Order Number:#shipment.orderNumber#", true);
					continue;
				}
				
				logHibachi("importOrderShipments - Creating: #shipment.shipmentId#", true);
				
				var order = getOrderService().getOrderByOrderNumber(shipment.OrderNumber);
				if(isNull(order)){
					logHibachi("importOrderShipments - Delivery #shipment.shipmentId# Order Not Found - Order Number:#shipment.orderNumber#", true);
					continue;
				}
				
				
				logHibachi("importOrderShipments - Creating OrderDelivery: #shipment.shipmentId#", true);
				
				try{
    				var shippingMethod = getShippingMethod(shipment.ShipMethodCode);
    				var location = getLocation(order.getCurrencyCode());
				}catch(any e){
					logHibachi("importOrderShipments - OrderDelivery #shipment.shipmentId# error getting shipment: #shipment.ShipMethodCode# or location: #order.getCurrencyCode()#", true);
					continue;
				}
				
				
				// Create the delivery.  
                var orderDelivery = new Slatwall.model.entity.OrderDelivery();
                
                orderDelivery.setRemoteID( shipment.shipmentId );
    			orderDelivery.setOrder( order );
    			orderDelivery.setModifiedDateTime( now() );
                orderDelivery.setShippingMethod( shippingMethod );
                orderDelivery.setFulfillmentMethod( shippingMethod.getFulfillmentMethod() );
    			
    			if(!isNull(shipment.shipmentNumber)){
    				orderDelivery.setShipmentNumber( shipment.shipmentNumber );
    			}
    			if(!isNull(shipment.orderShipSequence)){
    				orderDelivery.setShipmentSequence( shipment.orderShipSequence );
    			}
    			if(!isNull(shipment.PONumber)){
    				orderDelivery.setPurchaseOrderNumber( shipment.PONumber );
    			}
    			
    			if(!isNull(shipment.Packages[1]['ScanDate'])){
    				orderDelivery.setScanDate( getDateFromString( shipment.Packages[1]['ScanDate'] ) );
    			}
    			if(!isNull(shipment.Packages[1]['UndeliveredReasonDescription'])){
    				orderDelivery.setUndeliverableOrderReason( shipment.Packages[1]['UndeliveredReasonDescription'] );
    			}
    			if(!isNull(shipment.Packages[1]['PackageShipDate'])){
    				orderDelivery.setCreatedDateTime( getDateFromString( shipment.Packages[1]['PackageShipDate'] ) );
    			}
    			
    			if(!isNull(shipment.Packages[1]['TrackingNumber'])){
    				orderDelivery.setTrackingNumber( shipment.Packages[1]['TrackingNumber'] );
    		    	var trackingUrl = orderDelivery.getShippingMethod().setting("shippingMethodTrackingURL");
    		    	if (!isNull(trackingUrl)){
						trackingUrl = trackingUrl.replace("${trackingNumber}", orderDelivery.getTrackingNumber());
						orderDelivery.setTrackingURL( trackingUrl );
					}
    			}
                ormStatelessSession.insert("SlatwallOrderDelivery", orderDelivery );
                persist = true;
                
                
                for(var item in shipment.Items){

					var orderItem = ormExecuteQuery("FROM SlatwallOrderItem where sku.skuCode = :skuCode AND order.orderID= :orderID", {
						skuCode = item.ItemCode, 
						orderID = order.getOrderID()
					}, true);
					
					if(isNull(orderItem)){
						continue;
					}
                	
                	var orderDeliveryItem = new Slatwall.model.entity.OrderDeliveryItem();
		            orderDeliveryItem.setQuantity(item['QuantityShipped']);
		            //get Order Item by skuID and OrderID
		            
		            orderDeliveryItem.setOrderItem(orderItem);
		            orderDeliveryItem.setOrderDelivery(orderDelivery);
		            
		             //now try to find the stock to attach
		            var stock = orderItem.getStock();
		            
		            if (isNull(stock)){
		                stock = getStockService().getStockBySkuAndLocation(orderItem.getSku(), location);
		            }
		            
		            orderDeliveryItem.setStock(stock);
		            
		            
					ormStatelessSession.insert("SlatwallOrderDeliveryItem", orderDeliveryItem);
					
					orderItem.setCalculatedQuantityDelivered(val(orderItem.getCalculatedQuantityDelivered()) + item['QuantityShipped']);
					orderItem.setCalcQtyDeliveredMinusReturns(val(orderItem.getCalcQtyDeliveredMinusReturns()) + item['QuantityShipped']);
                }
                
                logHibachi("importOrderShipments - Created a delivery for orderNumber: #shipment['OrderNumber']#",true);
                
                // Close the order.
                //now fire the event for this delivery.
                var eventData = {entity: orderDelivery};
                getHibachiScope().getService("hibachiEventService").announceEvent(eventName="afterOrderDeliveryCreateSuccess", eventData=eventData);
				order.setOrderStatusType(SHIPPED);
			}
			if(persist){
				tx.commit();
				ormGetSession().clear();
			}
		
		}
		ormStatelessSession.close();
		
		
	}
    
    public any function importAccountUpdates(){
        //get the api key from integration settings.
		var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		var index=0;
		var HOURS = 'h';
        
        /**
         * Allows the user to override the last h HOURS that get checked. 
         * Defaults to 60 Minutes ago.
         **/
        var intervalOverride = 1;
        
        /**
         * The page number to start with 
         **/
        var pageNumber = 1;
        
        /**
         * How many records to process per page. 
         **/
		var pageSize = 50;
		
		/**
		 * the page number to end on (exclusive) 
		 **/
		var pageMax = 2;
		
		/**
		 * The date and time from an hour ago.
		 **/
		var sixtyMinutesAgo = DateAdd(HOURS, -intervalOverride, now());
		
		/**
		 * The string representation for the date twenty minutes ago. 
		 * Uses number format to make sure each minute, second will use 2 places.
		 * This checks for the last hour of deliveries every 15 minutes.
		 * This only adds a delivery IF its not already delivered, so we can do that.
		 * 
		 **/
	    var dateFilterStart = "#year(sixtyMinutesAgo)#-#numberFormat(month(sixtyMinutesAgo),'00')#-#numberFormat(day(sixtyMinutesAgo),'00')#T#numberformat(hour(sixtyMinutesAgo),'00')#:#numberformat(minute(sixtyMinutesAgo), '00')#:#numberformat(second(sixtyMinutesAgo), '00')#.693Z";
	
		/**
		 * This should always equal now.
		 **/
        var dateFilterEnd =  "#year(now())#-#numberFormat(month(now()),'00')#-#numberFormat(day(now()),'00')#T#numberFormat(hour(now()),'00')#:#numberformat(minute(now()), '00')#:#numberformat(second(now()), '00')#.693Z";
	
		/*"CurrentPage": 1,
        "TotalCount": 2068008,
        "PageSize": 25,
        "TotalPages": 82721,*/
        
        logHibachi("Start Account Updater", true);
        
        //Get the totals on this call.
		var accountsResponse = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SwGetUpdatedAccounts");
		var TotalCount = accountsResponse.totalCount?:0;
		var TotalPages = accountsResponse.totalPages?:0;
        
        //Exit if there is no data.
        if (!TotalCount){
            logHibachi("No account data to import at this time.", true);
        }
        
        //Iterate all the pages.
		while (pageNumber <= TotalPages){
		    
		    accountsResponse = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SwGetUpdatedAccounts");
    		
    		if (accountsResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    pageNumber++;
    		    continue;
    		}
    		
			var goodStanding = getService("TypeService").getTypeByTypeID("2c9180836dacb117016dad11ebf2000e");
			var terminated = getService("TypeService").getTypeByTypeID("2c9180836dacb117016dad1296c90010");
			var suspended = getService("TypeService").getTypeByTypeID("2c9180836dacb117016dad1239ac000f");
			var deleted = getService("TypeService").getTypeByTypeID("2c9180836dacb117016dad12e37c0011");
			var enrollmentPending = getService("TypeService").getTypeByTypeID("2c9180836dacb117016dad1329790012");
    		var accounts = accountsResponse.Records;
    		
    		/**
    		 *  {
			      "AccountNumber": "string",
			      "AccountStatusCode": "string",
			      "SponsorNumber": "string",
			      "EnrollerNumber": "string",
			      "AccountTypeCode": "string",
			      "EntryDate": "2019-11-20T19:16:28.725Z",
			      "EntryPeriod": "string",
			      "FlagAccountTypeCode": "string",
			      "GovernmentNumber": "string",
			      "CareerTitleCode": "string"
			    }
    		 **/
    		
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			
    			for (var account in accounts){
    			    index++;
        		    
        			// Create a new account and then use the mapping file to map it.
        			var foundAccount = getService("AccountService").getAccountByAccountNumber( account['AccountNumber'] );
        			
        			if (isNull(foundAccount)){
        				pageNumber++;
        				logHibachi("Could not find this account to update: Account number #account['AccountNumber']#", true);
        				continue;
        			}
        			
                    //Account Status Code
                    if (!isNull(account['AccountStatusCode']) && len(account['AccountStatusCode'])){
                    	foundAccount.setAccountStatus(account['AccountStatusCode']?:"");
                    	
                    	//If the account is suspended, deactivate it.
                    	if (account['AccountStatusName'] == "Suspended" || account['AccountStatusName'] == "Terminated"){
                    	    foundAccount.setActiveFlag(false);
                    	}else{
                    	    foundAccount.setActiveFlag(true);
                    	}
                    	
                    	if (!isNull(account['AccountStatusName']) && len(account['AccountStatusName'])){
                    	        var statusType = goodStanding;
                    	        if (account['AccountStatusName'] == "Good Standing"){
                    	            statusType = goodStanding;
                    	        }
                    	        if (account['AccountStatusName'] == "Terminated"){
                    	            statusType = terminated;
                    	        }
                    	        if (account['AccountStatusName'] == "Suspended"){
                    	            statusType = suspended;
                    	        }
                    	        if (account['AccountStatusName'] == "Deleted"){
                    	            statusType = deleted;
                    	        }
                    	        if (account['AccountStatusName'] == "Enrollment Pending"){
                    	            statusType = enrollmentPending;
                    	        }
                        		foundAccount.setAccountStatus(account['AccountStatusCode']?:"");
                        		foundAccount.setAccountStatusType( statusType );
                        		
                    	}
                    }
                    
                    
                    // SponsorNumber
                    
                    if (!isNull(account['AccountNumber']) && 
                    	!isNull(account['SponsorNumber']) && 
                    	len(account['AccountNumber']) && 
                    	len(account['SponsorNumber']) && 
                    	account['AccountNumber'] != account['SponsorNumber'] &&
                    	foundAccount.getSponsorIDNumber() != account['SponsorNumber']){
                    	var notUnique = false;
                    	
                    	try{
                    		var newSponsorAccount = getService("AccountService").getAccountByAccountNumber(account['SponsorNumber']);
                    		var childAccount = foundAccount;
                    	}catch(nonUniqueResultException){
                    		//not unique
                    		notUnique = true;
                    	}
                    	
     
                    	if (!notUnique && !isNull(childAccount)){
                    		var newAccountRelationship = getService("AccountService").getAccountRelationshipByChildAccount(childAccount, false);

                    		var isNewAccountRelationship = false;
                    		if (isNull(newAccountRelationship)){
                    			var newAccountRelationship = new Slatwall.model.entity.AccountRelationship();
                    			isNewAccountRelationship = true;
                    		}
                    		
	                    	newAccountRelationship.setParentAccount(newSponsorAccount);
	                    	newAccountRelationship.setChildAccount(childAccount);
	                    	newAccountRelationship.setActiveFlag( true );
	                    	newAccountRelationship.setCreatedDateTime( now() );
	                    	newAccountRelationship.setModifiedDateTime( now() );
	                    	
	                    	//insert the relationship
	                    	
	                    	if (isNewAccountRelationship){
	                    		ormStatelessSession.insert("SlatwallAccountRelationship", newAccountRelationship);
	                    	}else{
	                    		
	                    		ormStatelessSession.update("SlatwallAccountRelationship", newAccountRelationship);
	                    	}
	                    	
	                    	foundAccount.setOwnerAccount(newSponsorAccount);
                    	}
                    }
                    
                    //Account Type
                    if (!isNull(account['AccountTypeCode']) && len(account['AccountTypeCode'])){
                    	//set the accountType from this. Needs to be name or I need to map it.
                    	/*
                    	Monat
                    	D - Market Partner
						P - VIP
						C - Retail Customer
						E - Employee
						
						Slatwall versions:
						 business       
						 customer       
						 Employee       
						 individual     
						 marketPartner  
						 retail         
						 Unassigned     
						 vip  
                    	*/
                    	if (account['AccountTypeCode'] == "D"){ 
                    		foundAccount.setAccountType( "marketPartner" );
                    	}else if(account['AccountTypeCode'] == "P"){
                    		foundAccount.setAccountType( "vip" );
                    	}else if(account['AccountTypeCode'] == "C"){
                    		foundAccount.setAccountType( "retail" );
                    	}else if(account['AccountTypeCode'] == "E"){
                    		foundAccount.setAccountType( "Employee" );
                    	}
                    }
                    
                    //FlagAccountTypeCode (C,L,M,O,R)
                    if (!isNull(account['FlagAccountTypeCode']) && len(account['FlagAccountTypeCode'])){
                    	//set the accountType from this. Needs to be name or I need to map it.
                    	foundAccount.setComplianceStatus( account['FlagAccountTypeCode']?:"" );
                    }
                    
                    //"EntryDate": "2020-01-30T15:00:53",
                    if (!isNull(account['EntryDate']) && len(account['EntryDate'])){.
                    	foundAccount.setEnrollmentDate( ParseDateTime(account['EntryDate']));
                    }
                    
                    //CareerTitleCode
                    foundAccount.setCareerTitle( account['CareerTitleCode']?:"" );
                    
                    ormStatelessSession.update("SlatwallAccount", foundAccount);

    			}
    			
    			tx.commit();
    		}catch(e){
    			
    			logHibachi("Daily Account Import Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#", true);
    			logHibachi(serializeJson(e));
    			ormGetSession().clear();
    			ormStatelessSession.close();
    			abort;
    		}
    		
    		//echo("Clear session");
    		this.logHibachi('Import (Daily Updated Accounts) Page #pageNumber# completed ', true);
    		ormGetSession().clear();//clear every page records...
		    pageNumber++;
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		logHibachi("End: #pageNumber# - #pageSize# - #index#", true);
    }
    
    public any function importOrderUpdates(){
        
        logHibachi("importOrderUpdates - Start", true);
        //get the api key from integration settings.
		var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		var index=0;
		var HOURS = 'h';
        /**
         * Allows the user to override the last n HOURS that get checked. 
         * Defaults to 60 HOURS.
         **/
        var intervalOverride = 1;
        
        /**
         * The page number to start with 
         **/
        var pageNumber = 1;
        
        /**
         * How many records to process per page. 
         **/
		var pageSize = 50;
		
		/**
		 * the page number to end on (exclusive) 
		 **/
		var pageMax = 2;
		
		/**
		 * The date and time from an hour ago.
		 **/
		var sixtyMinutesAgo = DateAdd(HOURS, -intervalOverride, now());
		
		/**
		 * The string representation for the date twenty HOURS ago. 
		 * Uses number format to make sure each minute, second will use 2 places.
		 * This checks for the last hour of deliveries every 15 HOURS.
		 * This only adds a delivery IF its not already delivered, so we can do that.
		 * 
		 **/
	    var dateFilterStart = "#year(sixtyMinutesAgo)#-#numberFormat(month(sixtyMinutesAgo),'00')#-#numberFormat(day(sixtyMinutesAgo),'00')#T#numberformat(hour(sixtyMinutesAgo),'00')#:#numberformat(minute(sixtyMinutesAgo), '00')#:#numberformat(second(sixtyMinutesAgo), '00')#.693Z";
	
		/**
		 * This should always equal now.
		 **/
        var dateFilterEnd =  "#year(now())#-#numberFormat(month(now()),'00')#-#numberFormat(day(now()),'00')#T#numberFormat(hour(now()),'00')#:#numberformat(minute(now()), '00')#:#numberformat(second(now()), '00')#.693Z";
	
	    //Get the totals
		var orderResponse = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SwGetUpdatedOrders");
		var TotalCount = orderResponse.totalCount;
		var TotalPages = orderResponse.totalPages;
         
        //Exit with no data.
        if (!TotalCount){
            logHibachi("No order data to import at this time.", true);
        }
        
        //Iterate the response.
		while (pageNumber <= TotalPages){
			logHibachi("Start Order Updater", true);
    		var orderResponse = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SwGetUpdatedOrders");
    	   
    		if (orderResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    pageNumber++;
    		    continue;
    		}
    		
    		
    		try{
    			var tx = ormStatelessSession.beginTransaction();
    			var orders = orderResponse.Records;
    			
    			for (var order in orders){
    			    index++;
        		    
        			// Create a new account and then use the mapping file to map it.
        			var foundOrder = getOrderService().getOrderByOrderNumber( order['OrderNumber'] );
        			
        			if (isNull(foundOrder)){
        				pageNumber++;
        				logHibachi("Could not find this order to update: Order number #order['OrderNumber']#", true);
        				continue;
        			}
        			if (!isNull(foundOrder) && !isNull(order['Period']) && len(order['Period'])){
                        foundOrder.setCommissionPeriod(order['Period']);
        			}
                    ormStatelessSession.update("SlatwallOrder", foundOrder);
    			}
    			
    			tx.commit();
    		}catch(e){
    			logHibachi("Daily Account Import Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#", true);
    			logHibachi(serializeJson(e));
    			ormGetSession().clear();
    		}
    		
    		this.logHibachi('Import (Updated Order) Page #pageNumber# completed ', true);
    		ormGetSession().clear();//clear every page records...
		    pageNumber++;
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		logHibachi("End: #pageNumber# - #pageSize# - #index#", true);
    }
    
    
    private any function getAPIResponse(string endpoint, numeric pageNumber, numeric pageSize, struct customBody = {}){

		var uri = setting('baseImportURL') & arguments.endPoint;
		var authKeyName = "authkey";
		var authKey = setting('authKey');

		var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#arguments.pageNumber#"
			}
		};

		if(!structIsEmpty(arguments.customBody)){
			StructAppend(body,customBody,true);
		}
		httpService = new http(method = "POST", charset = "utf-8", url = uri);
		httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
		httpService.addParam(name = "Accept", type = "header", value = "text/plain");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
		httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");

		try {
			httpService.setTimeout(10000)
			responseJson = httpService.send().getPrefix();
			var response = deserializeJson(responseJson.fileContent);

			if(isArray(response)){
				response = response[1];
			} 
		} catch (any e) {
			writeDump("Could not read response got #e.message# for page:#arguments.pageNumber#");
			if(!isNull(responseJson)){
				writeDump(responseJson);
			}
			var response = {}; 
			response.status = 'error';
		}
		response.hasErrors = false;
		if (isNull(response) || response.status != "success"){
			writeDump("Could not import from #arguments.endpoint# on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
			response.hasErrors = true;
		}

		return response;
	}

	private string function getSkuColumnsList(){
		return "SKUItemCode,SKUItemID,ProductName,ProductCode,ItemName,Amount,SalesCategoryCode,SAPItemCode,ItemNote,DisableOnRegularOrders,DisableOnFlexship,ItemCategoryAccounting,CategoryNameAccounting,EntryDate,URLTitle";
	}

	private string function getSkuPriceColumnsList(){
		return "ItemCode,SellingPrice,QualifyingPrice,TaxablePrice,Commission,RetailsCommissions,ProductPackBonus,RetailValueVolume,CurrencyCode,PriceLevel";
	}

	private string function getSkuBundleColumnsList(){
		return "SKUItemCode,KitId,importKey,ontheflykit,ComponentItemCode,ComponentQuantity";
	}

	private string function getStockColumnsList(){
		return "SKUItemID,LocationCode";
	}



	private any function associateProductWithSite(required struct siteProductCodes){
		var swSites = {
			'CAN' = '2c9280846974b77e016974ee40cb0019',
			'GBR' = '2c9280846974b77e016974fe89070025',
			'AUD' = '2c9280846974b77e016974fe91d5002a',
			'IRL' = '2c9280846974b77e016974fe999e002f',
			'POL' = '2c9280846974b77e016974fea1e90034',
			'USA' = '2c97808468a979b50168a97b20290021'
		};

		for(var swSite in swSites){
			if(!arrayLen(arguments.siteProductCodes[swSite])){
				continue;
			}

			QueryExecute(
				"INSERT INTO swproductsite (productID, siteID)
				SELECT 
					p.productID as productID,
					:siteID as siteID
				FROM swProduct p
				LEFT JOIN swproductsite ps ON p.productID = ps.productID AND ps.siteID = :siteID
				WHERE p.productCode IN (:productCodes) AND  ps.productID IS NULL",
				{ 
					'productCodes' = { 'value' = arrayToList(siteProductCodes[swSite]), 'list' = true }, 
					'siteID' = swSites[swSite]
				}
			);
		}
	}

	private any function populateStockQuery(required any stockQuery, required struct skuData){

		var warehouseLookup = {
			'CAN' : 'caWarehouse',
			'GBR' : 'ukWarehouse',
			'USA' : 'usWarehouse',
			'IRL' : 'irePolWarehouse',
			'POL' : 'irePolWarehouse'
		}

		for(var sapItemCode in arguments.skuData['SAPItemCodes']){

			if(!structKeyExists(warehouseLookup, sapItemCode['CountryCode'])){
				continue;
			}
			var queryRow = {
				'SKUItemID' :  arguments.skuData['ItemId'],
				'LocationCode' : warehouseLookup[sapItemCode['CountryCode']]
			};
			QueryAddRow(arguments.stockQuery, queryRow);
		}

		return arguments.stockQuery;
	}


	private numeric function getLastProductPageNumber(numeric pageSize = 25, struct extraBody ={}){

		var initProductData = this.getApiResponse("SWGetNewUpdatedSKU", 1, arguments.pageSize, arguments.extraBody );
		if(structKeyExists(initProductData, 'Data') && structKeyExists(initProductData['Data'], 'TotalPages')){
			return initProductData['Data']['TotalPages'];
		}
		return 1;
	}

	public void function importMonatProducts(required struct rc){
		param name="arguments.rc.pageNumber" default="1";
		param name="arguments.rc.pageSize" default="100";
		param name="arguments.rc.days" default=0;
		param name="arguments.rc.dryRun" default="false";


		getService("HibachiTagService").cfsetting(requesttimeout="60000");
		
		logHibachi("importMonatProducts - Start", true);

		var extraBody = {};
		

		if(arguments.rc.days > 0){
		    
		    logHibachi("importMonatProducts - Getting data for #arguments.rc.days# days", true);
		    
			extraBody = {
				"Filters": {
				    "StartDate": DateTimeFormat( DateAdd('d', arguments.rc.days * -1, now()), "yyyy-mm-dd'T'00:00:01'.693Z'" ),
		            "EndDate": DateTimeFormat( now(), "yyyy-mm-dd'T'23:59:59'.693Z'" )
				}
			};
		}
		

		if(!structKeyExists(arguments.rc, 'pageMax')){
			arguments.rc.pageMax = this.getLastProductPageNumber(arguments.rc.pageSize, extraBody);
		}
		
		logHibachi("importMonatProducts - Pages found #arguments.rc.pageMax#", true);

		var basePath = getDirectoryFromPath(getCurrentTemplatePath());
		
		var skuBundles = {};


		var skuColumns = this.getSkuColumnsList();
		var skuColumnTypes = [];
		ArraySet(skuColumnTypes, 1, ListLen(skuColumns), 'varchar');
		var skuQuery = QueryNew(skuColumns, skuColumnTypes);


		var skuBundleColumns = this.getSkuBundleColumnsList();
		var skuBundleColumnTypes = [];
		ArraySet(skuBundleColumnTypes, 1, ListLen(skuBundleColumns), 'varchar');
		var skuBundleQuery = QueryNew(skuBundleColumns, skuBundleColumnTypes);


        var onTheFlySkuCodes = '';
        var skuCodes = [];

		for(var index = arguments.rc.pageNumber; index <= arguments.rc.pageMax; index++){
		    
		    logHibachi("importMonatProducts - Current Page #index#", true); 
			var productResponse = this.getApiResponse("SWGetNewUpdatedSKU", index, arguments.rc.pageSize, extraBody );
			
			//goto next page causing this is erroring!
			if ( productResponse.hasErrors ){
			    logHibachi("importMonatProducts - Returned Errors", true); 
				continue;
			}

			//Set the pagination info.
			var monatProducts = productResponse.Data.Records ?: [];
			
			logHibachi("importMonatProducts - Product Count #arrayLen(monatProducts)#", true); 

			for (var skuData in monatProducts){

				// Setup Sku data 
				var sku = {
					'SKUItemID' : trim(skuData['ItemId']),
					'SKUItemCode' : trim(skuData['ItemCode']),
					'ProductCode' : skuData['ProductCodeCode'] ?: trim(skuData['ItemCode']),
					'ProductName' : skuData['ProductCodeName'] ?: trim(skuData['ItemName']),
					'ItemName' : trim(skuData['ItemName']),
					'ItemNote' : skuData['ItemNote'] ?: '',
					'SalesCategoryCode' : trim(skuData['SalesCategoryCode']),
					'DisableOnRegularOrders' : skuData['DisableInDTX'] ?: false,
					'DisableOnFlexShip' : skuData['DisableInFlexShip'] ?: false,
					'ItemCategoryAccounting' : trim(skuData['ItemCategoryCode']),
					'CategoryNameAccounting' : trim(skuData['ItemCategoryName']),
					'EntryDate' : skuData['EntryDate'],
					'SAPItemCode' : skuData['ItemCode'],
					'Amount' : 0
				};
				
				arrayAppend(skuCodes, sku['SKUItemCode']);
				
				// Add Sku to CF Query
				QueryAddRow(skuQuery, sku);

				// Create SkuBundle Query
				if(arrayLen(skuData['KitLines'])){
				    
				    skuBundles[sku['SKUItemCode']] = '';
				    
				    var onTheFlyKitAdded = false;

				    for(var kit in skuData.KitLines){
            			
            			skuBundles[sku['SKUItemCode']] = listAppend(skuBundles[sku['SKUItemCode']], kit['ComponentItemCode']);
            			
            			var skuBundleData = {
            				'SKUItemCode' : sku['SKUItemCode'],
            				'ComponentItemCode' : kit['ComponentItemCode'],
            				'importKey' : sku['SKUItemCode'] & "-" & kit['ComponentItemCode'],
            				'ComponentQuantity' : kit['ComponentQty'],
            				'ontheflykit' : kit['OnTheFlyFlag'] ?: false
            			};
            			
            			QueryAddRow(skuBundleQuery, skuBundleData);
            			
            			if(!onTheFlyKitAdded && skuBundleData['ontheflykit']){
            			    
            			    onTheFlyKitAdded = true;
            			    onTheFlySkuCodes = listAppend(onTheFlySkuCodes, sku['SKUItemCode']);
            			}
            		}
				}
			}
		}
		
		
		
		
		logHibachi("importMonatProducts - Importing Products/Sku Count #skuQuery.recordCount#", true); 
		if(skuQuery.recordCount){

			var importSkuConfig = FileRead('#basePath#../../config/import/skus.json');
			var updateSkuConfig = FileRead('#basePath#../../config/import/skus_update.json');
			
			var skuCodesResult = QueryExecute('SELECT GROUP_CONCAT(skuCode) skuCodes from swSku where skuCode IN ( :skuCodes )',{ 
				'skuCodes' = { 
				    'value' = arrayToList(skuCodes), 
				    'list' = true
				}
			});
				
			var existingSkuCodes = listToArray(skuCodesResult['skuCodes']);
			
			
		    
		    
		    var existingSkus = skuQuery.filter(function(row, rowNumber, qryData){
                return arrayFind(existingSkuCodes, arguments.row.SKUItemCode);
            });
			var newSkus = skuQuery.filter(function(row, rowNumber, qryData){
                return !arrayFind(existingSkuCodes, arguments.row.SKUItemCode);
            });
		
			getService("HibachiDataService").loadDataFromQuery(existingSkus, updateSkuConfig, arguments.rc.dryRun);
			getService("HibachiDataService").loadDataFromQuery(newSkus, importSkuConfig, arguments.rc.dryRun);
		}
		
		logHibachi("importMonatProducts - Importing On The Fly Setting #listLen(onTheFlySkuCodes)#", true); 
			
		if(!arguments.rc.dryRun && len(onTheFlySkuCodes)){
		    QueryExecute(
				"INSERT INTO swsetting (settingID, settingName, settingValue, createdDateTime, modifiedDateTime, skuID, baseObject)
				 SELECT 
                	LOWER(REPLACE(CAST(UUID() as char character set utf8), '-', ''))  settingID,
                	'skuBundleAutoMakeupInventoryOnSaleFlag' settingName,
                	'1' settingValue,
                	NOW() createdDateTime,
                	NOW() modifiedDateTime,
                	sku.skuID skuID,
                	'sku' baseObject
                 FROM swSku sku
                 LEFT JOIN swSetting s ON sku.skuID = s.skuID and s.settingName = 'skuBundleAutoMakeupInventoryOnSaleFlag'
                 WHERE
                	skuCode in (:onTheFlySkuCodes) AND s.settingID is NULL",
				{ 
					'onTheFlySkuCodes' = { 'value' = onTheFlySkuCodes, 'list' = true }
				}
		    );
	    }
		

// 		if(skuPriceQuery.recordCount){
// 			var importSkuPriceConfig = FileRead('#basePath#../../config/import/skuprices.json');
// 			getService("HibachiDataService").loadDataFromQuery(skuPriceQuery, importSkuPriceConfig, arguments.rc.dryRun);
// 		}

        logHibachi("importMonatProducts - Importing SKuBundle Count #skuBundleQuery.recordCount#", true); 
		if(skuBundleQuery.recordCount){
		    
			var importSkuBundleConfig = FileRead('#basePath#../../config/import/bundles.json');
			getService("HibachiDataService").loadDataFromQuery(skuBundleQuery, importSkuBundleConfig, arguments.rc.dryRun);

			var importSkuBundle2Config = FileRead('#basePath#../../config/import/bundles2.json');
			getService("HibachiDataService").loadDataFromQuery(skuBundleQuery, importSkuBundle2Config, arguments.rc.dryRun);
			
			if(!arguments.rc.dryRun){
    			for(var skuID in skuBundles){
    		        QueryExecute(
        				"DELETE bundle FROM swskubundle bundle
                        INNER JOIN swSku sku ON bundle.skuID = sku.skuID
                        INNER JOIN swSku childSku ON bundle.bundledSkuID = childSku.skuID
                        WHERE sku.skuCode = :skuID
                        AND childSku.skuCode NOT IN (:childSkuIDs)",
        				{ 
        					'skuID' = skuID,
        					'childSkuIDs' = { 'value' = skuBundles[skuID], 'list' = true }
        				}
    			    );
    		    }
			}
		}

// 		if(stockQuery.recordCount){
// 			var importStockConfig = FileRead('#basePath#../../config/import/stocks.json');
// 			getService("HibachiDataService").loadDataFromQuery(stockQuery, importStockConfig, arguments.rc.dryRun);
// 		}
		
		
		//Fix ProductTypes:
		QueryExecute("UPDATE swProductType SET parentProductTypeID = '444df2f7ea9c87e60051f3cd87b435a1' WHERE parentProductTypeID IS NULL AND productTypeNamePath LIKE 'Merchandise > %'");
		QueryExecute("UPDATE swProductType SET productTypeIDPath = CONCAT('444df2f7ea9c87e60051f3cd87b435a1,',productTypeIDPath) WHERE parentProductTypeID = '444df2f7ea9c87e60051f3cd87b435a1' AND productTypeIDPath NOT LIKE '444df2f7ea9c87e60051f3cd87b435a1,%'");

// 		//this.addUrlTitlesToProducts();
		if(arguments.rc.dryRun){
		    abort;
		}
//		else{
//			this.associateProductWithSite(siteProductCodes);
// 		}
		logHibachi("importMonatProducts - Done!", true); 
	}
    
    public any function importInventoryUpdates(){
        //get the api key from integration settings.
		var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var index=0;
		var HOURS = 'h';
        /**
         * Allows the user to override the last n HOURS that get checked. 
         * Defaults to 1 HOURS.
         **/
        var intervalOverride = 1;
        
        /**
         * The page number to start with 
         **/
        var pageNumber = 1;
        
        /**
         * How many records to process per page. 
         **/
		var pageSize = 50;
		
		/**
		 * the page number to end on (exclusive) 
		 **/
		var pageMax = 2;
		
		/**
		 * The date and time from an hour ago.
		 **/
		var sixtyMinutesAgo = DateAdd(HOURS, -intervalOverride, now());
		
		/**
		 * The string representation for the date twenty HOURS ago. 
		 * Uses number format to make sure each minute, second will use 2 places.
		 * This checks for the last hour of deliveries every 15 HOURS.
		 * This only adds a delivery IF its not already delivered, so we can do that.
		 * 
		 **/
	    var dateFilterStart = "#year(sixtyMinutesAgo)#-#numberFormat(month(sixtyMinutesAgo),'00')#-#numberFormat(day(sixtyMinutesAgo),'00')#T#numberformat(hour(sixtyMinutesAgo),'00')#:#numberformat(minute(sixtyMinutesAgo), '00')#:#numberformat(second(sixtyMinutesAgo), '00')#.693Z";
	
		/**
		 * This should always equal now.
		 **/
        var dateFilterEnd =  "#year(now())#-#numberFormat(month(now()),'00')#-#numberFormat(day(now()),'00')#T#numberFormat(hour(now()),'00')#:#numberformat(minute(now()), '00')#:#numberformat(second(now()), '00')#.693Z";
	
	    //Get the totals
		var inventoryResponse = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SWGetInventoryAdjustments");
		var TotalCount = inventoryResponse.totalCount?:0;
		var TotalPages = inventoryResponse.totalPages?:0;
        
        // Objects we need to set over and over go here...
		var warehouseMain = getLocationService().getLocationByLocationName("US Warehouse");
		var warehouseCAN = getLocationService().getLocationByLocationName("CA Warehouse");
		var warehouseUKIR = getLocationService().getLocationByLocationName("UK/IRE Warehouse");
		var warehousePOL = getLocationService().getLocationByLocationName("POL Warehouse");
		 
        //Exit with no data.
        if (!TotalCount){
            logHibachi("No inventory data to import at this time.", true);
        }
        
        //Iterate the response.
		while (pageNumber <= TotalPages){
			logHibachi("Start Inventory Updater", true);
    		var inventoryResponse = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SWGetInventoryAdjustments");
    	   
    		if (inventoryResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    pageNumber++;
    		    continue;
    		}
    		
    		
    		
    			
    			var inventoryRecords = inventoryResponse.Records;
    			
    			for (var inventory in inventoryRecords){
    			    
    			    try{
        			    index++;
        			    
            		    var sku = getSkuService().getSkuBySkuCode(inventory.itemCode);
            		    
            		    if (isNull(sku)){
            		    	logHibachi("Can't create inventory for a sku that doesn't exist! #inventory.itemCode#", true);
            		    	continue;
            		    }
            		    
            		    var location = warehouseMain;
            		    
            		    if (inventory['CountryCode'] == "US"){
            		    	location = warehouseMain;	
            		    }else if (inventory['CountryCode'] == "CA"){
            		    	location = warehouseCAN;	
            		    }else if (inventory['CountryCode'] == "PL"){
            		        location = warehousePOL;
            		    } else {
            		    	location = warehouseUKIR;
            		    }
            		    
            		    
            		    //Find if we have a stock for this sku and location.
            		    var stock = getStockService().getStockBySkuIdAndLocationId( sku.getSkuID(), location.getLocationID() );
            		    
            		    
            		    if (isNull(stock)){
            		    	// Create the stock
            		    	var stock = getStockService().newStock();
            		    	stock.setSku(sku);
            		    	stock.setLocation(location);
            		    	stock.setRemoteID(inventory['InventoryAdjustmentId']);
            		    	stock = getStockService().saveStock(stock);
            		    }
            		    
            		    //Create the inventory record for this stock
            		    if (!isNull(stock)){
            		        //check if this inventory has already been imported...
            		        var newInventory = getStockService().getInventoryByRemoteId( inventory['InventoryAdjustmentId'] );
            		        
            		        //Only create the inventory if it doesn't already exist. Everytime an inventory adjustment is made
            		        //it has a new id, thus a new remoteID.
            		        if (isNull(newInventory)){
                			    // Create a new inventory under that stock.
                			    var newInventory = getStockService().newInventory();
                			    newInventory.setRemoteID(inventory['InventoryAdjustmentId'] ?: ""); //*
                    			newInventory.setStock(stock);
                    			
                    			var inventoryQuantity = inventory['Quantity'] ?: 0;
                    			
                    			if (inventoryQuantity > 0){
                            	    newInventory.setQuantityIn(inventoryQuantity);
                    			}else{
                    			    newInventory.setQuantityOut(inventoryQuantity * -1); 
                    			}
                    			
                            	newInventory.setCreatedDateTime(getDateFromString(inventory['CreatedOn']));
                            	
                                newInventory = getStockService().saveInventory(newInventory);
                            	
            		        }
            		    }
    			    }catch(e){
            			logHibachi("Stock Import Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#", true);
            			logHibachi(serializeJson(e));
            			
    		        }
    			}
    			
    		this.logHibachi('Import (Updated Inventory) Page #pageNumber# completed ', true);
		    pageNumber++;
		}
		
		logHibachi("End: #pageNumber# - #pageSize# - #index#", true);
    }
    
    
    public any function fixMonatProductRemoteID(required struct rc){
		param name="arguments.rc.pageNumber" default="1";
		param name="arguments.rc.pageSize" default="100";
		param name="arguments.rc.days" default=0;
		param name="arguments.rc.dryRun" default="false";

		getService("HibachiTagService").cfsetting(requesttimeout="60000");

		var extraBody = {};

		arguments.rc.pageMax = this.getLastProductPageNumber(arguments.rc.pageSize, extraBody);
	
		for(var index = arguments.rc.pageNumber; index <= arguments.rc.pageMax; index++){
			var productResponse = this.getApiResponse("SWGetNewUpdatedSKU", index, arguments.rc.pageSize, extraBody );

			//goto next page causing this is erroring!
			if ( productResponse.hasErrors ){
				continue;
			}

			//Set the pagination info.
			var monatProducts = productResponse.Data.Records ?: [];

			for (var skuData in monatProducts){

                queryExecute("update swSku set remoteID = :remoteID WHERE skuCode = :skuCode",{
                    'remoteID' = { value="#trim(skuData['ItemId'])#", cfsqltype="cf_sql_varchar"},
                    'skuCode' = { value="#trim(skuData['ItemCode'])#", cfsqltype="cf_sql_varchar"}
                });
                
                queryExecute("update swProduct set remoteID = :remoteID WHERE productCode = :productCode",{
                    'remoteID' = { value="#trim(skuData['ItemId'])#", cfsqltype="cf_sql_varchar"},
                    'productCode' = { value="#trim(skuData['ItemCode'])#", cfsqltype="cf_sql_varchar"}
                });

			}
		}

	
	}
	
	public any function updateGeoIPDatabase(required struct rc){
	    
	    var fileName = 'IP2LOCATION-LITE-DB1.CSV';
	    var fullPath = '#getTempDirectory()##fileName#';
	    var http = new Http(url = 'https://download.ip2location.com/lite/#fileName#.ZIP', method='GET');
        http.setPath(getTempDirectory());
        http.setFile(fileName & '.ZIP');
        result = local.http.send().getPrefix();

        Extract( 'zip', fullPath & '.ZIP', getTempDirectory() );
	    if(!fileExists(fullPath)){
	        writeDump('CSV Not Found.');
	        abort;
	    }
	    
	    var data = getService("HibachiDataService").loadQueryFromCSVFileWithColumnTypeList(
	        pathToCSV=fullPath, 
	        columnTypeList='Integer,Integer,VarChar,VarChar',
	        useHeaderRow=false,  
	        columnsList = 'ip_from,ip_to,country_code,country_name'
        );
        
        getDAO('MonatDataDAO').updateGeoIPDatabase(data);
	    
	    writeDump('GeoIP Database Updated!'); abort;
	}
}
