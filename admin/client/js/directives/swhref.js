'use strict';
angular.module('slatwalladmin')
.directive('swHref', 
[
'collectionPartialsPath',

function(
collectionPartialsPath){
	return {
		restrict: 'A',
		
		link: function(scope, element,attrs){
		}
	};
}]);
	
