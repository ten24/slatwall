angular.module('slatwalladmin')
    .directive('swOrderItems', [
    '$log',
    '$timeout',
    '$location',
    '$slatwall',
    'formService',
    'partialsPath',
    'paginationService',
    'collectionConfigService',
    function ($log, $timeout, $location, $slatwall, formService, partialsPath, paginationService, collectionConfigService) {
        return {
            restrict: 'E',
            scope: {
                orderId: "@"
            },
            templateUrl: partialsPath + "orderitems.html",
            link: function (scope, element, attrs) {
                scope.keywords = "";
                scope.loadingCollection = false;
                var searchPromise;
                scope.searchCollection = function () {
                    if (searchPromise) {
                        $timeout.cancel(searchPromise);
                    }
                    searchPromise = $timeout(function () {
                        $log.debug('search with keywords');
                        $log.debug(scope.keywords);
                        //Set current page here so that the pagination does not break when getting collection
                        scope.paginator.setCurrentPage(1);
                        scope.loadingCollection = true;
                        scope.getCollection();
                    }, 500);
                };
                $log.debug('Init Order Item');
                $log.debug(scope.orderId);
                //Setup the data needed for each order item object.
                scope.getCollection = function () {
                    var orderItemCollection = collectionConfigService.newCollectionConfig('OrderItem');
                    orderItemCollection.setDisplayProperties('orderItemID,currencyCode,orderItemType,price,sku.skuName,skuPrice,sku.skuID,sku.skuCode,productBundleGroup.productBundleGroupID,sku.product.productID,' +
                        'sku.product.productName,sku.product.productDescription,sku.eventStartDateTime,' +
                        'quantity,orderFulfillment.fulfillmentMethod.fulfillmentMethodName,orderFulfillment.orderFulfillmentID,' +
                        'orderFulfillment.shippingAddress.streetAddress,' +
                        'orderFulfillment.shippingAddress.street2Address,orderFulfillment.shippingAddress.postalCode,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode,' +
                        'orderFulfillment.shippingAddress.countryCode,itemTotal,discountAmount,taxAmount,extendedPrice,productBundlePrice,sku.baseProductType')
                        .addFilter('order.orderID', scope.orderId)
                        .addFilter('order.parentOrderItem', 'null', 'IS')
                        .setKeywords(scope.keywords)
                        .setPageShow(scope.paginator.getPageShow());
                    angular.forEach(scope.attributes, function (attribute) {
                        var attributeColumn = {
                            propertyIdentifier: "_orderitem." + attribute.attributeCode,
                            attributeID: attribute.attributeID,
                            attributeSetObject: "orderItem"
                        };
                        orderItemCollection.columns.push(attributeColumn);
                    });
                    var orderItemsPromise = orderItemCollection.getEntity();
                    orderItemsPromise.then(function (value) {
                        scope.collection = value;
                        var collectionConfig = {};
                        scope.orderItems = $slatwall.populateCollection(value.pageRecords, orderItemCollection);
                        for (var orderItem in scope.orderItems) {
                            $log.debug("OrderItem Product Type");
                            $log.debug(scope.orderItems);
                        }
                        scope.paginator.setPageRecordsInfo(scope.collection);
                        scope.loadingCollection = false;
                    }, function (value) {
                        scope.orderItems = [];
                    });
                    //   ];
                    // 	//add attributes to the column config
                    // 	angular.forEach(scope.attributes,function(attribute){
                    // 		var attributeColumn = {
                    // 			propertyIdentifier:"_orderitem."+attribute.attributeCode,
                    // 			attributeID:attribute.attributeID,
                    // 	         attributeSetObject:"orderItem"
                    // 		};
                    // 		columnsConfig.push(attributeColumn);
                    // 	});
                    // 	var filterGroupsConfig =[
                    // 	    {
                    // 	      "filterGroup": [
                    // 	        {
                    // 	          "propertyIdentifier": "_orderitem.order.orderID",
                    // 	          "comparisonOperator": "=",
                    // 	          "value": scope.orderId,
                    // 	        },
                    // 	        {
                    // 	        	"logicalOperator":"AND",
                    // 	          "propertyIdentifier": "_orderitem.parentOrderItem",
                    // 	          "comparisonOperator": "is",
                    // 	          "value": "null",
                    // 	        }
                    // 	      ]
                    // 	    }
                    // 	  ];
                    // 	var options = {
                    // 		columnsConfig:angular.toJson(columnsConfig),
                    // 		filterGroupsConfig:angular.toJson(filterGroupsConfig),
                    // 		currentPage:scope.paginator.getCurrentPage(),
                    // 		pageShow:scope.paginator.getPageShow(),
                    // 		keywords:scope.keywords
                    // 	};
                    // 	//Create a list of order items.
                    // 	//scope.orderItems = [];
                    // 	scope.orderAttributes = [];
                    // 	scope.attributeValues = [];
                    // 	var orderItemsPromise = $slatwall.getEntity('orderItem', options);
                    // 	orderItemsPromise.then(function(value){
                    // 		scope.collection = value;
                    // 		var collectionConfig = {};
                    // 		collectionConfig.columns = columnsConfig;
                    // 		collectionConfig.baseEntityName = 'SlatwallOrderItem';
                    // 		collectionConfig.baseEntityAlias = '_orderitem';
                    // 		scope.orderItems = $slatwall.populateCollection(value.pageRecords,collectionConfig);
                    //          for (var orderItem in scope.orderItems){
                    //              $log.debug("OrderItem Product Type");
                    //              $log.debug(scope.orderItems);
                    //              //orderItem.productType = orderItem.data.sku.data.product.data.productType.$$getParentProductType();
                    //          }
                    //         scope.paginator.setPageRecordsInfo(scope.collection);
                    // 		scope.loadingCollection = false;
                    // 	},function(value){
                    //          scope.orderItems = [];
                    //     });
                };
                //get all possible attributes
                var attributesCollection = collectionConfigService.newCollectionConfig('Attribute');
                attributesCollection.setDisplayProperties('attributeID,attributeCode,attributeName')
                    .addFilter('displayOnOrderDetailFlag', true)
                    .addFilter('activeFlag', true)
                    .setAllRecords(true);
                var attItemsPromise = attributesCollection.getEntity();
                attItemsPromise.then(function (value) {
                    scope.attributes = [];
                    angular.forEach(value.records, function (attributeItemData) {
                        //Use that custom attribute name to get the value.
                        scope.attributes.push(attributeItemData);
                    });
                    scope.getCollection();
                });
                //Add claim function and cancel function
                // scope.appendToCollection = function(){
                // 	if(scope.pageShow === 'Auto'){
                // 		$log.debug('AppendToCollection');
                // 		if(scope.paginator.autoScrollPage < scope.collection.totalPages){
                // 			scope.paginator.autoScrollDisabled = true;
                // 			scope.paginator.autoScrollPage++;
                // 			var appendOptions = {};
                // 			angular.extend(appendOptions,options);
                // 			appendOptions.pageShow = 50;
                // 			appendOptions.currentPage = scope.paginator.autoScrollPage;
                // 			var collectionListingPromise = $slatwall.getEntity('orderItem', appendOptions);
                // 			collectionListingPromise.then(function(value){
                // 				scope.collection.pageRecords = scope.collection.pageRecords.concat(value.pageRecords);
                // 				scope.autoScrollDisabled = false;
                // 			},function(reason){
                //                 scope.collection.pageRecords = [];
                // 			});
                // 		}
                // 	}
                // };
                scope.paginator = paginationService.createPagination();
                scope.paginator.collection = scope.collection;
                scope.paginator.getCollection = scope.getCollection;
            } //<--End link
        };
    }
]);

//# sourceMappingURL=sworderitems.js.map
