/**
 * Displays an image for an order item.
 * @module slatwalladmin
 * @class swoiimage
 */
'use strict';
angular.module('slatwalladmin')
.directive('swoiimage', 
["$http",
	function($http){
		var getImageTemplate = function(path){
			//console.log("Retrieve Order Item Image");
			//console.log(orderItem);
			var image;
			
			if (path !== ""){
				image = "<img src='"+path+"'/>";
			}
			
			return image; 
		}
		return {
			restrict: 'E',
			transclude: true,
			scope:{
				orderItem:"=",
			},
			replace:true,
			link: function(scope, element, attrs){
				//Get the template.
				//Call http to get the path from the image.
				var skuID = scope.orderItem.data.sku.data.skuID;
				$http.get("/index.cfm?slatAction=api:main.getResizedImageByProfileName&profileName=orderItem&skuIDs=" + skuID)
			    .success(
			    		function(response) {
			    			console.log(response);
			    			element.html(getImageTemplate(response.RESIZEDIMAGEPATHS[0]));
			    			});
			}
		};
	}
]);