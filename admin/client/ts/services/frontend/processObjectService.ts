angular.module('slatwalladmin').factory('ProcessObject', function($resource) {
  return $resource('/index.cfm/api/scope/getProcessObjectDefinition/?ajaxRequest=1&processObject=:processObject&entityName=:entityName', { processObject: '@_processObject', entityName: '@_entityName' }, {
    get: {
      method: 'GET' // this method issues a GET request
    },
    post: {
      method: 'POST'
    }
  });
});