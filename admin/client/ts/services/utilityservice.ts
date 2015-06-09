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
            //This will enable you to sort by two separate keys in the order they are passed in
			arraySorter:function(array, keysToSortBy){
			    var arrayOfTypes = [],
                    returnArray = [],
                    firstKey = keysToSortBy[0];
                
                if(angular.isDefined(keysToSortBy[1])){
                    var secondKey = keysToSortBy[1];
                }

                for(var itemIndex in array){         
                    if(!(arrayOfTypes.indexOf(array[itemIndex][firstKey]) > -1)){
                        arrayOfTypes.push(array[itemIndex][firstKey]);  
                    }  
                }
                arrayOfTypes.sort(function(a, b){
                    if(a < b){
                        return -1;
                    }else if(a > b){
                        return 1;
                    }else{
                        return 0;   
                    }
                });
                for(var typeIndex in arrayOfTypes){
                    var tempArray = [];
                    for(var itemIndex in array){
                        if(array[itemIndex][firstKey] == arrayOfTypes[typeIndex]){
                            tempArray.push(array[itemIndex]);  
                        }
                    }
                    if(keysToSortBy[1].length){
                        tempArray.sort(function(a, b){
                            if(a[secondKey]< b[secondKey]){
                                return -1;
                            }else if(a[secondKey] > b[secondKey]){
                                return 1;
                            }else{
                                return 0;   
                            } 
                        }); 
                    }

                    for(var finalIndex in tempArray){
                        returnArray.push(tempArray[finalIndex]);    
                    }
                    
                }

                return returnArray;

				
			}
		};
		
		return utilityService;
	}
]);
