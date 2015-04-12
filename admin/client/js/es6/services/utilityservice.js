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
    arraySorter: function(array, keyToSortBy) {
      array.sort(function(a, b) {
        if (angular.isDefined(keyToSortBy)) {
          if (a[keyToSortBy] < b[keyToSortBy]) {
            return -1;
          } else if (a[keyToSortBy] > b[keyToSortBy]) {
            return 1;
          } else {
            return 0;
          }
        } else {
          if (a < b) {
            return -1;
          } else if (a > b) {
            return 1;
          } else {
            return 0;
          }
        }
      });
      return array;
    }
  };
  return utilityService;
}]);
