/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * @ngdoc service
 * @name sdt.models:ObserverService
 * @description
 * # ObserverService
 * Manages all events inside the application
 *
 */

import {BaseService} from "./baseservice";
import {UtilityService} from "./utilityservice";

class ObserverService extends BaseService{
    private observers;
    //@ngInject
    constructor(public $timeout,private utilityService){
        /**
         * @ngdoc property
         * @name ObserverService#observers
         * @propertyOf sdt.models:ObserverService
         * @description object to store all observers in
         * @returns {object} object
         */
        super();
        this.observers = {};
    }
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
    attach = (callback:any, event:string, id?:string):void => {
        if(!id){
            id = this.utilityService.createID();
        }
        event = event.toLowerCase();
        id = id.toLowerCase();
        if (!this.observers[event]) {
            this.observers[event] = {};
        }

        if(!this.observers[event][id])
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
    detachById = (id:string):void => {
        id = id.toLowerCase();
        for(var event in this.observers) {
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
    detachByEvent = (event:string):void => {
        event = event.toLowerCase();
        if(event in this.observers) {
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
    detachByEventAndId = (event:string, id:string):void => {
        event = event.toLowerCase();
        id = id.toLowerCase();
        if(event in this.observers) {
            if(id in this.observers[event]) {
                delete this.observers[event][id];
            }
        }
    };

    /**
     * @ngdoc method
     * @name ObserverService#notify
     * @methodOf sdt.models:ObserverService
     * @param {string} event name of the event
     * @param {string|object|Array|number} parameters pass whatever your listener is expecting
     * @description notifies all observers of a specific event
     */
    notify = (event:string, parameters:any):void => {
        event = event.toLowerCase();
        return this.$timeout(()=>{
            for(var id in this.observers[event]) {
                for(var callback of this.observers[event][id]) {
                    callback(parameters);
                }
            }
        });
    };

    /**
     * @ngdoc method
     * @name ObserverService#notifyById
     * @methodOf sdt.models:ObserverService
     * @param {string} event name of the event
     * @param {string} eventId unique id for the object that is listening i.e. namespace
     * @param {string|object|Array|number} parameters pass whatever your listener is expecting
     * @description notifies observers of a specific event by id
     */
    notifyById = (event:string, eventId:string ,parameters:any):void => {
        event = event.toLowerCase();
        eventId = eventId.toLowerCase();
        return this.$timeout(()=>{
            for(var id in this.observers[event]) {
                if(id != eventId) continue;
                angular.forEach(this.observers[event][id], function (callback) {
                    callback(parameters);
                });
            }
        });
    }
}
export {ObserverService};