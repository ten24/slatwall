angular.module('frontEndApplication').factory('Account', function($resource) {
  return $resource('/index.cfm/api/scope/getAccount/?ajaxRequest=1&formData=:data', { data: '@_data'}, {
    get: {
      method: 'GET' 
    },
    post: {
      method: 'POST'
    }
  });
});