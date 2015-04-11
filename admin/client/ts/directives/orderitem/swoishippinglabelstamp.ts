/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
angular.module('slatwalladmin')
.directive('swoishippinglabelstamp', 
[
'partialsPath',
'$log',
	function(partialsPath, $log){
		return {
			restrict: 'E',
			scope:{
				orderFulfillment:"="
			},
			templateUrl:partialsPath+"orderfulfillment-shippinglabel.html",
			link: function(scope, element, attrs){
				//Get the template.
				$log.debug("\n\n<---ORDER FULFILLMENT STAMP--->\n\n");
				$log.debug(scope.orderFulfillment);
				$log.debug(scope.orderFulfillment.data.fulfillmentMethodType);
			}
		};
	}
]);