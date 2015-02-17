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
		link : function(scope, element, attr, ngModel) {
			scope.$watch('orderItem.data.childOrderItems',function(newValue,oldValue){
				if(newValue !== oldValue){
					console.log('found child order items');
					//when we load the child order items then append the child template
					var Partial = partialsPath+"childorderitems.html";
					var templateLoader = $http.get(Partial,{cache:$templateCache});
					var promise = templateLoader.success(function(html){
						element.append(html);
					}).then(function(response){
						element.replaceWith($compile(element.html())(scope));
					});
				}
			});
		}
	};
} ]);