angular.module('frontEndApplication').factory('Cart', function($resource) {
  return $resource('/index.cfm/api/scope/getCart/?ajaxRequest=1&formData=',{formData:'@_formData'}, {
    get: {
      method: 'GET' 
    },
    post: {
      method: 'POST'
    },
    update: {
      method: 'POST'
    },
    delete: {
      method: 'DELETE'
    }
  });
});