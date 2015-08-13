var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
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
    var ObserverService = (function (_super) {
        __extends(ObserverService, _super);
        function ObserverService() {
            var _this = this;
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
            this.attach = function (callback, event, id) {
                if (id) {
                    if (!_this.observers[event]) {
                        _this.observers[event] = {};
                    }
                    if (!_this.observers[event][id])
                        _this.observers[event][id] = [];
                    _this.observers[event][id].push(callback);
                }
            };
            /**
             * @ngdoc method
             * @name ObserverService#detachById
             * @methodOf sdt.models:ObserverService
             * @param {string} id unique id for the object that is listening i.e. namespace
             * @description removes all events for a specific id from the observers object
             */
            this.detachById = function (id) {
                for (var event in _this.observers) {
                    _this.detachByEventAndId(event, id);
                }
            };
            /**
             * @ngdoc method
             * @name ObserverService#detachById
             * @methodOf sdt.models:ObserverService
             * @param {string} event name of the event
             * @description removes removes all the event from the observer object
             */
            this.detachByEvent = function (event) {
                if (event in _this.observers) {
                    delete _this.observers[event];
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
            this.detachByEventAndId = function (event, id) {
                if (event in _this.observers) {
                    if (id in _this.observers[event]) {
                        delete _this.observers[event][id];
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
            this.notify = function (event, parameters) {
                for (var id in _this.observers[event]) {
                    angular.forEach(_this.observers[event][id], function (callback) {
                        callback(parameters);
                    });
                }
            };
            /**
             * @ngdoc property
             * @name ObserverService#observers
             * @propertyOf sdt.models:ObserverService
             * @description object to store all observers in
             * @returns {object} object
             */
            this.observers = {};
        }
        return ObserverService;
    })(slatwalladmin.BaseService);
    slatwalladmin.ObserverService = ObserverService;
    angular.module('slatwalladmin').service('observerService', ObserverService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/observerservice.js.map