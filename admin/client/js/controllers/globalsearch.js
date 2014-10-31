'use strict';
angular.module('slatwalladmin').controller('globalSearch', [
	'$scope',
	'$log',
	'$window',
	'$timeout',
	'$slatwall',
function(
	$scope,
	$log,
	$window,
	$timeout,
	$slatwall
){
	$scope.keywords = '';
	$scope.searchResultsOpen = false;
	$scope.sidebarClass = 'sidebar';
	$scope.loading = false; //Set loading wheel to false

	$scope.searchResults = {
		'product' : {
			'title': $.slatwall.rbKey('entity.product_plural'),
			'resultNameFilter': function(data) {
				return data['productName'];
			},
			'results' : [],
			'id' : function(data) {
				return data['productID'];
			}
		},
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


	var timeoutPromise;

	$scope.updateSearchResults = function() {
		$scope.resultsFound = true;
		$scope.loading = true;
		if(timeoutPromise) {
			$timeout.cancel(timeoutPromise);
		}

		timeoutPromise = $timeout(function(){
			for (var entityName in $scope.searchResults){
				
				(function(entityName) {

					var searchPromise = $slatwall.getEntity(entityName, {keywords : $scope.keywords} );

					searchPromise.then(function(data){

						if($scope.keywords === ''){
							// clear out the results
							$scope.searchResults[ entityName ].results = [];
							$scope.hideResults();
						}else {
							// clear out the results
							$scope.searchResults[ entityName ].results = [];

							// push in the new results
							for(var i in data.pageRecords) {
								$scope.searchResults[ entityName ].results.push({
									'name': $scope.searchResults[ entityName ].resultNameFilter( data.pageRecords[i] ),
									'link': '?slatAction=entity.detail'+entityName+'&'+entityName+'ID='+$scope.searchResults[ entityName ].id(data.pageRecords[i]),
								});
							}
							if($scope.searchResults[ entityName ].results.length){
								$scope.resultsFound = true;
								$scope.loading = false;
							} else {
								$scope.resultsFound = false;
							}
							
							//Remove loading wheel
							$scope.loading = false;
						}
					});

				})(entityName);
				
			}

		}, 500);
	
		$scope.showResults();
	};


	$scope.showResults = function() {
		$scope.searchResultsOpen = true;
		$scope.sidebarClass = 'sidebar s-search-width';
		$window.onclick = function(event){
			var _targetClassOfSearch = event.target.parentElement.offsetParent.classList.contains('sidebar');
			if(!_targetClassOfSearch){
				$scope.hideResults();
				$scope.$apply();
			}
		};
	};

	$scope.hideResults = function() {
		$scope.searchResultsOpen = false;
		$scope.sidebarClass = 'sidebar';
		$scope.search.$setPristine();
		$scope.keywords = "";
		$window.onclick = null;
	};

}]);
