'use strict';
angular.module('slatwalladmin').directive('swOrderItem',

[ '$log',
  '$compile',
  '$http',
  '$templateCache',
  '$slatwall',
  'orderItemService',
  'partialsPath', 
  function(
	  $log,
	  $compile,
	  $http,
	  $templateCache,
	  $slatwall,
	  orderItemService,
	  partialsPath
  ) {

	return {
		restrict : "A",
		scope:{
			orderItem:"=",
			orderId:"@",
			attributes:"="
		},
		templateUrl:partialsPath+"orderitem.html",
		link : function(scope, element, attr) {
			$log.debug('order item init');
			$log.debug(scope.orderItem);
			//define how we get child order items
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
			
			//add attributes to the column config
			angular.forEach(scope.attributes,function(attribute){
				var attributeColumn = {
					propertyIdentifier:"_orderItem."+attribute.attributeCode,
					attributeID:attribute.attributeID,
			         attributeSetObject:"orderItem"
				};
				columnsConfig.push(attributeColumn);
			});
		
			var filterGroupsConfig =[
			    {
			      "filterGroup": [
			        {
			          "propertyIdentifier": "_orderitem.parentOrderItem.orderItemID",
			          "comparisonOperator": "=",
			          "value": scope.orderItem.$$getID(),
			        }
			      ]
			    }
			  ];
			
			var options = {
				columnsConfig:angular.toJson(columnsConfig),
				filterGroupsConfig:angular.toJson(filterGroupsConfig),
				allRecords:true
			};
			//Create a list of order items.
			scope.childOrderItems = [];
			scope.orderItem.depth = 1;
			
			//scope.orderItem.childItemsRetrieved = false;
			scope.getChildOrderItems = function(){
				scope.orderItem.clicked = true;
				if(!scope.orderItem.childItemsRetrieved){
					scope.orderItem.childItemsRetrieved = true;
					var orderItemsPromise = $slatwall.getEntity('orderItem', options);
					orderItemsPromise.then(function(value){
						
						var childOrderItems = orderItemService.decorateOrderItems(value.records);
						angular.forEach(childOrderItems,function(childOrderItem){
							childOrderItem.depth = scope.orderItem.depth+1;
							scope.childOrderItems.push(childOrderItem);
						});
					});
				}
			}
			
		}
	};
} ]);