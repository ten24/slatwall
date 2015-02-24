'use strict';
angular.module('slatwalladmin').directive('swChildOrderItem',

[ '$log',
  '$http',
  '$compile',
  '$templateCache',
  '$slatwall',
  'orderItemService',
  'partialsPath', 
  function(
	  $log,
	  $http,
	  $compile,
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
			childOrderItems:"=",
			attributes:"="
		},
		templateUrl:partialsPath+"childorderitem.html",
		link:function(scope, element, attr) {

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
			//hide the children on click
			scope.hideChildren = function(orderItem){
				
				//Set all child order items to clicked = false.
				angular.forEach(scope.childOrderItems, function(child){
					console.log("hideing");
					console.dir(child);
					child.hide = !child.hide;
					scope.orderItem.clicked = !scope.orderItem.clicked;
				});
			}
			scope.getChildOrderItems = function(orderItem){
				orderItem.clicked = true;
				if(!scope.orderItem.childItemsRetrieved){
					scope.orderItem.childItemsRetrieved = true;
					var orderItemsPromise = $slatwall.getEntity('orderItem', options);
					orderItemsPromise.then(function(value){
						
						var childOrderItems = orderItemService.decorateOrderItems(value.records);
						angular.forEach(childOrderItems,function(childOrderItem){
							childOrderItem.hide = false;
							childOrderItem.depth = orderItem.depth+1;
							scope.childOrderItems.splice(scope.childOrderItems.indexOf(orderItem)+1,0,childOrderItem);
						});
						
					});
				}
				
			}

					
					
					/*var unbindchildorderitems = scope.$watch('orderItem.data.childOrderItems',function(newValue,oldValue){
				if(newValue !== oldValue){
					console.log('found child order items');
					//when we load the child order items then append the child template
					var Partial = partialsPath+"childorderitem.html";
					var templateLoader = $http.get(Partial,{cache:$templateCache});
					var promise = templateLoader.success(function(html){
						element.append($compile(html)(scope));
						
					}).then(function(response){
						//scope.childOrderItems = newValue
						//element.replaceWith($compile(element.html())(scope));
					});
					console.log(element);
				}
			});*/
		}
	};
} ]);