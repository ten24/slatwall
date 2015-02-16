/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
angular.module('slatwalladmin')
.directive('swoishippinglabelstamp', 
[
'partialsPath',
	function(partialsPath){
		return {
			restrict: 'E',
			scope:{
				orderFulfillment:"="
			},
			templateUrl:partialsPath+"orderfulfillment-shippinglabel.html",
			link: function(scope, element, attrs){
				//Get the template.
				
			}
		};
	}
]);