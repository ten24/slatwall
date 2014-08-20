angular.module('slatwalladmin', ['slatwalladmin.services','ui.bootstrap',function($locationProvider){
	$locationProvider.html5Mode(true);
}]).config(["$provide", function ($provide) {
	$provide.constant("partialsPath", '/admin/client/js/directives/partials/');
}]).run(function($rootScope) {
	//adding alerts to the root Scope
    $rootScope.alerts = [];
})


angular.module('slatwall',['slatwalladmin']);
