/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
class SWOrderItemDetailStamp{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			collectionConfigService,
			orderItemPartialsPath,
			slatwallPathBuilder
		) => new SWOrderItemDetailStamp(
			$log,
			$hibachi,
			collectionConfigService,
			orderItemPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'collectionConfigService',
			'orderItemPartialsPath',
			'slatwallPathBuilder'
		]
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		collectionConfigService,
		orderItemPartialsPath,
		slatwallPathBuilder
	){
		return {
			restrict: 'A',
			scope:{
				systemCode:"=",
				orderItemId:"=",
				skuId:"=",
				orderItem:"="
			},
			templateUrl:slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath)+"orderitem-detaillabel.html",
			link: function(scope, element, attrs){
				scope.details = [];
				scope.orderItem.detailsName = [];
				var results;
				$log.debug("Detail stamp");
				$log.debug(scope.systemCode);
				$log.debug(scope.orderItemId);
				$log.debug(scope.skuId);
				$log.debug(scope.orderItem);

				/**
				 * For each type of orderItem, get the appropriate detail information.
				 *
				 * Merchandise: Option Group Name and Option
				 * Event: Event Date, Event Location
				 * Subscription: Subscription Term, Subscription Benefits
				 */
				var getMerchandiseDetails = function(orderItem){
					//Get option and option groups
					for (var i = 0; i <=  orderItem.data.sku.data.options.length - 1; i++){
						var optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("Option");
						optionGroupCollectionConfig.addDisplayProperty("optionID,optionName, optionGroup.optionGroupName");
						optionGroupCollectionConfig.addFilter("optionID", orderItem.data.sku.data.options[i].optionID, "=");
						optionGroupCollectionConfig.getEntity().then(
							(results)=>{
								if(angular.isDefined(results.pageRecords[0])){
									orderItem.detailsName.push(results.pageRecords[0].optionGroup_optionGroupName);
									orderItem.details.push(results.pageRecords[0].optionName);
								}
							},
							(reason)=>{
								throw("SWOrderItemDetailStamp had trouble retrieving the option group for option");
							}
						);
					}

				};

				var getSubscriptionDetails = function(orderItem){

					//get Subscription Term and Subscription Benefits
					var name = orderItem.data.sku.data.subscriptionTerm.data.subscriptionTermName || "";
					orderItem.detailsName.push("Subscription Term:");
					orderItem.details.push(name);

					//Maybe multiple benefits so show them all.
					for (var i = 0; i <=  orderItem.data.sku.data.subscriptionBenefits.length - 1; i++){
						var benefitName = orderItem.data.sku.data.subscriptionBenefits[i].subscriptionBenefitName || "";
						orderItem.detailsName.push("Subscription Benefit:");
						orderItem.details.push(benefitName);
					}

				};

				var getEventDetails = function(orderItem){
					//get event date, and event location
					orderItem.detailsName.push("Event Date: ");
					orderItem.details.push(orderItem.data.sku.data.eventStartDateTime);
					//Need to iterate this.
					for (var i = 0; i <= orderItem.data.sku.data.locations.length - 1; i++ ){
						orderItem.detailsName.push("Location: ");
						orderItem.details.push(orderItem.data.sku.data.locations[i].locationName);
					}

				};
				if (angular.isUndefined(scope.orderItem.details)){
					scope.orderItem.details = [];
				}
				if (angular.isDefined(scope.orderItem.details)){
					
					switch (scope.systemCode){
						case "merchandise":
							getMerchandiseDetails(scope.orderItem);
							break;
						case "subscription":
							getSubscriptionDetails(scope.orderItem);
							break;
						case "event":
							getEventDetails(scope.orderItem);
							break;
					}
				}
			}
		};
	}
}
export{
	SWOrderItemDetailStamp
}