angular.module('slatwalladmin')
.directive('swAdminCreateSuperUser', [
'$log',
'$slatwall',
'partialsPath',
	function(
	$log,
	$slatwall,
	partialsPath
	){
		return {
			restrict: 'E',
			scope:{
			},
			templateUrl:partialsPath+"admincreatesuperuser.html",
			link: function(scope, element,attrs){
			}
		};
	}
]);
	
