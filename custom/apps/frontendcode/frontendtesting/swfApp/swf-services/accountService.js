angular.module('slatwall').factory('Account', function($resource) {
  return $resource('/index.cfm/api/scope/getAccount/?ajaxRequest=1', { }, {
    get: {
      method: 'GET' 
    },
    post: {
      method: 'POST'
    }
  });
});