angular.module('slatwalladmin')
.directive('swOrderItems', [
'$log',
'$location',
'$slatwall',
'formService',
'partialsPath',

	function(
	$log,
	$location,
	$slatwall,
	formService,
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
	 				      "title": "Order Item ID",
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
		 				 {
		 				      "title": "Order Item Type",
		 				      "propertyIdentifier": "_orderitem.orderItemType",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
		 				 {
		 				      "title": "Order Item Price",
		 				      "propertyIdentifier": "_orderitem.price",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
	 				    {
	 				      "title": "Sku Name",
	 				      "propertyIdentifier": "_orderitem.sku.skuName",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				   {
		 				      "title": "Sku Price",
		 				      "propertyIdentifier": "_orderitem.skuPrice",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				    },
	 				      {
	 				      "title": "SKU Code",
	 				      "propertyIdentifier": "_orderitem.sku.skuCode",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				      },
	 				   {
		 				      "title": "Product Bundle Group",
		 				      "propertyIdentifier": "_orderitem.productBundleGroup.productBundleGroupID",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
		 				{
		 				      "title": "Product ID",
		 				      "propertyIdentifier": "_orderitem.sku.product.productID",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
		 				{
		 				      "title": "Product Name",
		 				      "propertyIdentifier": "_orderitem.sku.product.productName",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
		 				{
		 				      "title": "Product Type",
		 				      "propertyIdentifier": "_orderitem.sku.product.productType",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
		 				{
		 				      "title": "Product Description",
		 				      "propertyIdentifier": "_orderitem.sku.product.productDescription",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				},
	 				    {
	 				      "title": "Qty.",
	 				      "propertyIdentifier": "_orderitem.quantity",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				   {
		 				      "title": "Fulfillment Method Name",
		 				      "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
		 				      "isVisible": true,
		 				      "isDeletable": true,
		 				      "sorting": {
		 				        "active": false,
		 				        "sortOrder": "asc",
		 				        "priority": 0
		 				      }
		 				    },
		 				   {
			 				      "title": "Fulfillment Method Type",
			 				      "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
			 				      "isVisible": true,
			 				      "isDeletable": true,
			 				      "sorting": {
			 				        "active": false,
			 				        "sortOrder": "asc",
			 				        "priority": 0
			 				      }
		 				   },
	 				    {
	 				      "title": "Street Address",
	 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.streetAddress",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				    {
	 				      "title": "Street Address 2",
	 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.street2Address",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				    {
	 				      "title": "Postal Code",
	 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.postalCode",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				    {
	 				      "title": "City",
	 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.city",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				    {
	 				      "title": "State",
	 				      "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.stateCode",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
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
				scope.orderItems = [];
				var orderItemsPromise = $slatwall.getEntity('orderItem', options);
				orderItemsPromise.then(function(value){
					
					var order = $slatwall.getOrder({ id: scope.orderId });
					
					angular.forEach(value.records, function(orderItemData, key){
						console.log("____Order Item Data____\n\n\n\n\n\n\n");
						console.log(key);
						console.log(orderItemData); 
						
						//Create the orderItem object.
						var orderItem = $slatwall.newOrderItem();
						orderItem.$$init(orderItemData);
						//-----------------------------------------
						//Set the product type and basic product information.
						orderItem.product = {
							productID: orderItemData.productID,
							productName: orderItemData.productName,
							productType: orderItemData.productType
						};
						//----------------------
						//Figure out the total.
						orderItem.total = 0;
						orderItem.total = parseFloat(orderItemData.price) * parseFloat(orderItemData.quantity);
						//----------------------
						//Check if the product type is content, event, Merchandise, or subscription.
						//
						
						
						//THIS NEEDS TO BE CHANGED!
				        //-----------------------------------------
						var attValueID = [];
						console.log("______________________Get Custom Attributes\n\n")
						var atrColumnsConfig =[
									         {  "isDeletable":true,
									        	    "isExportable":true,
									        	 	"propertyIdentifier":"_attributevalue.attributeValue",
									        	 	"ormtype":"string",
									        	 	"isVisible":true,
									        	 	"isSearchable":true,
									        	 	"title":"attributeValue"
									         }];
						
						var atrFilterGroupsConfig =[
						     				    {
						     				      "filterGroup": [
						     				        {
						     				        	"propertyIdentifier":"_attributevalue.orderItem.orderItemID",
						     				        "comparisonOperator": "=",
						     				        "value": orderItemData.orderItemID,
						     				        }
						     				      ]
						     				    }
						     				  ];
						var atrOptions = {
								columnsConfig:angular.toJson(atrColumnsConfig),
								filterGroupsConfig:angular.toJson(atrFilterGroupsConfig),
				 				allRecords:true
							};
						var aIDPromise = $slatwall.getEntity("AttributeValue", atrOptions);
						aIDPromise.then(function(value){
							orderItem.attributeValues = [];
							angular.forEach(value.records, function(attributeData, key){
								console.log("Adding Custom Attribute Values");
								console.log(attributeData);
								orderItem.attributeValues.push(attributeData.attributeValue);
								
							});
						});
						console.log(aIDPromise);
						//------------------------End Custom Attributes
						//------------------------Custom Attributes
						//Check the order item array for this item previously being added.
						//If it was already added, check for new attribute data and add to the old one.
						console.log("----------------------------Custom Attribute Names");
						var atrNameColumnsConfig =[
										         {  "isDeletable":true,
										        	    "isExportable":true,
										        	 	"propertyIdentifier":"_attributeset.attributeSetName",
										        	 	"ormtype":"string",
										        	 	"isVisible":true,
										        	 	"isSearchable":true,
										        	 	"title":"attributeValue"
										         }
										         ];
					    var atrNameFilterGroupsConfig =[
							     				    {
							     				      "filterGroup": [
							     				        {
							     				        	"propertyIdentifier":"_attributeset.attributeSetObject",
							     				          "comparisonOperator": "=",
							     				          "value": "OrderItem"
							     				        }
							     				      ]
							     				    }
							     				  ];
							var atrNameOptions = {
									columnsConfig:angular.toJson(atrNameColumnsConfig),
									filterGroupsConfig:angular.toJson(atrNameFilterGroupsConfig),
					 				allRecords:true
								};
						var aIDNamePromise = $slatwall.getEntity("AttributeSet", atrNameOptions);	
						console.log(aIDNamePromise);
						aIDNamePromise.then(function(value){
							orderItem.customAttributeNames = [];
							angular.forEach(value.records, function(attributeData, key){
								console.log("Adding Custom Attribute Names");
								orderItem.customAttributeNames.push(attributeData);
								//If the name does not exist in scope add it.
								console.log(attributeData.attributeSetName);
								if (scope.customAttributeNames.indexOf(attributeData.attributeSetName) == -1){
								scope.customAttributeNames.push(attributeData.attributeSetName);
								console.log("Pushing: " + attributeData.attributeSetName);
								}
								console.log(scope.customAttributeNames);
							});
						});
						console.log(aIDPromise);
						console.log("______________________End custom names\n\n");
						
						//Order Sku
						var sku = $slatwall.newSku();
						sku.$$init(orderItemData);
						orderItem.$$setSku(sku);
						
						//Order fulfillment
						var orderFulfillment = $slatwall.newOrderFulfillment();
						orderFulfillment.$$init(orderItemData);
						orderItem.$$setOrderFulfillment(orderFulfillment);
						
						//Shipping Address
						var shippingAddress = $slatwall.newAddress();
						shippingAddress.$$init(orderItemData);
						orderFulfillment.$$setShippingAddress(shippingAddress);
						
						
						//Push the order item onto the order items array.
						scope.orderItems.push(orderItem);
						console.log("Finished OI\n\n\n\n\n");
						console.dir(orderItem);
						
					});
					
				});
						
			}
		};
	}
]);
	
