angular.module('slatwalladmin')
.directive('swOrderItems', [
'$log',
'$timeout',
'$location',
'$slatwall',
'formService',
'orderItemService',
'partialsPath',
'paginationService',

	function(
	$log,
	$timeout,
	$location,
	$slatwall,
	formService,
	orderItemService,
	partialsPath,
	paginationService
	){
		return {
			restrict: 'E',
			scope:{
				orderId:"@"
			},
			templateUrl:partialsPath+"orderitemrows.html",
			
			link: function(scope, element, attrs){
				
				scope.currentPage= paginationService.getCurrentPage();
				scope.pageShow = paginationService.getPageShow();
				scope.pageStart = paginationService.getPageStart;
				scope.pageEnd = paginationService.getPageEnd;
				scope.recordsCount = paginationService.getRecordsCount;
				scope.autoScrollPage = 1;
				scope.autoScrollDisabled = false;
				
				scope.keywords = "";
				scope.loadingCollection = false;
				var searchPromise;
				scope.searchCollection = function($timout){
					if(searchPromise) {
						$timeout.cancel(searchPromise);
					}
					
					searchPromise = $timeout(function(){
						$log.debug('search with keywords');
						$log.debug(scope.keywords);
						//Set current page here so that the pagination does not break when getting collection
						paginationService.setCurrentPage(1);
						scope.loadingCollection = true;
						scope.getCollection();
					}, 500);
				};
				
				$log.debug('Init Order Item');
				$log.debug(scope.orderId);	
				scope.customAttributeNames = [];
				
				//Setup the data needed for each order item object.
				scope.getCollection = function(){
					var columnsConfig =[
					         {
		 				      "isDeletable": false,
		 				      "isExportable": true,
		 				      "propertyIdentifier": "_orderitem.orderItemID",
		 				      "ormtype": "id",
		 				      "isVisible": true,
		 				      "isSearchable": true,
		 				      "title": "Order Item ID"
		 				    },
			 				 {
			 				      "title": "Order Item Type",
			 				      "propertyIdentifier": "_orderitem.orderItemType",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
			 				 {
			 				      "title": "Order Item Price",
			 				      "propertyIdentifier": "_orderitem.price",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
		 				    {
		 				      "title": "Sku Name",
		 				      "propertyIdentifier": "_orderitem.sku.skuName",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				   {
			 				      "title": "Sku Price",
			 				      "propertyIdentifier": "_orderitem.skuPrice",
			 				      "isVisible": true,
			 				      "isDeletable": true
		 				   },
			 				   {
				 				      "title": "Sku ID",
				 				      "propertyIdentifier": "_orderitem.sku.skuID",
				 				      "isVisible": true,
				 				      "isDeletable": true
				 			},
		 				      {
		 				      "title": "SKU Code",
		 				      "propertyIdentifier": "_orderitem.sku.skuCode",
		 				      "isSearchable":true,
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				      },
		 				   {
			 				      "title": "Product Bundle Group",
			 				      "propertyIdentifier": "_orderitem.productBundleGroup.productBundleGroupID",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
			 				{
			 				      "title": "Product ID",
			 				      "propertyIdentifier": "_orderitem.sku.product.productID",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
			 				{
			 				      "title": "Product Name",
			 				      "propertyIdentifier": "_orderitem.sku.product.productName",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
			 				{
			 				      "title": "Product Type",
			 				      "propertyIdentifier": "_orderitem.sku.product.productType",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
			 				{
			 				      "title": "Product Description",
			 				      "propertyIdentifier": "_orderitem.sku.product.productDescription",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				},
		 				    {
		 				      "title": "Qty.",
		 				      "propertyIdentifier": "_orderitem.quantity",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				      },
		 				      	{
			 				      "title": "Fulfillment Method Name",
			 				      "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
			 				      "isVisible": true,
			 				      "isDeletable": true
			 				    },
			 					{
				 				      "title": "Fulfillment ID",
				 				      "propertyIdentifier": "_orderitem.orderFulfillment.orderFulfillmentID",
				 				      "isVisible": true,
				 				      "isDeletable": true
				 				    },
			 				   {
				 				    "title": "Fulfillment Method Type",
				 				    "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
				 				    "isVisible": true,
				 				    "isDeletable": true
			 				   },
		 				    {
		 				      "title": "Street Address",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.streetAddress",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
		 				      "title": "Street Address 2",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.street2Address",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
		 				      "title": "Postal Code",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.postalCode",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
		 				      "title": "City",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.city",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
		 				      "title": "State",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.stateCode",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
		 				      "title": "Country",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.countryCode",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
		 				      "title": "Image File Name",
		 				      "propertyIdentifier": "_orderitem.sku.imageFile",
		 				      "isVisible": true,
		 				      "isDeletable": true
		 				    },
		 				    {
	 					      "title": "Total",
	 					      "propertyIdentifier": "_orderitem.itemTotal",
	 					      "persistent":false
	 					    },
	 					    {
	 					      "title": "Discount Amount",
	 					      "propertyIdentifier": "_orderitem.discountAmount",
	 					      "persistent":false
	 					    }
		 				    
	 				  ];
					
					var filterGroupsConfig =[
					    {
					      "filterGroup": [
					        {
					          "propertyIdentifier": "_orderitem.order.orderID",
					          "comparisonOperator": "=",
					          "value": scope.orderId,
					        },
					        {
					        	"logicalOperator":"AND",
					          "propertyIdentifier": "_orderitem.parentOrderItem",
					          "comparisonOperator": "is",
					          "value": "null",
					        }
					      ]
					    }
					  ];
					
					var options = {
						columnsConfig:angular.toJson(columnsConfig),
						filterGroupsConfig:angular.toJson(filterGroupsConfig),
						currentPage:scope.currentPage,
						pageShow:scope.pageShow,
						keywords:scope.keywords
					};
					//Create a list of order items.
					//scope.orderItems = [];
					scope.orderAttributes = [];
					scope.attributeValues = [];
					console.log('getorderitem');
					console.log(scope.currentPage);
					var orderItemsPromise = $slatwall.getEntity('orderItem', options);
					orderItemsPromise.then(function(value){
						scope.collection = value;
						scope.orderItems = orderItemService.decorateOrderItems(value.pageRecords);
						scope.loadingCollection = false;
						//scope.orderItems = value.records;
						console.log('order items');
						console.log(scope.orderItems);
					});
				}
				scope.getCollection();
				
			}//<--End link
		};
	}
]);
	
