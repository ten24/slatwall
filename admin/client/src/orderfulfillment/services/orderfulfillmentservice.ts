/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import * as Prototypes from '../../../../../org/hibachi/client/src/core/prototypes/Observable';
import * as rx from 'rxjs';


/**
 * Fulfillment List Controller
 */
class OrderFulfillmentService implements  Prototypes.Observable.IObservable {
    
    // Observable string sources
    public storeSource: rx.Subject<any>;
   
    // Observable string streams
    public actionStream$:rx.Observable<any>;

    public observers: Array<Prototypes.Observable.IObserver>

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private $http){
        this.storeSource = new rx.Subject<any>();
        this.actionStream$ = this.storeSource.asObservable();
    }

    // Service announce that a new card is being added.
    public dispatch(action: {}) {
        console.log("Action: ", action);
        this.storeSource.next(action);
    }

    /**
     * This manages all the observer events without the need for setting ids etc.
     */
    public registerObserver = (_observer: Prototypes.Observable.IObserver) => {
        if (!_observer){
            throw new Error('Observer required for registration');
        }
        if (this.observers == undefined){
            this.observers = new Array<Prototypes.Observable.IObserver>();
        }
        this.observers.push(_observer);
    }
    /**
     * Removes the observer. Just pass in this
     */
    public removeObserver = (_observer: Prototypes.Observable.IObserver) => {
         if (!_observer){
            throw new Error('Observer required for removal.');
         }
         for (var observer in this.observers){
            if (this.observers[observer] === (_observer)){
                if (this.observers.indexOf(_observer) > -1){
                    this.observers.splice(this.observers.indexOf(_observer), 1);
                }
            }
         }
    }
    
    /**
     * Note that message should have a type and a data field
     */
    public notifyObservers = (_message: any) => {
        for (var observer in this.observers){
            this.observers[observer].recieveNotification(_message);
        }
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