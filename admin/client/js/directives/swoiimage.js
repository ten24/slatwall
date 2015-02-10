/**
 * Displays an image for an order item.
 * @module slatwalladmin
 * @class swoiimage
 */
'use strict';
angular.module('slatwalladmin')
.directive('swoiimage', 
[
	function(){
		var getImageTemplate = function(orderItem, baseUrl){
			console.log("Retrieve Order Item Image");
			console.log(orderItem);
			var image = "";
			var imageName = orderItem.data.sku.data.imageFile || "none";
			if (angular.isString(imageName) && imageName !== " "){
				//image = "<center><img style='width:90px' src='"+baseUrl+ "/" + imageName + "'/></center>";
				image = "<img class='s-image' src='/assets/images/missingimage.jpg'/>";
			}else{
				//use the missing image file
				image = "<img class='s-image' style='width:90px' src='/assets/images/missingimage.jpg'/>";
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
				element.html(getImageTemplate(scope.orderItem, "/custom/assets/images/product/default"));
			}
		};
	}
]);