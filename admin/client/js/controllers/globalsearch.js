'use strict';
angular.module('slatwalladmin').controller('globalSearch', [
	'$scope',
	'$slatwall',
	'$log',
function(
	$scope,
	$slatwall,
	$log
){
	$scope.keywords = '';
	$scope.searchResultsOpen = false;
	$scope.sidebarClass = 'sidebar';
	
	$scope.searchResults = {
		'brand' : {
			'title': $.slatwall.rbKey('entity.brand_plural'),
			'resultNameFilter': function(data) {
				return data['brandName'];
			},
			'results' : [],
			'id' : function(data) {
				return data['brandID'];
			}
		},
		'account' : {
			'title': $.slatwall.rbKey('entity.account_plural'),
			'resultNameFilter': function(data) {
				return data['firstName'] + ' ' + data['lastName'];
			},
			'results' : [],
			'id' : function(data) {
				return data['accountID'];
			}
		},
		'vendor' : {
			'title': $.slatwall.rbKey('entity.vendor_plural'),
			'resultNameFilter': function(data) {
				return data['vendorName'];
			},
			'results' : [],
			'id' : function(data) {
				return data['vendorID'];
			}
		}
	};
	
	$scope.updateSearchResults = function() {
		
		for (var entityName in $scope.searchResults){
			
			(function(entityName) {
				
				var searchPromise = $slatwall.getEntity(entityName, undefined, 1, 10, $scope.keywords );
				searchPromise.then(function(data){
					
					// clear out the results
					$scope.searchResults[ entityName ].results = [];
					
					// push in the new results
					for(var i in data.pageRecords) {
						$scope.searchResults[ entityName ].results.push({
							'name': $scope.searchResults[ entityName ].resultNameFilter( data.pageRecords[i] ),
							'link': '?slatAction=entity.detail'+entityName+'&'+entityName+'ID='+$scope.searchResults[ entityName ].id(data.pageRecords[i]),
						});	
					}
					$log.debug($scope.searchResults[entityName].results)
				});
				
			})(entityName);
			
		}

	};
	
	$scope.showResults = function() {
		$scope.searchResultsOpen = true;
		$scope.sidebarClass = 'sidebar s-search-width';
		
	};
	
	$scope.hideResults = function() {
		$scope.searchResultsOpen = false;
		$scope.sidebarClass = 'sidebar';
	};
	
}]);