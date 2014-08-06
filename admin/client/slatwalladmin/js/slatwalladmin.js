angular.module('slatwalladmin', ['slatwalladmin.services',function($locationProvider){
	$locationProvider.html5Mode(true);
}]).run(function($rootScope) {
	//adding alerts to the root Scope
    $rootScope.alerts = [];
});

angular.module('slatwall',['slatwalladmin']);
