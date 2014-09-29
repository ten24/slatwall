'use strict';
angular.module('slatwalladmin').controller('sidebarController', [
	'$scope',
	'$slatwall',
	'$log',
function(
	$scope,
	$slatwall,
	$log
){
	
	$scope.searchResultsOpen = false;
	$scope.sidebarClass = 'sidebar';
	$scope.searchResultSections = [
		{
			'sectionName':'Products',
			'results': [
				{
					'name' : 'Product Name Here',
					'link' : 'http://www.google.com'
				},
				{
					'name' : 'Product Name Here',
					'link' : 'http://www.google.com'
				},
				{
					'name' : 'Product Name Here',
					'link' : 'http://www.google.com'
				}
			]
		},
		{
			'sectionName':'Products Types',
			'results': [
				{
					'name' : 'Product Name Here',
					'link' : 'http://www.google.com'
				}
			]
		}
	];
	
	$scope.showResults = function() {
		$log.debug('showResults function triggered');
		
		$scope.searchResultsOpen = true;
		$scope.sidebarClass = 'sidebar s-search-width';
		
	};
	
	$scope.hideResults = function() {
		$log.debug('hideResults function triggered');
		
		$scope.searchResultsOpen = false;
		$scope.sidebarClass = 'sidebar';
	};
	
}]);