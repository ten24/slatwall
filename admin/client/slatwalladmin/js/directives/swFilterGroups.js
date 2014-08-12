angular.module('slatwalladmin')
.directive('swFilterGroups', ['$http','$compile','$templateCache','collectionService',function($http,$compile,$templateCache,collectionService){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			incrementFilterCount:"&"
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = "/admin/client/slatwalladmin/js/directives/partials/filterGroups.html"
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function($scope,$element,$attrs){
			$scope.addFilterItem = function(filterItemGroup){
				console.log(filterItemGroup);
				if(filterItemGroup.length === 0){
					var filterItem = {
						propertyIdentifier:"",
						comparisonOperator:"=",
						value:""					
					}
				}else{
					filterItem = {
						logicalOperator:"AND",
						propertyIdentifier:"",
						comparisonOperator:"=",
						value:""					
					}
				}
				
				filterItemGroup.push(filterItem);
				console.log(filterItemGroup);
			}
			$scope.addFilterGroupItem = function(filterItemGroup){
				console.log(filterItemGroup);
				filterGroupItem = {
					logicalOperator:"AND",
					filterGroup:[]			
				}
				filterItemGroup.push(filterGroupItem);
				console.log(filterItemGroup);
			}
			
		}
	}
}]);
	
