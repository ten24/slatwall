/// <reference path="../../../../../node_modules/typescript/lib/lib.es6.d.ts" />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Subject, Observable} from 'rxjs';
import * as Store from '../../../../../org/hibachi/client/src/core/prototypes/Store';

/**
 * Fulfillment List Controller
 */
class OrderFulfillmentService {
    
    private state = {
        showFulfillmentListing: true
    };

    // Middleware - Logger
    public loggerEpic = (...args) => {
        return args;
    }

    /**
     * The reducer is responsible for modifying the state of the state object into a new state.
     */
    public orderFulfillmentStateReducer:Store.Reducer = (state:any, action:Store.Action<number>):Object => {
        switch(action.type) {
            case 'TOGGLE_FULFILLMENT_LISTING':
                //modify the state and return it.
                state.showFulfillmentListing = !state.showFulfillmentListing;
                return {
                    ...state, action
                };
            case 'ADD_BATCH':
                return {
                    ...state, action
                };
            default:
                return state;
        }
    } 
    /**
     *  Store stream. Set the initial state of the typeahead using startsWith and then scan. 
     *  Scan, is an accumulator function. It keeps track of the last result emitted, and combines
     *  it with the newest result. 
     */
    public orderFulfillmentStore:Store.Store;


    //@ngInject
    constructor(public $timeout, public observerService, public $hibachi){
        //To create a store, we instantiate it using the object that holds the state variables,
        //and the reducer. We can also add a middleware to the end if you need.
        this.orderFulfillmentStore = new Store.Store( this.state, this.orderFulfillmentStateReducer );

    }

    /**
     * Creates a batch. This should use api:main.post with a context of process and an entityName instead of doAction.
     * The process object should have orderItemIdList or orderFulfillmentIDList defined and should have
     * optionally an accountID, and or locationID (or locationIDList).
     */
    public addBatch = (processObject) => {
        if (processObject) {
            processObject.data.entityName = "FulfillmentBatch";
            processObject.data['fulfillmentBatch'] = {};
            processObject.data['fulfillmentBatch']['fulfillmentBatchID'] = "";

            return this.$hibachi.saveEntity("fulfillmentBatch",'',processObject.data, "create");
        }
    }
}
export {
    OrderFulfillmentService
}