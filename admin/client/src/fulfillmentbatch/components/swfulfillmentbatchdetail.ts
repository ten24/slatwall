/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Observable} from 'rxjs/Observable';

type ActionName = "toggle" | "refresh";

/**
 * Fulfillment Batch Detail Controller
 */
class SWFulfillmentBatchDetailController  {
    expanded:boolean = false;
    public fulfillmentBatchID:string;
    public TOGGLE_ACTION:ActionName = "toggle";

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private orderFulfillmentService){
        this.orderFulfillmentService.actionStream$.subscribe(
            (next) => {
                console.log("Next Action", next);
            },
            (error) => {
                console.log("Error", error);
            }
        );
        console.log(`${this.fulfillmentBatchID}`);
    }

    public toggleListing = () => {
        this.orderFulfillmentService.dispatchAction({
            "name": this.TOGGLE_ACTION,
            "payload": {}
        });
    }


}

/**
 * This is a view helper class that uses the collection helper class.
 */
class SWFulfillmentBatchDetail implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
        fulfillmentBatchID: "@?"
    }

    public controller=SWFulfillmentBatchDetailController;
    public controllerAs="swFulfillmentBatchDetailController";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			fulfillmentBatchDetailPartialsPath,
			slatwallPathBuilder
		) => new SWFulfillmentBatchDetail (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			fulfillmentBatchDetailPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService',
			'fulfillmentBatchDetailPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private fulfillmentBatchDetailPartialsPath, slatwallPathBuilder){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(fulfillmentBatchDetailPartialsPath) + "fulfillmentbatchdetail.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}

export {
    SWFulfillmentBatchDetailController,
	SWFulfillmentBatchDetail
};
