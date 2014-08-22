angular.module('slatwalladmin', ['slatwalladmin.services','ui.bootstrap',function($locationProvider){
	$locationProvider.html5Mode(true);
}]).config(["$provide",'$logProvider', function ($provide, $logProvider) {
	$provide.constant("partialsPath", '/admin/client/js/directives/partials/');
	// TODO: configure log provider on/off based on server side rules? 
	var debugEnabled = true;
	$logProvider.debugEnabled(debugEnabled);
}]).run(function($rootScope) {
	//adding alerts to the root Scope
    $rootScope.alerts = [];
});


angular.module('slatwall',['slatwalladmin']);
