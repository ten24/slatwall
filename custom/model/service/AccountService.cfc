component extends="Slatwall.model.service.AccountService" {
    
    public any function getAllOrdersOnAccount(required any account, struct data={}) {
        param name="arguments.data.currentPage" default=1;
        param name="arguments.data.pageRecordsShow" default= getHibachiScope().setting('GLOBALAPIPAGESHOWLIMIT');
        param name="arguments.data.orderID" default= "";
        param name="arguments.data.keyword" default= "";
        
		var ordersList = getService('OrderService').getOrderCollectionList();

		ordersList.addOrderBy('orderOpenDateTime|DESC');
		ordersList.setDisplayProperties('
			orderID,
			calculatedTotalItemQuantity,
			orderNumber,
			calculatedTotal,
			createdDateTime,
			orderStatusType.typeName,
			orderFulfillments.shippingAddress.streetAddress,
			orderFulfillments.shippingAddress.street2Address,
			orderFulfillments.shippingAddress.city,
			orderFulfillments.shippingAddress.stateCode,
			orderFulfillments.shippingAddress.postalCode
		');
		
		ordersList.addFilter( 'account.accountID', arguments.account.getAccountID() );
		ordersList.addFilter( 'orderStatusType.systemCode', 'ostNotPlaced', '!=');
		
		if( len(arguments.data.orderID) ){
		    ordersList.addFilter( 'orderID', arguments.data.orderID );
		}
		if( len(arguments.data.keyword) ){
			ordersList.addFilter(
					propertyIdentifier = 'orderNumber', 
					comparisonOperator = '=', 
					value = arguments.data.keyword,
					logicalOperator = 'OR', 
					filterGroupLogicalOperator = 'AND', 
					filterGroupAlias = 'additionalKeywordFilters'
				);
			ordersList.addFilter(
					propertyIdentifier = 'orderPayments.purchaseOrderNumber', 
					comparisonOperator = '=', 
					value = arguments.data.keyword,
					logicalOperator = 'OR', 
					filterGroupLogicalOperator = 'AND', 
					filterGroupAlias = 'additionalKeywordFilters'
				);
			ordersList.addFilter(
					propertyIdentifier = 'orderItems.sku.skuName', 
					comparisonOperator = 'LIKE', 
					value = "%"&arguments.data.keyword&"%",
					logicalOperator = 'OR', 
					filterGroupLogicalOperator = 'AND', 
					filterGroupAlias = 'additionalKeywordFilters'
				);
		}
		ordersList.addGroupBy('orderID');
		ordersList.setPageRecordsShow(arguments.data.pageRecordsShow);
		ordersList.setCurrentPageDeclaration(arguments.data.currentPage); 
		var orderRecords = ordersList.getPageRecords(formatRecord = false);
		
		var orderIDs = [];
		for( var order in orderRecords) {
			ArrayAppend( orderIDs, "'"&order['orderID']&"'");
		}
		
		//get orders with delivery tracking numbers
		var orderDeliveriesCollectionList = getOrderService().getOrderDeliveryCollectionList();
		orderDeliveriesCollectionList.setDisplayProperties('order.orderID, trackingNumber');
		orderDeliveriesCollectionList.addFilter( 'order.orderID', ArrayToList(orderIDs), 'IN');
		
		return { 
			"ordersOnAccount": orderRecords, 
			"orderDeliveries": orderDeliveriesCollectionList.getRecords(formatRecord = true),
			"records"		 : ordersList.getRecordsCount(),
		    "pageRecordsShow": ordersList.getPageRecordsShow(),
		    "currentPage"    : ordersList.getCurrentPage()
		};
	}
	
}