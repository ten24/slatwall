angular.module('slatwalladmin')
.directive('swFilterGroupItem',['$http','$compile','$templateCache','collectionService',function($http,$compile,$templateCache,collectionService){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			siblingItems:"="
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
			console.log($scope.filterGroupItem);
			//for(item in filterGroupItem){}
			
			$scope.filterGroupItem.disabled = false;
			$scope.filterGroupItem.isClosed = true;
			$scope.filterGroupItem.siblingItems = $scope.siblingItems;
			$scope.selectFilterGroupItem = function(filterGroupItem){
				if(filterGroupItem.isClosed){
					for(i in filterGroupItem.siblingItems){
						filterGroupItem.siblingItems[i].disabled = true;
					}
					filterGroupItem.isClosed = false;
					filterGroupItem.disabled = false;
				}else{
					for(i in filterGroupItem.siblingItems){
						filterGroupItem.siblingItems[i].disabled = false;
					}
					filterGroupItem.isClosed = true;
				}
			}
        }  
	}
}]);
	
	
