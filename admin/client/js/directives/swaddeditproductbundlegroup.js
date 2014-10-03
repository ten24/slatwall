'use strict';
angular.module('slatwalladmin')
.directive('swAddEditProductBundleGroup', 
['$http',
'productBundlePartialsPath',

function($http,
productBundlePartialsPath){
	return {
		restrict: 'A',
		templateUrl:productBundlePartialsPath+"addeditproductbundlegroup.html",
		scope:{
			
		},
		link: function(scope, element,attrs){
			
		}
	};
}]);
	
