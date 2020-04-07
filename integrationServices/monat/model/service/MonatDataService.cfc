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
	
	private any function getData(pageNumber,pageSize,dateFilterStart,dateFilterEnd,name){
	    var uri = setting('baseImportURL') & name;
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

		logHibachi("Could not import #name#(s) on this page: PS-#arguments.pageSize# PN-#pageNumber#", true);
		fsResponse.hasErrors = true;


		return fsResponse;
	}
	
	public void function importOrderShipments(){ 
        logHibachi("Begin importing order deliveries.", true);
        
        /**
         * Allows the user to override the last n HOURS that get checked. 
         * Defaults to 60 Minutes ago.
         **/
        var intervalOverride = 1;
        
        /**
         * The ids of the orderitems to be added to the entity queue (List)
         **/
        var modifiedEntityIDs = "";
        
        /**
         * CONSTANTS 
         **/
        var MERGE_ARRAYS = true;
        var SHIPPED = "Shipped";
        var CLOSEDSTATUS = getTypeService().getTypeByTypeName(SHIPPED);
        var HOURS = 'h';
        var stockLocation = getLocationService().getLocationByLocationID("88e6d435d3ac2e5947c81ab3da60eba2");
        
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
		 * The string representation for the date sity HOURS ago. 
		 * Uses number format to make sure each minute, second will use 2 places.
		 * This checks for the last hour of deliveries every 15 HOURS.
		 * This only adds a delivery IF its not already delivered, so we can do that.
		 * 
		 **/
	    var startDate = "#year(sixtyMinutesAgo)#-#numberFormat(month(sixtyMinutesAgo),'00')#-#numberFormat(day(sixtyMinutesAgo),'00')#T#numberformat(hour(sixtyMinutesAgo),'00')#:#numberformat(minute(sixtyMinutesAgo), '00')#:#numberformat(second(sixtyMinutesAgo), '00')#.693Z";
	
		/**
		 * This should always equal now.
		 **/
        var endDate =  "#year(now())#-#numberFormat(month(now()),'00')#-#numberFormat(day(now()),'00')#T#numberFormat(hour(now()),'00')#:#numberformat(minute(now()), '00')#:#numberformat(second(now()), '00')#.693Z";
	
		/**
		 * You can pass in a start date or end date in the rc 
		 **/
		var dateFilterStart = startDate;
		var dateFilterEnd = endDate;
		
		/**
		 * Use a stateless session so we can use objects without memory issues.
		 * Statelss sessions don't populate any entity related data. Just the
		 * first level. You can set data on them and save them so good use-case.
		 **/
        var ormStatelessSession = ormGetSessionFactory().openStatelessSession();
        var shippingMethod = getShippingService().getShippingMethodByShippingMethodCode("defaultShippingMethod");
        
		logHibachi("Finding deliveries for #startDate# to #endDate#", true);
		
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
        };

        /**
         * @param {String} The order number to lookup in Slatwall.
         * @return {Boolean} Returns True if the order exists. False otherwise.
         */
        var orderExists = function(orderNumber) {
            return !isNull(getOrderService().getOrderByOrderNumber(orderNumber));
        };

        /**
         * @param {String} The order number to lookup in Slatwall.
         * @return {Boolean} Returns True if the order exists. False otherwise.
         */
        var order = function(orderNumber) {
            return getOrderService().getOrderByOrderNumber(orderNumber);
        };

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
            var orderDeliveryItem = new Slatwall.model.entity.OrderDeliveryItem();
            orderDeliveryItem.setQuantity(orderFulfillmentItem.getQuantity());
            orderDeliveryItem.setOrderItem(orderFulfillmentItem);
            orderDeliveryItem.setOrderDelivery(orderDelivery);
            
            //now try to find the stock to attach
            var sku = orderFulfillmentItem.getSku();
            
            if (!isNull(sku)){
                var stock = getStockService().getStockBySkuAndLocation(sku, stockLocation);
            }
            
            if (!isNull(stock)){
                orderDeliveryItem.setStock( stock );
            }
            
			ormStatelessSession.insert("SlatwallOrderDeliveryItem", orderDeliveryItem);
			
            return orderDeliveryItem;
        };

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
            modifiedEntityIDs = listAppend(modifiedEntityIDs, order.getOrderID());
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
        };

        /**
         * @param {Struct} Shipment A shipment (with packages) is used to build a delivery.
         * @return {Void}
         */
        var createDelivery = function(shipment){
        	logHibachi("createDelivery: #shipment.shipmentNumber#",true);
			var order = order(shipment.OrderNumber);

            if (!isNull(order) && dataExistsToCreateDelivery(shipment) && !orderIsdelivered( order )){
                
    			var findOrderDeliveryByRemoteID = getOrderService().getOrderDeliveryByRemoteID(shipment.shipmentId, false);
    			
    			//Do not create this again if it already exists.
    			if (!isNull(findOrderDeliveryByRemoteID)){
    			    logHibachi("Not creating order delivery because it already exists: remoteID: #shipment.shipmentId#",true);
    			    return;
    			}
    			
    			// Create the delivery.  
                var orderDelivery = new Slatwall.model.entity.OrderDelivery();
    			orderDelivery.setOrder(order);
    			orderDelivery.setShipmentNumber(shipment.shipmentNumber?:"");//Add this
    			orderDelivery.setShipmentSequence(shipment.orderShipSequence?:"");// Add this
    			orderDelivery.setPurchaseOrderNumber(shipment.PONumber?:"");
    			
    			
    			orderDelivery.setRemoteID( shipment.shipmentId ?:"");

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

    		    		if (!isNull(packages['UndeliveredReasonDescription'])){
    		    			orderDelivery.setUndeliverableOrderReason(packages['UndeliveredReasonDescription']);
    		    		}
                        
    		    		if (!isNull(packages['PackageShipDate'])){
    		    			packageShipDate = packages['PackageShipDate'];
    		    			orderDelivery.setCreatedDateTime(getDateFromString(packageShipDate) );
    		    		}
    		    	 }
    		    }

    		    // all tracking on one fulfillment.
    		    orderDelivery.setTrackingNumber(concatTrackingNumber);
    		    orderDelivery.setModifiedDateTime( now() );
                orderDelivery.setShippingMethod( shippingMethod );
                orderDelivery.setFulfillmentMethod( shippingMethod.getFulfillmentMethod() );
                
                //Sets the tracking URL
                if (!isNull(orderDelivery.getTrackingNumber()) && 
						!isNull(orderDelivery.getShippingMethod())){
					
					var trackingUrl = orderDelivery.getShippingMethod().setting("shippingMethodTrackingURL") 
					if (!isNull(trackingUrl)){
						trackingUrl = trackingUrl.replace("${trackingNumber}", orderDelivery.getTrackingNumber());
						orderDelivery.setTrackingURL(trackingUrl);
					}
				}
                
                
                ormStatelessSession.insert("SlatwallOrderDelivery", orderDelivery );
                
                createDeliveryItems( orderDelivery );
                logHibachi("Created a delivery for orderNumber: #shipment['OrderNumber']#",true);
                
                // Close the order.
                //now fire the event for this delivery.
                var eventData = {entity: orderDelivery};
                getHibachiScope().getService("hibachiEventService").announceEvent(eventName="afterOrderDeliveryCreateSuccess", eventData=eventData);
                
            }else{
                logHibachi("createDelivery: Can't create the delivery - already exists or data not present.", true);
            }
        };

        // Map all the shipments -> deliveries.

		logHibachi("Start Shipment Importer",true);
        
        //Get the totals on this call.
		var response = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SWGetShipmentInfo");
		
		var TotalCount = response.totalCount?:0;
		var TotalPages = response.totalPages?:0;

        
        //Exit if there is no data.
        if (!TotalCount){
            logHibachi("No Shipment Data to import at this time.",true);
        }
        
        logHibachi("Shipment TotalPages: #totalPages#",true);
        
        // Do one page at a time, flushing and clearing as we go.
        // This wraps the map in a new stateless session to keep things fast
        var tx = ormStatelessSession.beginTransaction();
        while (pageNumber <= TotalPages){
            
        	logHibachi("Importing pagenumber: #pageNumber#",true);
	        // Call the api and get shipment records for the date defined as the filter.
	        var response = getData(pageNumber, pageSize, dateFilterStart, dateFilterEnd, "SWGetShipmentInfo");
	        
	        if (isNull(response)){
	        	logHibachi("Unable to get a usable response from Shipments API #now()#",true);
	            throw("Unable to get a usable response from Shipments API #now()#");
	        }
            
	        var shipments = response.Records?:"null";
            
            
	        if (shipments.equals("null")){
	        	logHibachi("Response did not contain shipments.",true);
	            throw("Response did not contain shipments data.");
	        }

			try{
                /**
                 * MAPS JSON to Slatwall OrderDeliverys
                 * {JSON_OBJ} -> SlatwallOrderDelivery
                 **/
	    		arrayMap( shipments, createDelivery );
	    		
			}catch(any shipmentError){
				logHibachi("Errors: importing shipment. #shipmentError.message#",true);
			}
			
			logHibachi("End Importing pagenumber: #pageNumber#",true);
			pageNumber++;
        }
        tx.commit();
		ormStatelessSession.close();
		
		//now set al the orders to closed.
		for (var orderID in modifiedEntityIDs){
		    var order = getService("OrderService").getOrderByOrderID(orderID);
		    order.setOrderStatusType(CLOSEDSTATUS);
		    var orderItems = order.getOrderItems();
		    for(var orderItem in orderItems){
		        orderItem.updateCalculatedProperties(true);
		    }
		    getService("OrderService").saveOrder(order);
		    
		    ormFlush();
		}
		
		writeDump("End: #pageNumber# - #pageSize#");
        // Sets the default view 

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
		return "SKUItemCode,SKUItemID,PRODUCTItemCode,ItemName,Amount,SalesCategoryCode,SAPItemCode,ItemNote,DisableOnRegularOrders,DisableOnFlexship,ItemCategoryAccounting,CategoryNameAccounting,EntryDate,URLTitle";
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

	private any function populateSkuBundleQuery( required any skuBundleQuery, required struct skuData ){

		for(var kit in arguments.skuData.KitLines){
			var skuBundleData = {
				'SKUItemCode' : trim(skuData['ItemCode']),
				'ComponentItemCode' : kit['ComponentItemCode'],
				'importKey' : trim(skuData['ItemCode']) & "-" & kit['ComponentItemCode'],
				'ComponentQuantity' : kit['ComponentQty']
			};
			if(structKeyExists(kit,'ontheflykit')){
				skuBundleData['ontheflykit'] = kit['ontheflykit'];
			}
			QueryAddRow(arguments.skuBundleQuery, skuBundleData);
		}
		return arguments.skuBundleQuery;
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
					productCodes ={value = arrayToList(siteProductCodes[swSite]), list=true}, 
					siteID = swSites[swSite]
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
		var initProductData = this.getApiResponse(!structIsEmpty(extraBody) ? "SWGetNewUpdatedSKU" : "QueryItems", 1, arguments.pageSize, arguments.extraBody );
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

		var extraBody = {};
		

		if(arguments.rc.days > 0){
			extraBody = {
				"Filters": {
				    "StartDate": DateTimeFormat( now(), "yyyy-mm-dd'T'00:00:01'.693Z'" ),
		            "EndDate": DateTimeFormat( now(), "yyyy-mm-dd'T'23:59:59'.693Z'" )
				}
			};
		}

		if(!structKeyExists(arguments.rc, 'pageMax')){
			arguments.rc.pageMax = this.getLastProductPageNumber(arguments.rc.pageSize, extraBody);
		}

		var basePath = getDirectoryFromPath(getCurrentTemplatePath());

		var countryToCurrency = {
			'CAN' : 'CAD',
			'GBR' : 'GBP',
			'USA' : 'USD',
			'IRL' : 'EUR',
			'POL' : 'PLN',
			'CAN' : 'CAD',
		};

		var siteProductCodes = {
			'CAN' = [],
			'GBR' = [],
			'AUD' = [],
			'IRL' = [],
			'POL' = [],
			'USA' = []
		};

		var skuColumns = this.getSkuColumnsList();
		var skuColumnTypes = [];
		ArraySet(skuColumnTypes, 1, ListLen(skuColumns), 'varchar');
		var skuQuery = QueryNew(skuColumns, skuColumnTypes);

		var skuPriceColumns = this.getSkuPriceColumnsList();
		var skuPriceColumnTypes = [];
		ArraySet(skuPriceColumnTypes, 1, ListLen(skuPriceColumns), 'varchar');
		var skuPriceQuery = QueryNew(skuPriceColumns, skuPriceColumnTypes);

		var skuBundleColumns = this.getSkuBundleColumnsList();
		var skuBundleColumnTypes = [];
		ArraySet(skuBundleColumnTypes, 1, ListLen(skuBundleColumns), 'varchar');
		var skuBundleQuery = QueryNew(skuBundleColumns, skuBundleColumnTypes);

		var stockColumns = this.getStockColumnsList();
		var stockColumnTypes = [];
		ArraySet(stockColumnTypes, 1, ListLen(stockColumns), 'varchar');
		var stockQuery = QueryNew(stockColumns, stockColumnTypes);


		for(var index = arguments.rc.pageNumber; index <= arguments.rc.pageMax; index++){
			var productResponse = this.getApiResponse( arguments.rc.days > 0 ? "SWGetNewUpdatedSKU" : "QueryItems", index, arguments.rc.pageSize, extraBody );

			//goto next page causing this is erroring!
			if ( productResponse.hasErrors ){
				continue;
			}

			//Set the pagination info.
			var monatProducts = productResponse.Data.Records ?: [];

			for (var skuData in monatProducts){

				// Setup Sku data 
				var sku = {
					'SKUItemID' : trim(skuData['ItemId']),
					'SKUItemCode' : trim(skuData['ItemCode']),
					'PRODUCTItemCode' : trim(skuData['ItemCode']),
					'ItemName' : trim(skuData['ItemName']),
					'ItemNote' : skuData['ItemNote'] ?: '',
					'SalesCategoryCode' : trim(skuData['SalesCategoryCode']),
					'DisableOnRegularOrders' : skuData['DisableInDTX'] ?: false,
					'DisableOnFlexShip' : skuData['DisableInFlexShip'] ?: false,
					'ItemCategoryAccounting' : trim(skuData['ItemCategoryCode']),
					'CategoryNameAccounting' : trim(skuData['ItemCategoryName']),
					'EntryDate' : skuData['EntryDate']
				};

				if (ArrayLen(skuData['SAPItemCodes'])) {
					sku['SAPItemCode'] = skuData['SAPItemCodes'][1]['SAPItemCode'];

					// Create Stock Query
					stockQuery = this.populateStockQuery(stockQuery, skuData);

					for(var sapItem in skuData['SAPItemCodes']){
						if(!structKeyExists(siteProductCodes, sapItem['countryCode'])){
							continue;
						}
						arrayAppend(siteProductCodes[sapItem['countryCode']], sku['SKUItemCode'])
					}


				}else{
					sku['SAPItemCode'] = skuData['ItemCode'];
				}


				// Setup SkuPrice data
				if(structKeyExists(skuData, 'PriceLevels') && ArrayLen(skuData['PriceLevels'])){
					for(var skuPriceData in skuData.PriceLevels){
						if( skuPriceData['CountryCode'] == 'UNK'){
							continue;
						}
						var skuPrice = {
							'ItemCode' : skuData.ItemCode,
							'Commission' : skuPriceData['CommissionableVolume'] ?: 0,
							'QualifyingPrice' : skuPriceData['QualifyingVolume'] ?: 0,
							'RetailsCommissions' : skuPriceData['RetailProfit'] ?: 0,
							'RetailValueVolume' : skuPriceData['RetailVolume'] ?: 0,
							'SellingPrice' : skuPriceData['SellingPrice'] ?: 0,
							'TaxablePrice' : skuPriceData['TaxablePrice'] ?: 0,
							'ProductPackBonus' : skuPriceData['ProductPackVolume'] ?: 0,
							'PriceLevel' : skuPriceData['PriceLevelCode'],
							'CurrencyCode' : countryToCurrency[skuPriceData['CountryCode']]
						};

						// Check if this is the SKU price
						if(skuPrice['CurrencyCode'] == 'USD' && skuPrice['PriceLevel'] == '2'){
							sku['Amount'] = skuPrice['SellingPrice'];
						}
						// Add SkuPrice to CF Query
						QueryAddRow(skuPriceQuery, skuPrice);
					}
				}
				// If Sku Price not found, set it to 0
				if(!structKeyExists(sku,'Amount')){
					sku['Amount'] = 0;
				}
				// Add Sku to CF Query
				QueryAddRow(skuQuery, sku);

				// Create SkuBundle Query
				if(arrayLen(skuData['KitLines'])){
					skuBundleQuery = this.populateSkuBundleQuery(skuBundleQuery, skuData);
				}
			}
		}

		if(skuQuery.recordCount){
			var importSkuConfig = FileRead('#basePath#../../config/import/skus.json');
			getService("HibachiDataService").loadDataFromQuery(skuQuery, importSkuConfig, arguments.rc.dryRun);
		}

		if(skuPriceQuery.recordCount){
			var importSkuPriceConfig = FileRead('#basePath#../../config/import/skuprices.json');
			getService("HibachiDataService").loadDataFromQuery(skuPriceQuery, importSkuPriceConfig, arguments.rc.dryRun);
		}

		if(skuBundleQuery.recordCount){
			var importSkuBundleConfig = FileRead('#basePath#../../config/import/bundles.json');
			getService("HibachiDataService").loadDataFromQuery(skuBundleQuery, importSkuBundleConfig, arguments.rc.dryRun);

			var importSkuBundle2Config = FileRead('#basePath#../../config/import/bundles2.json');
			getService("HibachiDataService").loadDataFromQuery(skuBundleQuery, importSkuBundle2Config, arguments.rc.dryRun);
		}

		if(stockQuery.recordCount){
			var importStockConfig = FileRead('#basePath#../../config/import/stocks.json');
			getService("HibachiDataService").loadDataFromQuery(stockQuery, importStockConfig, arguments.rc.dryRun);
		}
		
		
		//Fix ProductTypes:
		QueryExecute("UPDATE swProductType SET parentProductTypeID = '444df2f7ea9c87e60051f3cd87b435a1' WHERE parentProductTypeID IS NULL AND productTypeNamePath LIKE 'Merchandise > %'");
		QueryExecute("UPDATE swProductType SET productTypeIDPath = CONCAT('444df2f7ea9c87e60051f3cd87b435a1,',productTypeIDPath) WHERE parentProductTypeID = '444df2f7ea9c87e60051f3cd87b435a1' AND productTypeIDPath NOT LIKE '444df2f7ea9c87e60051f3cd87b435a1,%'");

// 		//this.addUrlTitlesToProducts();
		if(!arguments.rc.dryRun){
			this.associateProductWithSite(siteProductCodes);
		}else{
			abort;
		}
		
		abort;
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
		var warehouseUK = getLocationService().getLocationByLocationName("UK Warehouse");
		var warehouseIRPOL = getLocationService().getLocationByLocationName("Ire/Pol Warehouse");
		 
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
    		
    		
    		try{
    			
    			var inventoryRecords = inventoryResponse.Records;
    			
    			for (var inventory in inventoryRecords){
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
        		    }else if (inventory['CountryCode'] == "UK"){
        		    	location = warehouseUK;
        		    } else {
        		    	location = warehouseIRPOL;
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
        		    
    			}
    			
    		}catch(e){
    			logHibachi("Stock Import Failed @ Index: #index# PageSize: #pageSize# PageNumber: #pageNumber#", true);
    			logHibachi(serializeJson(e));
    			
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
			var productResponse = this.getApiResponse( arguments.rc.days > 0 ? "SWGetNewUpdatedSKU" : "QueryItems", index, arguments.rc.pageSize, extraBody );

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
