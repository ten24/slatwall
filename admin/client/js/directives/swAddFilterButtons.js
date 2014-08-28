angular.module('slatwalladmin')
.directive('swAddFilterButtons', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',

function($http,
$compile,
$templateCache,
collectionService,
partialsPath){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			itemInUse:"=",
			setItemInUse:"&"
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"addFilterButtons.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
			scope.addFilterItem = function(filterItemGroup){
				collectionService.newFilterItem(filterItemGroup,scope.setItemInUse);
			};
			
			scope.addFilterGroupItem = function(filterItemGroup){
				collectionService.newFilterGroupItem(filterItemGroup,scope.setItemInUse);
			};
		}
	};
}]);
	
