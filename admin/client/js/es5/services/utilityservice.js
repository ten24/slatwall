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
      console.log("here again and again");
      console.log(keysToSortBy);
      var key1 = keysToSortBy[0];
      console.log(key1);
      array.sort(function(a, b) {
        if (a.key1 > b.key1) {
          return 1;
        }
        if (a.key1 < b.key1) {
          return -1;
        }
        return 0;
      });
      return array;
    }
  };
  return utilityService;
}]);

//# sourceMappingURL=../services/utilityservice.js.map