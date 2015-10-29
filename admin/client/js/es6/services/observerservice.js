/**
 * @ngdoc service
 * @name sdt.models:ObserverService
 * @description
 * # ObserverService
 * Manages all events inside the application
 *
 */
var slatwalladmin;
(function (slatwalladmin) {
    class ObserverService extends slatwalladmin.BaseService {
        constructor(utilityService) {
            /**
             * @ngdoc property
             * @name ObserverService#observers
             * @propertyOf sdt.models:ObserverService
             * @description object to store all observers in
             * @returns {object} object
             */
            super();
            this.utilityService = utilityService;
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
            this.attach = (callback, event, id) => {
                if (!id) {
                    id = this.utilityService.createID();
                }
                if (!this.observers[event]) {
                    this.observers[event] = {};
                }
                if (!this.observers[event][id])
                    this.observers[event][id] = [];
                this.observers[event][id].push(callback);
            };
            /**
             * @ngdoc method
             * @name ObserverService#detachById
             * @methodOf sdt.models:ObserverService
             * @param {string} id unique id for the object that is listening i.e. namespace
             * @description removes all events for a specific id from the observers object
             */
            this.detachById = (id) => {
                for (var event in this.observers) {
                    this.detachByEventAndId(event, id);
                }
            };
            /**
             * @ngdoc method
             * @name ObserverService#detachById
             * @methodOf sdt.models:ObserverService
             * @param {string} event name of the event
             * @description removes removes all the event from the observer object
             */
            this.detachByEvent = (event) => {
                if (event in this.observers) {
                    delete this.observers[event];
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
            this.detachByEventAndId = (event, id) => {
                if (event in this.observers) {
                    if (id in this.observers[event]) {
                        delete this.observers[event][id];
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
            this.notify = (event, parameters) => {
                for (var id in this.observers[event]) {
                    angular.forEach(this.observers[event][id], function (callback) {
                        callback(parameters);
                    });
                }
            };
            this.observers = {};
        }
    }
    ObserverService.$inject = ['utilityService'];
    slatwalladmin.ObserverService = ObserverService;
    angular.module('hibachi').service('observerService', ObserverService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=observerservice.js.map
