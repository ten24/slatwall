angular.module('slatwalladmin')
.directive('swFilterGroupItem',['$http','$compile','$templateCache','collectionService',function($http,$compile,$templateCache,collectionService){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			siblingItems:"=",
			incrementFilterCount:"&",
			setItemInUse:"&" 
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/filterGroupItem.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			//for(item in filterGroupItem){}
			$scope.filterGroupItem.setItemInUse = $scope.setItemInUse;
			
			$scope.filterGroupItem.disabled = false;
			if(typeof($scope.filterGroupItem.isClosed) === 'undefined'){
				$scope.filterGroupItem.isClosed = true;
			}
			
			$scope.filterGroupItem.siblingItems = $scope.siblingItems;
			$scope.selectFilterGroupItem = function(filterGroupItem){
				collectionService.selectFilterGroupItem(filterGroupItem);
			}
        }  
	}
}]);
	
	
