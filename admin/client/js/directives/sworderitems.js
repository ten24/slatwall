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
				scope.orderAttributes = [];
				scope.attributeValues = [];
				var orderItemsPromise = $slatwall.getEntity('orderItem', options);
				orderItemsPromise.then(function(value){
					angular.forEach(value.records, function(orderItemData, key){
						
						//---Create the orderItem object.---------------------->
						var orderItem = $slatwall.newOrderItem();
						orderItem.$$init(orderItemData);
						scope.orderItems.push(orderItem);
						//---------------------------------------------------------->
						
						//Set the product type and basic product information.
						orderItem.product = {
							productID: orderItemData.productID,
							productName: orderItemData.productName,
							productType: orderItemData.productType
						};
						
						//---------------------->
						//Figure out the total.
						orderItem.total = 0;
						orderItem.total = parseFloat(orderItemData.price) * parseFloat(orderItemData.quantity);
						//---------------------->													
						//Order Sku---------->
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
						
						//------------------------------------------Custom Attributes
						orderItem.customAttribute = {
								id:"",
								name:"",
								type:""
						};	
						orderItem.customAttributes = [];
						orderItem.customAttributeTypes = []
						//------------------------->
						var attPropertiesPromise = orderItem.$$getPropertyByName("attributeValues");
						attPropertiesPromise.then(function(value){
						//console.info("Attribute Values\n\n\n");
						//console.info(value);
						for (var i = 0; i <= value.records.length-1; i++) {
						    var obj = value.records[i];
						    orderItem.customAttributes.push(obj);
						}
						
						//Now get the names for those values.
						for (var i = 0; i<=orderItem.customAttributes.length  -1; i++){
							var cKey = orderItem.customAttributes[i].attributeID; 
							var cVal = orderItem.customAttributes[i].attributeValue;
							var attContainer = {};
							var namePromise = $slatwall.getEntity("attribute", {id: cKey});
								  namePromise.then(function(v){
								
								orderItem.customAttributeTypes.push(v.attributeID);
								orderItem.customAttributeTypes.push(v.attributeName);
								//console.log(orderItem.customAttributeTypes);
								for (var n = 0; n<= orderItem.customAttributeTypes.length -1; n++){
								if (v.attributeID == cKey){
									//console.log("Found: " + v.attributeID + " ckey: " + v.attributeName + " val: " + cVal);
									attContainer.id = v.attributeID;
									attContainer.key = v.attributeName;
									attContainer.val = cVal;
									}
								}
								
							});
							scope.customAttributes = attContainer;
							orderItem.customAttributes = attContainer;
							
						}//<--end for
						
						})
						
					});
					
				});
				
			}//<--End link
		};
	}
]);
	
