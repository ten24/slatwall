var slatwall = angular.module('slatwall', []).config(function($httpProvider){
	$httpProvider.defaults.headers.common['X-Hibachi-AJAX'] = true;
});

