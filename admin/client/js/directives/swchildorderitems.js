'use strict';
angular.module('slatwalladmin').directive('swChildOrderItems',

[ '$log',
  '$http',
  '$compile',
  '$templateCache',
  '$slatwall',
  'partialsPath', 
  function(
	  $log,
	  $http,
	  $compile,
	  $templateCache,
	  $slatwall,
	  partialsPath
  ) {

	return {
		restrict : "A",
		//templateUrl:partialsPath+'childorderitems.html',
		scope:{
			orderItem:"="
		},
		link : function(scope, element, attr) {
			
		}
	};
} ]);