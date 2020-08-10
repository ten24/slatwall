/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWResizedImage{
	public static Factory(){
		var directive = (
			$http, $log, $q, $hibachi, orderItemPartialsPath,
			slatwallPathBuilder
		)=>new SWResizedImage(
			$http, $log, $q, $hibachi, orderItemPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
			'$http', '$log', '$q', '$hibachi', 'orderItemPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
	constructor(
		$http, $log, $q, $hibachi, orderItemPartialsPath,
			slatwallPathBuilder
	){
		return {
			restrict: 'E',
			scope:{
				orderItem:"=",
			},
			templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "orderitem-image.html",
			link: function(scope, element, attrs){
				var profileName = attrs.profilename;
				var skuID = scope.orderItem.data.sku.data.skuID;
				//Get the template.
				//Call slatwallService to get the path from the image.
				$hibachi.getResizedImageByProfileName(profileName, skuID)
                .then(function (response) {
					
                    
					$log.debug(response.resizedImagePaths[0]);
					scope.orderItem.imagePath = response.resizedImagePaths[0];
				});
			}
		};
	}
}
export{
	SWResizedImage
}

