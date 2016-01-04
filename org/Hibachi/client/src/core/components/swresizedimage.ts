/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWResizedImage{
	public static Factory(){
		var directive = (
			$http, $log, $q, $slatwall, corePartialsPath,
			pathBuilderConfig
		)=>new SWResizedImage(
			$http, $log, $q, $slatwall, corePartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'$http', '$log', '$q', '$slatwall', 'corePartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}
	constructor(
		$http, $log, $q, $slatwall, corePartialsPath,
			pathBuilderConfig
	){
		return {
			restrict: 'E',
			scope:{
				orderItem:"=",
			},
			templateUrl: pathBuilderConfig.buildPartialsPath(corePartialsPath) + "orderitem-image.html",
			link: function(scope, element, attrs){
				var profileName = attrs.profilename;
				var skuID = scope.orderItem.data.sku.data.skuID;
				//Get the template.
				//Call slatwallService to get the path from the image.
				$slatwall.getResizedImageByProfileName(profileName, skuID)
                .then(function (response) {
					$log.debug('Get the image');
					$log.debug(response.data.resizedImagePaths[0]);
					scope.orderItem.imagePath = response.data.resizedImagePaths[0];
				});
			}
		};
	}
}
export{
	SWResizedImage
}

