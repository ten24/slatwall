'use strict';
angular.module('slatwalladmin')
.factory('orderItemService',
[
	'$log',
	'$slatwall',
	function(
		$log,
		$slatwall
	){
		
		var orderItemService = {
			decorateOrderItems:function(orderItemsData){
				var orderItems = [];
				angular.forEach(orderItemsData, function(orderItemData, key){
					
					//---Create the orderItem object.---------------------->
					var orderItem = $slatwall.newOrderItem();
					orderItem.$$init(orderItemData);
					orderItems.push(orderItem);
					//---------------------------------------------------------->
					
					//Set the product type and basic product information.
					orderItem.product = {
						productID: orderItemData.productID,
						productName: orderItemData.productName,
						productType: orderItemData.productType
					};												
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
					
					//---------------------->
					//Get the applied promotions and iterate through them getting the discount amount on each and adding them up.
					$log.debug("------>PROMOTIONS DISCOUNTS<------");
					orderItem.discount = 0;
					orderItem.total = 0;
//					var discountFromPromotionsPromise = orderItem.$$getAppliedPromotions();
//					discountFromPromotionsPromise.then(function(discount){
//						angular.forEach(discount.records, function(discountData, key){
//							$log.debug(discountData.discountAmount);
//							orderItem.discount += parseFloat(discountData.discountAmount);
//							//----------------------Calculates the total for the orderitem>
//							//Figure out the total. (still need to subtract the discount amount)
//							orderItem.total = ((parseFloat(orderItemData.price) * parseFloat(orderItemData.quantity)) - parseFloat(orderItem.discount));
//							//---------------------------------------------------------------->	
//						});
//					});
					
					//--------------------->Lets get the order fulfillment information.
					var orderFulfillmentInformation = orderItem;
					console.log(orderItem);
					
					//------------------------------------------Custom Attributes
					orderItem.customAttribute = {
							id:"",
							name:"",
							type:""
					};	
					orderItem.customAttributes = [];
					orderItem.customAttributeTypes = []
					//------------------------->
//					var attPropertiesPromise = orderItem.$$getPropertyByName("attributeValues");
//					attPropertiesPromise.then(function(value){
//						//console.info("Attribute Values\n\n\n");
//						//console.info(value);
//						for (var i = 0; i <= value.records.length-1; i++) {
//						    var obj = value.records[i];
//						    orderItem.customAttributes.push(obj);
//						}
//						
//						//Now get the names for those values.
//	//					for (var i = 0; i<=orderItem.customAttributes.length  -1; i++){
//	//						var cKey = orderItem.customAttributes[i].attributeID; 
//	//						var cVal = orderItem.customAttributes[i].attributeValue;
//	//						var attContainer = {};
//	//						var namePromise = $slatwall.getEntity("attribute", {id: cKey});
//	//							  namePromise.then(function(v){
//	//							
//	//							orderItem.customAttributeTypes.push(v.attributeID);
//	//							orderItem.customAttributeTypes.push(v.attributeName);
//	//							//console.log(orderItem.customAttributeTypes);
//	//							for (var n = 0; n<= orderItem.customAttributeTypes.length -1; n++){
//	//							if (v.attributeID == cKey){
//	//								//console.log("Found: " + v.attributeID + " ckey: " + v.attributeName + " val: " + cVal);
//	//								attContainer.id = v.attributeID;
//	//								attContainer.key = v.attributeName;
//	//								attContainer.val = cVal;
//	//								}
//	//							}
//	//							
//	//						});
//	//						scope.customAttributes = attContainer;
//	//						orderItem.customAttributes = attContainer;
//	//						
//	//					}//<--end for
//					
//					});
					
				});
				return orderItems;
			}
			
		};
		
		return orderItemService;
	}
]);
