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
				var count = count || 26;
				
			    var text = "";
			    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			
			    for( var i=0; i < count; i++ )
			        text += possible.charAt(Math.floor(Math.random() * possible.length));
			
			    return text;
			},
			//list functions
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
			},
			listLen:function(list,delimiter){
				
				if(angular.isUndefined(delimiter)){
					delimiter = ',';
				}
				var splitString = list.split(delimiter);
				return splitString.length;
			},
            //To use this sorter pass in arguments first by object to sort
            //Then an array where the first index is the first string to sort by
            //And the second index is another array containing the second string to sort by as well as ascending vs descending
            //Example: arraySorter(array, ["type",["name","asc"]])
			arraySorter:function(objArray, properties /*, primers*/) {
               var primers = arguments[2] || {};
                
                properties = properties.map(function(prop) {
                    if( !(prop instanceof Array) ) {
                        prop = [prop, 'asc']
                    }
                    if( prop[1].toLowerCase() == 'desc' ) {
                        prop[1] = -1;
                    } else {
                        prop[1] = 1;
                    }
                    return prop;
                });
                
                function valueCmp(x, y) {
                    return x > y ? 1 : x < y ? -1 : 0; 
                }
                
                function arrayCmp(a, b) {
                    var arr1 = [], arr2 = [];
                    properties.forEach(function(prop) {
                        var aValue = a[prop[0]],
                            bValue = b[prop[0]];
                        if( typeof primers[prop[0]] != 'undefined' ) {
                            aValue = primers[prop[0]](aValue);
                            bValue = primers[prop[0]](bValue);
                        }
                        arr1.push( prop[1] * valueCmp(aValue, bValue) );
                        arr2.push( prop[1] * valueCmp(bValue, aValue) );
                    });
                    return arr1 < arr2 ? -1 : 1;
                }
                
                objArray.sort(function(a, b) {
                    return arrayCmp(a, b);
                })
                return objArray;
            }
		};
		
		return utilityService;
	}
]);
