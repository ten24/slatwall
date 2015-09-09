var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var slatwalladmin;
(function (slatwalladmin) {
    var UtilityService = (function (_super) {
        __extends(UtilityService, _super);
        function UtilityService() {
            var _this = this;
            _super.call(this);
            this.listLast = function (list, delimiter) {
                if (angular.isUndefined(delimiter)) {
                    delimiter = ',';
                }
                var listArray = list.split(delimiter);
                return listArray[listArray.length - 1];
            };
            this.left = function (stringItem, count) {
                return stringItem.substring(0, count);
            };
            this.right = function (stringItem, count) {
                return stringItem.substring(stringItem.length - count, stringItem.length);
            };
            this.replaceAll = function (stringItem, find, replace) {
                return stringItem.replace(new RegExp(_this.escapeRegExp(find), 'g'), replace);
            };
            this.escapeRegExp = function (stringItem) {
                return stringItem.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
            };
            this.createID = function (count) {
                var count = count || 26;
                var text = "";
                var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                for (var i = 0; i < count; i++)
                    text += possible.charAt(Math.floor(Math.random() * possible.length));
                return text;
            };
            //list functions
            this.listFind = function (list, value, delimiter) {
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
            };
            this.listLen = function (list, delimiter) {
                if (angular.isUndefined(delimiter)) {
                    delimiter = ',';
                }
                var splitString = list.split(delimiter);
                return splitString.length;
            };
            //This will enable you to sort by two separate keys in the order they are passed in
            this.arraySorter = function (array, keysToSortBy) {
                var arrayOfTypes = [], returnArray = [], firstKey = keysToSortBy[0];
                if (angular.isDefined(keysToSortBy[1])) {
                    var secondKey = keysToSortBy[1];
                }
                for (var itemIndex in array) {
                    if (!(arrayOfTypes.indexOf(array[itemIndex][firstKey]) > -1)) {
                        arrayOfTypes.push(array[itemIndex][firstKey]);
                    }
                }
                arrayOfTypes.sort(function (a, b) {
                    if (a < b) {
                        return -1;
                    }
                    else if (a > b) {
                        return 1;
                    }
                    else {
                        return 0;
                    }
                });
                for (var typeIndex in arrayOfTypes) {
                    var tempArray = [];
                    for (var itemIndex in array) {
                        if (array[itemIndex][firstKey] == arrayOfTypes[typeIndex]) {
                            tempArray.push(array[itemIndex]);
                        }
                    }
                    if (keysToSortBy[1].length) {
                        tempArray.sort(function (a, b) {
                            if (a[secondKey] < b[secondKey]) {
                                return -1;
                            }
                            else if (a[secondKey] > b[secondKey]) {
                                return 1;
                            }
                            else {
                                return 0;
                            }
                        });
                    }
                    for (var finalIndex in tempArray) {
                        returnArray.push(tempArray[finalIndex]);
                    }
                }
                return returnArray;
            };
        }
        return UtilityService;
    })(slatwalladmin.BaseService);
    slatwalladmin.UtilityService = UtilityService;
    angular.module('slatwalladmin').service('utilityService', UtilityService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/utilityservice.js.map