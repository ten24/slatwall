angular.module('slatwalladmin')
.directive('swOrderItems', [
'$log',
'$location',
'$slatwall',
'formService',
'orderItemService',
'partialsPath',

	function(
	$log,
	$location,
	$slatwall,
	formService,
	orderItemService,
	partialsPath
	){
		return {
			restrict: 'E',
			scope:{
				orderId:"@"
			},
			templateUrl:partialsPath+"orderitemrows.html",
			
			link: function(scope, element, attrs){
				$log.debug('Init Order Item');
				$log.debug(scope.orderId);	
				scope.customAttributeNames = [];
				
				//Setup the data needed for each order item object.
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
	 				allRecords:true
	 				//,transformResponse:orderItemService.decorateOrderItems
				};
				//Create a list of order items.
				//scope.orderItems = [];
				scope.orderAttributes = [];
				scope.attributeValues = [];
				var orderItemsPromise = $slatwall.getEntity('orderItem', options);
				orderItemsPromise.then(function(value){
					scope.orderItems = orderItemService.decorateOrderItems(value.records);
					//scope.orderItems = value.records;
					console.log('order items');
					console.log(scope.orderItems);
				});
				
				
			}//<--End link
		};
	}
]);
	
