'use strict';

/**
 * @ngdoc service
 * @name sdt.models:ObserverService
 * @description
 * # ObserverService
 * Manages all events inside the application
 *
 */
angular.module('slatwalladmin')
  .factory('observerService', [ function() {
    /* Initialize list of observers */
    var _observerService= {};

    /**
     * @ngdoc property
     * @name ObserverService#observers
     * @propertyOf sdt.models:ObserverService
     * @description object to store all observers in
     * @returns {object} object
     */
    _observerService.observers = {};

    /* Declare methods */
    /**
     * @ngdoc method
     * @name ObserverService#attach
     * @methodOf sdt.models:ObserverService
     * @param {function} callback the callback function to fire
     * @param {string} event name of the event
     * @param {string} id unique id for the object that is listening i.e. namespace
     * @description adds events listeners
     */
    _observerService.attach = function(callback, event, id) {
      if(id) {
        if (!_observerService.observers[event]) {
          _observerService.observers[event] = {};
        }

        if(!_observerService.observers[event][id])
          _observerService.observers[event][id] = [];

        _observerService.observers[event][id].push(callback);
      }
    };


    /**
     * @ngdoc method
     * @name ObserverService#detachById
     * @methodOf sdt.models:ObserverService
     * @param {string} id unique id for the object that is listening i.e. namespace
     * @description removes all events for a specific id from the observers object
     */
    _observerService.detachById = function(id) {
      for(var event in _observerService.observers)
      {
        _observerService.detachByEventAndId(event, id);
      }
    };

    /**
     * @ngdoc method
     * @name ObserverService#detachById
     * @methodOf sdt.models:ObserverService
     * @param {string} event name of the event
     * @description removes removes all the event from the observer object
     */
    _observerService.detachByEvent = function(event) {
      if(event in _observerService.observers) {
        delete _observerService.observers[event];
      }
    };

    /**
     * @ngdoc method
     * @name ObserverService#detachByEventAndId
     * @methodOf sdt.models:ObserverService
     * @param {string} event name of the event
     * @param {string} id unique id for the object that is listening i.e. namespace
     * @description removes removes all callbacks for an id in a specific event from the observer object
     */
    _observerService.detachByEventAndId = function(event, id) {
      if(event in _observerService.observers) {
        if(id in _observerService.observers[event]) {
          delete _observerService.observers[event][id];
        }
      }
    };

    /**
     * @ngdoc method
     * @name ObserverService#notify
     * @methodOf sdt.models:ObserverService
     * @param {string} event name of the event
     * @param {string|object|array|number} parameters pass whatever your listener is expecting
     * @description notifies all observers of a specific event
     */
    _observerService.notify = function(event, parameters) {
      for(var id in _observerService.observers[event]) {
        angular.forEach(_observerService.observers[event][id], function (callback) {
          callback(parameters);
        });
      }
    };

    return _observerService;
  }]);