angular.module('slatwall').factory('Cart', function($resource) {
  return $resource('/index.cfm/api/scope/getCart/?ajaxRequest=1&formData=:formData',{formData:'@_formData'}, {
    get: {
      method: 'GET' 
    },
    post: {
      method: 'POST'
    }
  });
});