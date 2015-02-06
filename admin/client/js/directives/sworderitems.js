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
			templateUrl:partialsPath+"orderitems.html",
			link: function(scope, element, attrs){
				$log.debug('Init order item')
				$log.debug(scope.orderId);
				
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
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
	 				    },
	 				    {
	 				      "title": "Image File Name",
	 				      "propertyIdentifier": "_orderitem.sku.imageFile",
	 				      "isVisible": true,
	 				      "isDeletable": true,
	 				      "sorting": {
	 				        "active": false,
	 				        "sortOrder": "asc",
	 				        "priority": 0
	 				      }
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
					$log.debug("value");
					$log.debug(value);
					var order = $slatwall.getOrder({ id: scope.orderId });//$$
					console.log("_____order");
					console.log(order);
										
					angular.forEach(value.records, function(orderItemData, key){
						console.log("____OID____");
						console.log(orderItemData); console.log(key);
						//Set up the order item that we will add the other properties to.
						var orderItem = $slatwall.newOrderItem();
						orderItem.$$init(orderItemData);
						//Order Sku
						var sku = $slatwall.newSku();
						sku.$$init(orderItemData);
						orderItem.$$setSku(sku);
						console.log("Sku Children");
						
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
						
						
					});
					
				});
						
			}
		};
	}
]);
	
