/**
 * Handles display a single row or multiple rows depending on if the product has children.
 * @module slatwalladmin
 * @class sworderitemrow
 */
'use strict';
angular.module('slatwalladmin')
.directive('sworderitemrow', 
[
	function(){
		var getRow = function(orderItem){
			var row = "<td>TEST ROW</td>";
			return  row; 
		};
		return {
			restrict: 'A',
			transclude:false,
			scope:{
				orderItem:"=",
				orderId:"@"
			},
			replace:true,
			link: function(scope, element, attrs){
				//Get the template.
				element.html(getRow(scope.orderItem));
			}
		};
		//Change Templates depending on the row type.
		var merchTemplate = "<td>Merch</td>";
		var eventTemplate = "<td>Event</td>";
		
		
	}
]);