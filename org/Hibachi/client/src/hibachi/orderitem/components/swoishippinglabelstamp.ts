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
			pathBuilderConfig
		) => new SWOiShippingLabelStamp(
			$log,
			orderItemPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$log',
			'orderItemPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$log,
		orderItemPartialsPath,
		pathBuilderConfig
	){
		return {
			restrict: 'E',
			scope:{
				orderFulfillment:"="
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(orderItemPartialsPath)+"orderfulfillment-shippinglabel.html",
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