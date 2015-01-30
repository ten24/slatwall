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
			},
			listFind:function(list,value,delimiter){
				if(angular.isUndefined(delimiter)){
					delimiter = ',';
				}
				var splitString = list.split(delimiter);
				var stringFound = -1;
				for (var i = 0; i < splitString.length; i++) {
				    var stringPart = splitString[i];
				    if (stringPart != value) continue;

				    stringFound = i;
				    break;
				}
			}
		};
		
		return utilityService;
	}
]);
