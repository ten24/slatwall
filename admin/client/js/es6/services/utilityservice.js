/*services return promises which can be handled uniquely based on success or failure by the controller*/
'use strict';
angular.module('slatwalladmin').factory('utilityService', [
    function () {
        //declare public and private variables
        //Define our contexts and validation property enums.
        //declare service we are returning
        var utilityService = {
            createID: function (count) {
                var count = count || 26;
                var text = "";
                var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                for (var i = 0; i < count; i++)
                    text += possible.charAt(Math.floor(Math.random() * possible.length));
                return text;
            },
            //list functions
            listFind: function (list, value, delimiter) {
                if (angular.isUndefined(delimiter)) {
                    delimiter = ',';
                }
                var splitString = list.split(delimiter);
                var stringFound = -1;
                for (var i = 0; i < splitString.length; i++) {
                    var stringPart = splitString[i];
                    if (stringPart != value)
                        continue;
                    stringFound = i;
                    break;
                }
            },
            listLen: function (list, delimiter) {
                if (angular.isUndefined(delimiter)) {
                    delimiter = ',';
                }
                var splitString = list.split(delimiter);
                return splitString.length;
            },
            arraySorter: function (array, keysToSortBy) {
                console.log("here again and again");
                console.log(keysToSortBy);
                var key1 = keysToSortBy[0];
                console.log(key1);
                // var key2 = keysToSortBy[1];
                array.sort(function (a, b) {
                    if (a.key1 > b.key1) {
                        return 1;
                    }
                    if (a.key1 < b.key1) {
                        return -1;
                    }
                    /*if (a.key1 === b.key1) {
                        if (a.key2 > b.key2) {
                            return 1;
                        }
                        if (a.key2 < b.key2) {
                            return -1;
                        }
                    }*/
                    // a must be equal to b
                    return 0;
                });
                return array;
            }
        };
        return utilityService;
    }
]);

//# sourceMappingURL=../services/utilityservice.js.map