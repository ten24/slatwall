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
					console.log('newOrderItem');
					console.log(orderItem);
					console.log(orderItemData);
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
					console.log('orderfulfillment');
					console.log(orderFulfillment);
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
					var discountFromPromotionsPromise = orderItem.$$getAppliedPromotions();
					discountFromPromotionsPromise.then(function(discount){
						angular.forEach(discount.records, function(discountData, key){
							$log.debug(discountData.discountAmount);
							orderItem.discount += parseFloat(discountData.discountAmount);
							//----------------------Calculates the total for the orderitem>
							orderItem.total = ((parseFloat(orderItemData.price) * parseFloat(orderItemData.quantity)) - parseFloat(orderItem.discount));
							//---------------------------------------------------------------->	
						});
					});
					
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
					
				});
				return orderItems;
			}
			
		};
		
		return orderItemService;
	}
]);
