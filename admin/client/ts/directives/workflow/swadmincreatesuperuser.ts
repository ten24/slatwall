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
                scope.Account_SetupInitialAdmin = $slatwall.newAccount_SetupInitialAdmin();
                console.log('account added');
                console.log( scope.Account_SetupInitialAdmin);
			} 
		};
	}
]);
	
