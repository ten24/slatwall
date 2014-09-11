angular.module('slatwalladmin')
.directive('swRelationshipBreadCrumb',
[
'$compile',

function(
$compile){
	return {
		restrict: 'A',
		replace:true,
		scope:{
			variables:"=", //{key:value}
			directive:"="
		},
		link: function(scope, element, attrs) {

	        
	    }
	};
}]);
	
	
