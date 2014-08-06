angular.module('slatwalladmin', ['slatwalladmin.services',function($locationProvider){
	$locationProvider.html5Mode(true);
}]).run(function($rootScope) {
	//adding alerts to the root Scope
    $rootScope.alerts = [
    { type: 'error', msg: 'Oh snap! Change a few things up and try submitting again.' }, 
    { type: 'success', msg: 'Well done! You successfully read this important alert message.' }
  ];
});

angular.module('slatwall',['slatwalladmin']);
