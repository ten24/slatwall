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
			link: function(scope, element,attrs){
				$log.debug('init order item')
				$log.debug(scope.orderId);
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
				          "displayPropertyIdentifier": "Order ID",
				          "propertyIdentifier": "_orderitem.order.orderID",
				          "comparisonOperator": "=",
				          "breadCrumbs": [
				            {
				              "rbKey": "Order Item",
				              "entityAlias": "_orderitem",
				              "cfc": "_orderitem",
				              "propertyIdentifier": "_orderitem"
				            },
				            {
				              "entityAlias": "order",
				              "cfc": "Order",
				              "propertyIdentifier": "_orderitem.order",
				              "rbKey": "Order"
				            }
				          ],
				          "value": scope.orderId,
				          "ormtype": "string",
				          "fieldtype": "id",
				          "conditionDisplay": "Equals"
				        }
				      ]
				    }
				  ];
				
				var options = {
					columnsConfig:angular.toJson(columnsConfig),
					filterGroupsConfig:angular.toJson(filterGroupsConfig),
	 				allRecords:true
				};
				
				scope.orderItems = [];
				var orderItemsPromise = $slatwall.getEntity('orderItem',options);
				orderItemsPromise.then(function(value){
					angular.forEach(value.records,function(orderItemData,key){
						var orderItem = $slatwall.newOrder();
						orderItem.$$init(orderItemData);
						scope.orderItems.push(orderItem);
					});
					console.log(scope.orderItems);
				});
				
//				var collectionConfig = {
//				  "baseEntityName": "SlatwallOrderItem",
//				  "baseEntityAlias": "_orderitem",
//				  ,
//				  
//				};
				
				
				/*var orderPromise = $slatwall.getOrder({id:scope.orderId});
				orderPromise.promise.then(function(){
					scope.order = orderPromise.value;
					scope.order.$$getOrderItems();
					$log.debug('order');
					$log.debug(scope.order);
				});*/
				/*
				 
				 */
				
			}
		};
	}
]);
	
