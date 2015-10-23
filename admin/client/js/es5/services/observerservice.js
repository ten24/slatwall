"use strict";
'use strict';
angular.module('slatwalladmin').factory('observerService', [function() {
  var _observerService = {};
  _observerService.observers = {};
  _observerService.attach = function(callback, event, id) {
    if (id) {
      if (!_observerService.observers[event]) {
        _observerService.observers[event] = {};
      }
      if (!_observerService.observers[event][id])
        _observerService.observers[event][id] = [];
      _observerService.observers[event][id].push(callback);
    }
  };
  _observerService.detachById = function(id) {
    for (var event in _observerService.observers) {
      _observerService.detachByEventAndId(event, id);
    }
  };
  _observerService.detachByEvent = function(event) {
    if (event in _observerService.observers) {
      delete _observerService.observers[event];
    }
  };
  _observerService.detachByEventAndId = function(event, id) {
    if (event in _observerService.observers) {
      if (id in _observerService.observers[event]) {
        delete _observerService.observers[event][id];
      }
    }
  };
  _observerService.notify = function(event, parameters) {
    for (var id in _observerService.observers[event]) {
      angular.forEach(_observerService.observers[event][id], function(callback) {
        callback(parameters);
      });
    }
  };
  return _observerService;
}]);

//# sourceMappingURL=observerservice.js.map
