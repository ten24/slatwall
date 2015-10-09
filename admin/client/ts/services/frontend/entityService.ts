angular.module('slatwalladmin').factory('Entity', function($resource) {
  return $resource('/index.cfm/api/:entityName/:id', { entityName: '@_entityName', id:'@_id'}, {
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