component extends="Slatwall.model.service.HibachiService" accessors="true" {
    property name="ProductService";
	property name="SettingService";
	property name="AddressService";
	property name="AccountService";
	property name="TypeService";
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
	property name="fulfillmentService";
	
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
        
        var marketPartnerObject = {
            accountCollection: marketPartnerCollection.accountCollection.getPageRecords(formatRecords=false),
            recordsCount: marketPartnerCollection.recordsCount
        }
        return marketPartnerObject;
    }
    
    private any function getAccountCollection(required struct data){
        param name="arguments.data.pageRecordsShow" default=9;
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.search" default="";
        param name="arguments.data.stateCode" default="";
        param name="arguments.data.countryCode" default="";
        param name="arguments.data.accountSearchType" default="false";

        var accountCollection = getService('HibachiService').getAccountCollectionList();
        
        var searchableDisplayProperties = 'accountNumber,firstName,lastName';
        accountCollection.setDisplayProperties(searchableDisplayProperties, {isSearchable=true, comparisonOperator="exact"});
        accountCollection.addDisplayProperty('accountID','accountID', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.city','primaryAddress_address_city', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.countryCode','primaryAddress_address_countryCode', {isVisible:true, isSearchable:false});
        accountCollection.addDisplayProperty('primaryAddress.address.stateCode','primaryAddress_address_stateCode', {isVisible:true, isSearchable:false});
        accountCollection.addFilter( 'accountNumber', 'NULL', 'IS NOT');
        accountCollection.addFilter( 'accountStatusType.systemCode', 'astGoodStanding');
        
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
        
        if ( len( arguments.data.countryCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.countryCode', arguments.data.countryCode );
        }
        
        if ( len( arguments.data.stateCode ) ) {
            accountCollection.addFilter( 'primaryAddress.address.stateCode', arguments.data.stateCode );
        }
        if(!isNull(arguments.data.search) && len(arguments.data.search)){
            accountCollection.setKeywords(arguments.data.search);
        }
        
        var recordsCount = accountCollection.getRecordsCount();
        
        accountCollection.setPageRecordsShow(arguments.data.pageRecordsShow);
        accountCollection.setCurrentPageDeclaration(arguments.data.currentPage);
        
        var returnObject = {
            accountCollection: accountCollection,
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
    
    private any function getDailyAccountUpdatesData(pageNumber,pageSize){
	    var uri = "https://api.monatcorp.net:8443/api/Slatwall/SwGetUpdatedAccounts";
		var authKeyName = "authkey";
		var authKey = setting(authKeyName);
		
	    var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#arguments.pageNumber#"
			},
			"Filters": {
			    "StartDate": "#year(now())#-#month(now())#-#day(now())#T00:00:00.693Z",
			    "EndDate": "#year(now())#-#month(now())#-#day(now())#T23:59:59.693Z"
			}
		};
		
		/**
		 * 
		 * Filter example
		 * "Filters": {
		 *	"StartDate": "2019-11-20T19:16:28.693Z",
		 *	"EndDate": "2019-11-20T19:16:28.693Z"
		 * }
		 *	 
		 **/
	   var httpService = new http(method = "POST", charset = "utf-8", url = uri);
		httpService.addParam(name = "Authorization", type = "header", value = "#authKey#");
		httpService.addParam(name = "Content-Type", type = "header", value = "application/json-patch+json");
		httpService.addParam(name = "Accept", type = "header", value = "text/plain");
		httpService.addParam(name = "body", type = "body", value = "#serializeJson(body)#");
		
		var accountJson = httpService.send().getPrefix();
		var accountsResponse = deserializeJson(accountJson.fileContent);
        accountsResponse.hasErrors = false;
		if (isNull(accountsResponse) || accountsResponse.status != "success"){
			logHibachi("Could not import updated accounts data on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
		    accountsResponse.hasErrors = true;
		}
		
		return accountsResponse;
	}
	
	public any function getDateFromString(date) {
		return	createDate(
			datePart("yyyy",date), 
			datePart("m",date),
			datePart("d",date));
	}
	
	private any function getShipmentData(pageNumber,pageSize,dateFilterStart,dateFilterEnd){
	    var uri = "https://api.monatcorp.net:8443/api/Slatwall/SWGetShipmentInfo";
		var authKeyName = "authkey";
		var authKey = setting(authKeyName);
	    var = {hasErrors: false};
	    var body = {
			"Pagination": {
				"PageSize": "#arguments.pageSize#",
				"PageNumber": "#arguments.pageNumber#"
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
			fsResponse['Records'] = apiData.Data.Records;
		    return fsResponse;
		}

		writeDump("Could not import shipment on this page: PS-#arguments.pageSize# PN-#arguments.pageNumber#");
		fsResponse.hasErrors = true;


		return fsResponse;
	}
	
	public void function importOrderShipments(required struct rc){ 
        /**
         * Allows the user to override the last n minutes that get checked. 
         * Defaults to 20 minutes.
         **/
        var intervalOverride = rc.intervalOverride ?: 20;
        var MERGE_ARRAYS = true;
        var SHIPPED = "5";
        var CLOSED_STATUS = getTypeService().getTypeByTypeCode(SHIPPED);
        
        /**
         * The page number to start with 
         **/
        var pageNumber = rc.pageNumber?:1;
        
        /**
         * How many records to process per page. 
         **/
		var pageSize = rc.pageSize?:500;
		
		/**
		 * the page number to end on (exclusive) 
		 **/
		var pageMax = rc.pageMax?:1;
		var MINUTES = 'n';
		
		/**
		 * The date and time from 20 minutes ago.
		 **/
		var twentyMinutesAgo = DateAdd(MINUTES, -intervalOverride, now());
		
		/**
		 * The string representation for the date twenty minutes ago. 
		 **/
		var startDate = "#year(twentyMinutesAgo)#-#month(twentyMinutesAgo)#-#day(twentyMinutesAgo)#T#hour(twentyMinutesAgo)#:#minute(twentyMinutesAgo)#:#second(now())#.693Z";
		
		/**
		 * This should always equal now.
		 **/
		var endDate =  "#year(now())#-#month(now())#-#day(now())#T#hour(now())#:#minute(now())#:#second(now())#.693Z";
		
		/**
		 * You can pass in a start date or end date in the rc 
		 **/
		var dateFilterStart = 
		    rc.dateFilterStart ?: startDate;
		var dateFilterEnd = 
		    rc.dateFilterEnd ?: endDate;
        
        var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
        var shippingMethod = getFulfillmentService().getFulfillmentMethodByFulfillmentMethodName("Shipping");
        
		logHibachi("Finding deliveries for #startDate# to #endDate#");
		
        /**
         * @param {Struct} hashmap A collection of key value pairs.
         * @param {List<String>} keys A list of keys that reference values in the map.
         * @return {Boolean} Returns True if the hashmap contains all the key 
         * values in the keys list and those values are not null.
         * False otherwise.
         */
        var containsAll = function(hashmap, keys){

            for (var key in listToArray(keys)){
                if (!structKeyExists(hashmap, key) || isNull(hashmap[key])){
                    return false;
                }
            }

            return true;
        }

        /**
         * @param {String} The order number to lookup in Slatwall.
         * @return {Boolean} Returns True if the order exists. False otherwise.
         */
        var orderExists = function(orderNumber) {
            return !isNull(getOrderService().getOrderByOrderNumber(orderNumber));
        }

        /**
         * @param {String} The order number to lookup in Slatwall.
         * @return {Boolean} Returns True if the order exists. False otherwise.
         */
        var order = function(orderNumber) {
            return getOrderService().getOrderByOrderNumber(orderNumber);
        }

        /**
         * @param {Struct} The shipment to use to create the order delivery.
         * @return {Boolean} Returns True if the tracking, ordernumber and 
         * order exist. False otherwise.
         */
        var dataExistsToCreateDelivery = function(shipment) {

            if (containsAll(shipment, "OrderNumber,Packages") && 
                orderExists(shipment.OrderNumber)){
                return true;    
            }

            return false;
        };

        /**
         * @param {String} The name of the fulfillment type to return.
         * @return {FulfillmentMethod} Returns the fulfillment method by name.
         */
        var fulfillmentMethod = function(name) {
            return getFulfillmentService().getFulfillmentMethodByFulfillmentMethodName(name);
        };

        /**
         * @param {String} The name of the fulfillment method type to check.
         * @return {FulfillmentMethod} Returns the fulfillment method by type name.
         */
        var isShippingMethodType = function(orderFulfillment) {
            return orderFulfillment.getFulfillmentMethodType() == "Shipping";
        };

        /**
         * @param {OrderFulfillment} The name of the fulfillment method type to check.
         * @return {Array} Contains fulfillment items.
         */
        var getFulfillmentItems = function(orderFulfillment, orderFulfillmentItems) {
            if (isShippingMethodType(orderFulfillment)){
                arrayAppend( orderFulfillmentItems, orderFulfillment.getOrderFulfillmentItems(), MERGE_ARRAYS );
            }
            return orderFulfillmentItems;
        };

        /**
         * @param {OrderDelivery} Creates and adds all delivery items for the order.
         * @return {OrderDeliveryItem} Returns the newly created and save item. 
         */
        var createDeliveryItem = function( orderDelivery, orderFulfillmentItem ) {
            var orderDeliveryItem = Slatwall.model.entity.OrderDeliveryItem();
            orderDeliveryItem.setQuantity(orderFulfillmentItem.getQuantity());
            orderDeliveryItem.setOrderItem(orderFulfillmentItem.getOrderItem());
            orderDeliveryItem.setOrderDelivery(orderDelivery);
			ormStatelessSession.insert("SlatwallOrderDeliveryItem", orderDeliveryItem);
            return orderDeliveryItem;
        }

        /**
         * @param {OrderDelivery} Creates and adds all SHIPPING delivery items for the 
         * order to a single delivery.
         * @return {Void} 
         */
        var createDeliveryItems = function( orderDelivery ) {
            var order = orderDelivery.getOrder();
            var orderFulfillments = order.getOrderFulfillments();

            //gets all the fulfillment items as a single array
            var orderFulfillmentItems = [];

            // Get all items.
            for (var orderFulfillment in orderFulfillments){
                orderFulfillmentItems = getFulfillmentItems( orderFulfillment, 
                    orderFulfillmentItems );
            }

            // Create all the delivery items and add them to the delivery.
            for (var orderFulfillmentItem in orderFulfillmentItems){
                var orderDeliveryItem = createDeliveryItem( orderDelivery,  
                    orderFulfillmentItem);
            }
        };

        /**
         * @param {Order} order The order to check 
         * @return {Boolean} Returns true is the entire order is delivered.
         * False otherwise.
         */
        var orderIsDelivered = function( order ){

            if (order.getQuantityUndelivered() <= 0){
                return true;
            }

            return false;
        }

        /**
         * @param {Struct} Shipment A shipment (with packages) is used to build a delivery.
         * @return {Void}
         */
        var createDelivery = function(shipment){
        	logHibachi("createDelivery: shipment.shipmentNumber");
			var order = order(shipment.OrderNumber);

            if (!isNull(order) && dataExistsToCreateDelivery(shipment) && !orderIsdelivered( order )){
                
    			var findOrderDeliveryByRemoteID = getService("OrderService").getOrderDeliveryByRemoteID(shipment.shipmentId, false);
    			
    			//Do not create this again if it already exists.
    			if (!isNull(findOrderDeliveryByRemoteID)){
    			    logHibachi("Not creating order delivery because it already exists: remoteID: #shipment.shipmentId#");
    			    return;
    			}
    			
    			// Create the delivery.  
                var orderDelivery = new Slatwall.model.entity.OrderDelivery();
    			orderDelivery.setOrder(order);
    			orderDelivery.setShipmentNumber(shipment.shipmentNumber);//Add this
    			orderDelivery.setShipmentSequence(shipment.orderShipSequence);// Add this
    			orderDelivery.setPurchaseOrderNumber(shipment.PONumber);
    			
    			
    			orderDelivery.setRemoteID( shipment.shipmentId );

    		    //get the tracking numbers.
    		    //get tracking information...
    		    var concatTrackingNumber = "";
    		    var concatScanDate = "";
    		    var packageShipDate = "";
    		    if (structKeyExists(shipment, "Packages")){
    		    	 for (var packages in shipment.Packages){
    		    		concatTrackingNumber = listAppend(concatTrackingNumber, packages.TrackingNumber);

    		    		if (!isNull(packages['ScanDate'])){
    		    			orderDelivery.setScanDate( getDateFromString(packages['ScanDate']) );//use last scan date
    		    		}

    		    		if (!isNull(shipment['UndeliveredReasonDescription'])){
    		    			orderDelivery.setUndeliverableOrderReason(shipment['UndeliveredReasonDescription']);
    		    		}

    		    		if (!isNull(shipment['PackageShipDate'])){
    		    			packageShipDate = shipment['PackageShipDate'];
    		    		}
    		    	 }
    		    }

    		    // all tracking on one fulfillment.
    		    orderDelivery.setTrackingNumber(concatTrackingNumber);
    		    orderDelivery.setCreatedDateTime(getDateFromString(packageShipDate) );
    		    orderDelivery.setModifiedDateTime( now() );
                orderDelivery.setShippingMethod( shippingMethod );
                ormStatelessSession.insert("SlatwallOrderDelivery", orderDelivery );
                createDeliveryItems( orderDelivery );
                logHibachi("Created a delivery for orderNumber: #shipment['OrderNumber']#");
                
                var orderOnDelivery = orderDelivery.getOrder();
                orderOnDelivery.updateOrderStatus();
                var  isOrderPaidFor = orderOnDelivery.isOrderPaidFor();
			
    			var isOrderFullyDelivered = orderOnDelivery.isOrderFullyDelivered();
    			
    			if(isOrderPaidFor && isOrderFullyDelivered)	{
    				orderOnDelivery.setOrderStatusType(CLOSED_STATUS);
    				ormStatelessSession.insert("SlatwallOrder", orderOnDelivery );
                    logHibachi("Closed the order for orderNumber: #shipment['OrderNumber']#");
    
                }else{
                	logHibachi("createDelivery: Can't find enough information for ordernumber: #shipment['OrderNumber']# to create the delivery");
    			}
        };

        // Map all the shipments -> deliveries.
        // This wraps the map in a new stateless session to keep things fast

        var tx = ormStatelessSession.beginTransaction();

        // Do one page at a time, flushing and clearing as we go.
        while (pageNumber < pageMax){
        	logHibachi("Importing pagenumber: #pageNumber#");
	        // Call the api and get shipment records for the date defined as the filter.
	        var response = getShipmentData(pageNumber, pageSize, dateFilterStart, dateFilterEnd);

	        if (isNull(response)){
	        	logHibachi("Unable to get a usable response from Shipments API #now()#");
	            throw("Unable to get a usable response from Shipments API #now()#");
	        }

	        var shipments = response.Records?:"null";

	        if (shipments.equals("null")){
	        	logHibachi("Response did not contain shipments.");
	            throw("Response did not contain shipments data.");
	        }

	        if (containsAll(rc, "viewResponse")){
	            writedump(shipments);abort;
	        }

			try{

	    		arrayMap( shipments, createDelivery );
	    		tx.commit();
	    		ormGetSession().clear();
			}catch(shipmentError){

				ormGetSession().clear();
				logHibachi("Error: shipmentError.getMessage()");
				writedump(shipmentError);
				abort;	
			}
			logHibachi("End Importing pagenumber: #pageNumber#");
			pageNumber++;
        }

		ormStatelessSession.close();
		writeDump("End: #pageNumber# - #pageSize#");
        // Sets the default view 

    }
    
    public any function importDailyAccountUpdates(pageSize, pageNumber, pageMax){
        //get the api key from integration settings.
		var integration = getService("IntegrationService").getIntegrationByIntegrationPackage("monat");
		var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
		
		/*
		"Filters": {
		    "StartDate": "2019-10-01T19:16:28.693Z",
		    "EndDate": "2019-10-20T19:16:28.693Z"
		  },
		*/
		var index=0;
		while (arguments.pageNumber < arguments.pageMax){
			
    		var accountsResponse = getDailyAccountUpdatesData(pageNumber, pageSize);
    		if (accountsResponse.hasErrors){
    		    //goto next page causing this is erroring!
    		    arguments.pageNumber++;
    		    continue;
    		}
    		
    		var accounts = accountsResponse.Data.Records;
    		
    		
    		
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
        			var foundAccount = getAccountService().getAccountByAccountNumber( account['AccountNumber'] );
        			
        			if (isNull(foundAccount)){
        				pageNumber++;
        				logHibachi("Could not find this account to update: Account number #account['AccountNumber']#");
        				continue;
        			}
        			
                    //Account Status Code
                    if (!isNull(account['AccountStatusCode']) && len(account['AccountStatusCode'])){
                    	foundAccount.setAccountStatus(account['AccountStatusCode']?:"");
                    	
                    	//If the account is suspended, deactivate it.
                    	if (account['AccountStatusName'] == "Suspended"){
                    	    foundAccount.setActiveFlag(false);
                    	}
                    }
                    
                    //Entry Date
                    //This should be POST date
                    /*if (!isNull(account['EntryDate']) && len(account['EntryDate'])){
                    	foundAccount.setCreatedDateTime( getDateFromString(account['EntryDate']) ); 
                    }*/
                    
                    // SponsorNumber
                    
                    if (!isNull(account['AccountNumber']) && 
                    	!isNull(account['SponsorNumber']) && 
                    	len(account['AccountNumber']) && 
                    	len(account['SponsorNumber']) && 
                    	account['AccountNumber'] != account['SponsorNumber'] &&
                    	foundAccount.getSponsorIDNumber() != account['SponsorNumber']){
                    	var notUnique = false;
                    	
                    	try{
                    		var newSponsorAccount = getService("AccountService")
                    			.getAccountByAccountNumber(account['SponsorNumber']);
                    		var childAccount = foundAccount;
                    		var sponsorAccount =foundAccount.getOwnerAccount();
                    	}catch(nonUniqueResultException){
                    		//not unique
                    		notUnique = true;
                    	}
                    	
                    	if (!notUnique && !isNull(sponsorAccount) && !isNull(childAccount)){
                    		var newAccountRelationship = getService("AccountService")
                    			.getAccountRelationshipByChildAccountANDParentAccount({1:childAccount, 2:sponsorAccount}, false);
                    		
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
	                    	
	                    	foundAccount.setOwnerAccount(sponsorAccount);
                    	}
                    }
                    
                    // EnrollerNumber (Note: What is this mapping to?) This is the same as sponsor number.
                    /*if (!isNull(account['EnrollerNumber']) && len(account['EnrollerNumber'])){
                    	foundAccount.setAccountNumber( account['EnrollerNumber']?:"" );//this shouldn't change if its account number...
                    }*/
                    
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
                    
                    //EntryPeriod (What is this mapping to)
                    if (!isNull(account['EntryPeriod']) && len(account['EntryPeriod'])){
                    	//foundAccount.setEntryPeriod( account['EntryPeriod']?:"" );
                    }
                    
                    //FlagAccountTypeCode (C,L,M,O,R)
                    if (!isNull(account['FlagAccountTypeCode']) && len(account['FlagAccountTypeCode'])){
                    	//set the accountType from this. Needs to be name or I need to map it.
                    	foundAccount.setComplianceStatus( account['FlagAccountTypeCode']?:"" );
                    }
                    
                    // GovernmentNumber (We will also need government type code?)
                    // Will this be plain text? Lookup by the government number.
                    // We will need the encrypted number sent as well. And, some other information.
                    // Commenting this out until we have those things.
                    /*if (!isNull(account['GovernmentNumber']) && len(account['GovernmentNumber'])){
                    	
                    	//Find or create a government id and set the number.
                    	if (structKeyExists(account, "GovernmentNumber") && structKeyExists(account, "GovernmentTypeCode")){
	                    	// lookup the id
	                    	var isNewGovernementNumber = false;
	                    	try{
	                    		var accountGovernmentID = getAccountService().getAccountGovernmentIdByGovernmentTypeANDgovernmentIdLastFour({1:account['GovernmentTypeCode']?:"",2:account['GovernmentNumber']});
	                    	} catch(governmentLookupError){
	                    		isNewGovernmentNumber = true;
	                    	}
	                    	
	                    	//create a new one.
	                    	if (isNewGovernementNumber){
	                    		var accountGovernmentID = new Slatwall.model.entity.AccountGovernmentID();
	                    	}
		                    accountGovernmentID.setAccount(foundAccount);
		                    accountGovernmentID.setGovernmentType(account['GovernmentTypeCode']?:"");//*
		                    accountGovernmentID.setGovernmentIDlastFour(account['GovernmentNumber']);//*
		                    
		                    //insert the relationship
		                    ormStatelessSession.insert("SlatwallAccountGovernmentID", accountGovernmentID);
                    	}
                    }*/
                    
                    //CareerTitleCode
                    foundAccount.setCareerTitle( account['CareerTitleCode']?:"" );
                    
                    ormStatelessSession.update("SlatwallAccount", foundAccount);

    			}
    			
    			tx.commit();
    		}catch(e){
    			
    			logHibachi("Daily Account Import Failed @ Index: #index# PageSize: #arguments.pageSize# PageNumber: #arguments.pageNumber#");
    			//writeDump(e); // rollback the tx
    			ormGetSession().clear();
    			ormStatelessSession.close();
    			abort;
    		}
    		
    		//echo("Clear session");
    		this.logHibachi('Import (Daily Updated Accounts) Page #arguments.pageNumber# completed ', true);
    		ormGetSession().clear();//clear every page records...
		    pageNumber++;
		}
		
		ormStatelessSession.close(); //must close the session regardless of errors.
		logHibachi("End: #arguments.pageNumber# - #arguments.pageSize# - #index#");
    }
    
}