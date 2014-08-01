angular.module('slatwalladmin', ['slatwalladmin.services',,function($locationProvider){
	$locationProvider.html5Mode(true);
}]);

angular.module('slatwall',['slatwalladmin']);
