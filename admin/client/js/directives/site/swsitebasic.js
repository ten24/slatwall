angular.module('slatwalladmin')
.directive('swSiteBasic', [
'$log',
'$location',
'$slatwall',
'formService',
'sitePartialsPath',
	function(
	$log,
	$location,
	$slatwall,
	formService,
	sitePartialsPath
	){
		return {
			restrict: 'A',
			scope:{
				site:"="
			},
			templateUrl:sitePartialsPath+"sitebasic.html",
			link: function(scope, element,attrs){
			}
		};
	}
]);
	
