/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var slatwalladmin;
(function (slatwalladmin) {
    class UtilityService extends slatwalladmin.BaseService {
        constructor() {
            super();
            this.getQueryParamsFromUrl = (url) => {
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
            this.listLast = (list = '', delimiter = ',') => {
                var listArray = list.split(delimiter);
                return listArray[listArray.length - 1];
            };
            this.listFirst = (list = '', delimiter = ',') => {
                var listArray = list.split(delimiter);
                return listArray[0];
            };
            this.listPrepend = (list = '', substring, delimiter = ',') => {
                var listArray = list.split(delimiter);
                if (listArray.length) {
                    return substring + delimiter + list;
                }
                else {
                    return substring;
                }
            };
            this.listAppend = (list = '', substring, delimiter = ',') => {
                var listArray = list.split(delimiter);
                if (listArray.length) {
                    return list + delimiter + substring;
                }
                else {
                    return substring;
                }
            };
            this.formatValue = (value, formatType, formatDetails, entityInstance) => {
                if (angular.isUndefined(formatDetails)) {
                    formatDetails = {};
                }
                var typeList = ["currency", "date", "datetime", "pixels", "percentage", "second", "time", "truefalse", "url", "weight", "yesno"];
                if (typeList.indexOf(formatType)) {
                    this['format_' + formatType](value, formatDetails, entityInstance);
                }
                return value;
            };
            this.format_currency = (value, formatDetails, entityInstance) => {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_date = (value, formatDetails, entityInstance) => {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_datetime = (value, formatDetails, entityInstance) => {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_pixels = (value, formatDetails, entityInstance) => {
                if (angular.isUndefined) {
                    formatDetails = {};
                }
            };
            this.format_yesno = (value, formatDetails, entityInstance) => {
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
            this.left = (stringItem, count) => {
                return stringItem.substring(0, count);
            };
            this.right = (stringItem, count) => {
                return stringItem.substring(stringItem.length - count, stringItem.length);
            };
            this.replaceAll = (stringItem, find, replace) => {
                return stringItem.replace(new RegExp(this.escapeRegExp(find), 'g'), replace);
            };
            this.escapeRegExp = (stringItem) => {
                return stringItem.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
            };
            this.createID = (count) => {
                var count = count || 26;
                var text = "";
                var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                for (var i = 0; i < count; i++)
                    text += possible.charAt(Math.floor(Math.random() * possible.length));
                return text;
            };
            //list functions
            this.listFind = (list = '', value, delimiter = ',') => {
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
            this.listLen = (list = '', delimiter = ',') => {
                var splitString = list.split(delimiter);
                return splitString.length;
            };
            //This will enable you to sort by two separate keys in the order they are passed in
            this.arraySorter = (array, keysToSortBy) => {
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
    }
    slatwalladmin.UtilityService = UtilityService;
    angular.module('hibachi').service('utilityService', UtilityService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/utilityservice.js.map