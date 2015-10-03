angular.module('slatwalladmin')
.directive('slatwallAddressForm', [
'$log',
'$templateCache',
'$window',
'$slatwall',
'formService',
'partialsPath',
	function(
	$log,
	$templateCache,
	$window,
	$slatwall,
	formService,
	partialsPath){ 
		return {
			restrict: 'E',
			scope:{
				address:"=",
				ID:"@",
				fieldNamePrefix: "@",
				fieldList:"@",
				fieldClass:"@"
			},
			templateUrl:partialsPath+'/frontend/addressFormPartial.html',
			link: function(scope, element, attrs, formCtrl){
				scope.fieldList 		= attrs.fieldList || "countryCode,name,company,streetAddress,street2Address,locality,city,stateCode,postalCode"
				scope.address   		= attrs.address   || {};
				scope.fieldNamePrefix 	= attrs.fieldNamePrefix || "";
				
				console.log("Scope: ", scope, attrs);
				
			}
		};
	}
]);
	
