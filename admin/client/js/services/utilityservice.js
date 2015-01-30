/*services return promises which can be handled uniquely based on success or failure by the controller*/
'use strict';
angular.module('slatwalladmin')
.factory('utilityService',[ 
	function(
	){
		//declare public and private variables
		
		//Define our contexts and validation property enums.
		
		//declare service we are returning
		var utilityService = {
			createID:function(count){
			    var text = "";
			    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			
			    for( var i=0; i < count; i++ )
			        text += possible.charAt(Math.floor(Math.random() * possible.length));
			
			    return text;
			}
		};
		
		return utilityService;
	}
]);
