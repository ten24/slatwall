/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
angular.module('slatwalladmin')
.directive('swOrderItemDetailStamp', 
[
'partialsPath',
'$log',
'$slatwall',
	function(partialsPath, $log, $slatwall){
		return {
			restrict: 'A',
			scope:{
				systemCode:"=",
				orderItemId:"=",
				skuId:"=",
				orderItem:"="
			},
			templateUrl:partialsPath+"orderitem-detaillabel.html",
			link: function(scope, element, attrs){
				scope.details = [];
				scope.detailsName = [];
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
						orderItem.details.push(orderItem.data.sku.data.options[i].optionCode);
						orderItem.details.push(orderItem.data.sku.data.options[i].optionName);
					}
					
				}
				
				var getSubscriptionDetails = function(orderItem){
					//get Subscription Term and Subscription Benefits
					var name = orderItem.data.sku.data.subscriptionTerm.data.subscriptionTermName || "";
					orderItem.details.push(name);
					for (var i = 0; i <=  orderItem.data.sku.data.subscriptionBenefits.length - 1; i++){
						var benefitName = orderItem.data.sku.data.subscriptionBenefits[i].subscriptionBenefitName || "";
						orderItem.details.push(benefitName);
					}
					
				}
				
				var getEventDetails = function(orderItem){
					//get event date, and event location
					var lName = orderItem.details.push(orderItem.data.sku.data.locations[0].locationName) || "N/A";
					if (lName != "1"){ 
					orderItem.details.push(lName);
					}
					orderItem.details.push(orderItem.data.sku.data.eventStartDateTime);				
				
				}
				
				switch (scope.systemCode){
				case "merchandise":
					results = getMerchandiseDetails(scope.orderItem);
					break;
				case "subscription":
					results = getSubscriptionDetails(scope.orderItem);
					break;
				case "event":
					results = getEventDetails(scope.orderItem);
					break;	
				}
				scope.orderItem.details.push(results);
			}
		};
	}
]);