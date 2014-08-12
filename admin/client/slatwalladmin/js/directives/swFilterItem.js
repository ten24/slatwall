angular.module('slatwalladmin')
.directive('swFilterItem', ['$http','$compile','$templateCache',function($http,$compile,$templateCache){
	return {
		restrict: 'A',
		scope:{
			filterItem: "=",
			siblingItems: "="
		},
		link: function(scope, element,attrs){
			var propertyAlias = scope.filterItem.propertyIdentifier.split(".").pop();
			scope.filterItem.displayPropertyIdentifier = propertyAlias;
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/filterItem.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function ($scope, $element, $attrs) {
			$scope.filterItem.disabled = false;
			$scope.filterItem.uuid = guid();
			$scope.filterItem.isClosed = true;
			$scope.filterItem.siblingItems = $scope.siblingItems;
			
			$scope.selectFilterItem = function(filterItem){
				if(filterItem.isClosed){
					for(i in filterItem.siblingItems){
						filterItem.siblingItems[i].isClosed = true;
						filterItem.siblingItems[i].disabled = true;
					}
					filterItem.isClosed = false;
					filterItem.disabled = false;
				}else{
					for(i in filterItem.siblingItems){
						filterItem.siblingItems[i].disabled = false;
					}
					filterItem.isClosed = true;
				}		
			}
        } 
	}
}]);
	
