var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var slatwalladmin;
(function (slatwalladmin) {
    var UtilityService = (function (_super) {
        __extends(UtilityService, _super);
        function UtilityService() {
            var _this = this;
            _super.call(this);
            this.getQueryParamsFromUrl = function (url) {
                // This function is anonymous, is executed immediately and 
                // the return value is assigned to QueryString!
                var query_string = {};
                if (url && url.split) {
                    spliturl = url.split('?');
                    if (spliturl.length) {
                        url = spliturl[1];
                        if (url && url.split) {
                            var vars = url.split("&");
                            if (vars && vars.length) {
                                for (var i = 0; i < vars.length; i++) {
                                    var pair = vars[i].split("=");
                                    // If first entry with this name
                                    if (typeof query_string[pair[0]] === "undefined") {
                                        query_string[pair[0]] = pair[1];
                                    }
                                    else if (typeof query_string[pair[0]] === "string") {
                                        var arr = [query_string[pair[0]], pair[1]];
                                        query_string[pair[0]] = arr;
                                    }
                                    else {
                                        query_string[pair[0]].push(pair[1]);
                                    }
                                }
                            }
                        }
                    }
                }
                return query_string;
            };
            this.listLast = function (list, delimiter) {
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ','; }
                var listArray = list.split(delimiter);
                return listArray[listArray.length - 1];
            };
            this.listRest = function (list, delimiter) {
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ","; }
                var listArray = list.split(delimiter);
                if (listArray.length) {
                    listArray.splice(0, 1);
                }
                return listArray.join(delimiter);
            };
            this.listFirst = function (list, delimiter) {
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ','; }
                var listArray = list.split(delimiter);
                return listArray[0];
            };
            this.listPrepend = function (list, substring, delimiter) {
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ','; }
                var listArray = list.split(delimiter);
                if (listArray.length) {
                    return substring + delimiter + list;
                }
                else {
                    return substring;
                }
            };
            this.listAppend = function (list, substring, delimiter) {
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ','; }
                var listArray = list.split(delimiter);
                if (listArray.length) {
                    return list + delimiter + substring;
                }
                else {
                    return substring;
                }
            };
            this.formatValue = function (value, formatType, formatDetails, entityInstance) {
                if (angular.isUndefined(formatDetails)) {
                    formatDetails = {};
                }
                var typeList = ["currency", "date", "datetime", "pixels", "percentage", "second", "time", "truefalse", "url", "weight", "yesno"];
                if (typeList.indexOf(formatType)) {
                    _this['format_' + formatType](value, formatDetails, entityInstance);
                }
                return value;
            };
            this.format_currency = function (value, formatDetails, entityInstance) {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_date = function (value, formatDetails, entityInstance) {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_datetime = function (value, formatDetails, entityInstance) {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_pixels = function (value, formatDetails, entityInstance) {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_yesno = function (value, formatDetails, entityInstance) {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
                if (Boolean(value) === true) {
                    return entityInstance.metaData.$$getRBKey("define.yes");
                }
                else if (value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0') {
                    return entityInstance.metaData.$$getRBKey("define.no");
                }
            };
            this.left = function (stringItem, count) {
                return stringItem.substring(0, count);
            };
            this.right = function (stringItem, count) {
                return stringItem.substring(stringItem.length - count, stringItem.length);
            };
            //this.utilityService.mid(propertyIdentifier,1,propertyIdentifier.lastIndexOf('.'));
            this.mid = function (stringItem, start, count) {
                var end = start + count;
                return stringItem.substring(start, end);
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
            this.arrayToList = function (array, delimiter) {
                if (delimiter != null) {
                    return array.join(delimiter);
                }
                else {
                    return array.join();
                }
            };
            this.listFind = function (list, value, delimiter) {
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ','; }
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
                if (list === void 0) { list = ''; }
                if (delimiter === void 0) { delimiter = ','; }
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
                    if (keysToSortBy[1] != null) {
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
    angular.module('hibachi').service('utilityService', UtilityService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/utilityservice.js.map