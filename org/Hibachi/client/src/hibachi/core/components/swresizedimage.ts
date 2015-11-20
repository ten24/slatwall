/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
class SWResizedImage{
	public static Factory(){
		var directive = (
			$http, $log, $q, $slatwall, partialsPath
		)=>new SWResizedImage(
			$http, $log, $q, $slatwall, partialsPath
		);
		directive.$inject = [
			'$http', '$log', '$q', '$slatwall', 'partialsPath'
		];
		return directive;
	}
	constructor(
		$http, $log, $q, $slatwall, partialsPath
	){
		return {
			restrict: 'E',
			scope:{
				orderItem:"=",
			},
			templateUrl: partialsPath + "orderitem-image.html",
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

