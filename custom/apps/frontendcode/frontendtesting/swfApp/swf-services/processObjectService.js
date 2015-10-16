angular.module('slatwall').factory('ProcessObject', function($resource) {
  return $resource('/index.cfm/api/scope/getProcessObjectDefinition/?ajaxRequest=1&processObject=:processObject&entityName=:entityName&formData=:formData', { processObject: '@_processObject', entityName: '@_entityName' , formData: '@_formData'}, {
    get: {
      method: 'GET' // this method issues a GET request
    },
    post: {
      method: 'POST'
    }
  });
});