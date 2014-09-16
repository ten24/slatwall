'use strict';
angular.module('slatwalladmin', ['slatwalladmin.services','ui.bootstrap', 'ngAnimate', function($locationProvider){
	$locationProvider.html5Mode(true);
}]).config(["$provide",'$logProvider','$filterProvider', function ($provide, $logProvider,$filterProvider) {
	$provide.constant("partialsPath", '/admin/client/js/directives/partials/');
	// TODO: configure log provider on/off based on server side rules? 
	var debugEnabled = true;
	$logProvider.debugEnabled(debugEnabled);
	
	$filterProvider.register('likeFilter',function(){
		return function(text){
			
			if(angular.isDefined(text)){
				return text.replace(new RegExp('%', 'g'), '');
			}
		};
	});
}]).run(['$rootScope','dialogService', function($rootScope, dialogService) {
	//adding alerts to the root Scope
    $rootScope.alerts = [];
    $rootScope.openPageDialog = function( partial ) {
    	dialogService.addCreatePageDialog( partial );
    }
}]);


angular.module('slatwall',['slatwalladmin']);
