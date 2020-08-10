/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
class SWOiShippingLabelStamp{
	public static Factory(){
		var directive = (
			$log,
			orderItemPartialsPath,
			slatwallPathBuilder
		) => new SWOiShippingLabelStamp(
			$log,
			orderItemPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
			'$log',
			'orderItemPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		orderItemPartialsPath,
		slatwallPathBuilder
	){
		return {
			restrict: 'E',
			scope:{
				orderFulfillment:"="
			},
			templateUrl:slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath)+"orderfulfillment-shippinglabel.html",
			link: function(scope, element, attrs){
				//Get the template.
				$log.debug("\n\n<---ORDER FULFILLMENT STAMP--->\n\n");
				$log.debug(scope.orderFulfillment);
				$log.debug(scope.orderFulfillment.data.fulfillmentMethodType);
			}
		};
	}
}
export{
	SWOiShippingLabelStamp
}