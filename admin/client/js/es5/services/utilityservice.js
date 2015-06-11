"use strict";
'use strict';
angular.module('slatwalladmin').factory('utilityService', [function() {
  var utilityService = {
    createID: function(count) {
      var count = count || 26;
      var text = "";
      var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      for (var i = 0; i < count; i++)
        text += possible.charAt(Math.floor(Math.random() * possible.length));
      return text;
    },
    listFind: function(list, value, delimiter) {
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
    listLen: function(list, delimiter) {
      if (angular.isUndefined(delimiter)) {
        delimiter = ',';
      }
      var splitString = list.split(delimiter);
      return splitString.length;
    },
    arraySorter: function(array, keysToSortBy) {
      var arrayOfTypes = [],
          returnArray = [],
          firstKey = keysToSortBy[0];
      if (angular.isDefined(keysToSortBy[1])) {
        var secondKey = keysToSortBy[1];
      }
      for (var itemIndex in array) {
        if (!(arrayOfTypes.indexOf(array[itemIndex][firstKey]) > -1)) {
          arrayOfTypes.push(array[itemIndex][firstKey]);
        }
      }
      arrayOfTypes.sort(function(a, b) {
        if (a < b) {
          return -1;
        } else if (a > b) {
          return 1;
        } else {
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
          tempArray.sort(function(a, b) {
            if (a[secondKey] < b[secondKey]) {
              return -1;
            } else if (a[secondKey] > b[secondKey]) {
              return 1;
            } else {
              return 0;
            }
          });
        }
        for (var finalIndex in tempArray) {
          returnArray.push(tempArray[finalIndex]);
        }
      }
      return returnArray;
    }
  };
  return utilityService;
}]);

//# sourceMappingURL=../services/utilityservice.js.map