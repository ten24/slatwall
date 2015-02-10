/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
'use strict';
angular.module('slatwalladmin')
.directive('swoishippinglabelstamp', 
[
	function(){
		var getTemplate = function(orderItem){
			//Need to include other fulfillment methods.
			console.log("Setting Fulfillment Method");
			//This will need to check for the type of fulfillment and not just assume a shipping address (IE returns)
			console.log(orderItem);
			var addressStamp = "";
			console.log("_______Shipping method:");
			console.log(orderItem.data.orderFulfillment.data.fulfillmentMethodType);
			if (orderItem.data.orderFulfillment.data.fulfillmentMethodType === "shipping"){
				console.log("_______\n\n\n");
				//Set defaults.
				var sa1 = orderItem.data.orderFulfillment.data.shippingAddress.data.streetAddress || " ";
				var sa2 = orderItem.data.orderFulfillment.data.shippingAddress.data.street2Address || " ";
				var city = orderItem.data.orderFulfillment.data.shippingAddress.data.city || " ";
				var state = orderItem.data.orderFulfillment.data.shippingAddress.data.stateCode || " ";
				var postal = orderItem.data.orderFulfillment.data.shippingAddress.data.postalCode || " ";
				console.log(city);
				//Build the stamp.
				addressStamp = "<ul><li>" + sa1 + "</li>" +
				"<li>" + sa2 + "</li>" +
				"<li>" + city + "&nbsp" 
						  + state + "&nbsp<br>" 
						  + postal + "</li></ul>";
				
			}else{
				addressStamp = "<ul><li>N/A</li></ul>";
			}
			
			return addressStamp; 
		}
		return {
			restrict: 'E',
			transclude:true,
			scope:{
				orderItem:"="
			},
			replace:true,
			link: function(scope, element, attrs){
				//Get the template.
				element.html(getTemplate(scope.orderItem));
			}
		};
	}
]);