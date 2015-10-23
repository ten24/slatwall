angular.module('slatwall', ['ngResource'])
.run(function() {
   //nothing here yet.

})
.config(function() {
  //nothing here yet.
}).factory('$exceptionHandler', function() {
  return function(exception, cause) {
    exception.message += ' (caused by "' + cause + '")';
    throw exception;
  };
});