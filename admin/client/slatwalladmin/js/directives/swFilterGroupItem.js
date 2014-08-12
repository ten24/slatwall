angular.module('slatwalladmin')
.directive('swFilterGroupItem',['$http','$compile','$templateCache','collectionService',function($http,$compile,$templateCache,collectionService){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			logicalOperator: "=",
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
			$scope.filterGroupItem.focus = false;
			$scope.filterGroupItem.disabled = false;
			$scope.filterGroupItem.uuid = guid();
			$scope.filterGroupItem.isClosed = true;
			$scope.filterGroupItem.siblingItems = $scope.siblingItems;
			$scope.selectFilterGroupItem = function(filterGroupItem){
				/*
				when I select an item many things happen
				toggle isClosed
				based on isClosed set disabled
				*/
				if(filterGroupItem.isClosed){
					for(i in filterGroupItem.siblingItems){
						filterGroupItem.siblingItems[i].disabled = true;
						console.log(filterGroupItem.siblingItems[i]);
						//filterGroupItem.siblingItems[i].filterGroup.isClosed = true;
						if(filterGroupItem.siblingItems[i].hasOwnProperty('filterGroup')){
							filterGroupItem.siblingItems[i].filterGroup.isClosed = true;
						}
					}
					filterGroupItem.isClosed = false;
				}else{
					for(i in filterGroupItem.siblingItems){
						filterGroupItem.siblingItems[i].disabled = false;
						console.log(filterGroupItem.siblingItems[i]);
						//filterGroupItem.siblingItems[i].filterGroup.isClosed = true;
						if(filterGroupItem.siblingItems[i].hasOwnProperty('filterGroup')){
							filterGroupItem.siblingItems[i].filterGroup.isClosed = true;
						}
					}
					filterGroupItem.isClosed = true;
				}		
				/*
				if(collectionService.hasFilterGroupItemBreadCrumb(filterGroupItem)){
					collectionService.removeFilterGroupItemBreadCrumbs(filterGroupItem);
					//collectionService.enableFilterGroupItems($scope.siblingItems);
				}else{
					collectionService.addFilterGroupItemBreadCrumb(filterGroupItem);
					//collectionService.disableFilterGroupItems($scope.siblingItems);
				}*/
			}
        }  
	}
}]);
	
	
