/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import * as actions from '../actions/orderdeliveryactions';

/**
 * Fulfillment Batch Detail Controller
 */
class SWOrderDeliveryDetailController  {
    
   // public state;
    public boxes;
    public defaultContainersStruct;
    public unassignedContainerItems;
    public containerPresetCollection;
    public packageCount;
    public defaultContainerJson: any;
    public orderFulfillmentId: string;
    public hasIntegration: boolean;
    public useShippingIntegrationForTrackingNumber:boolean;
    
    
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private listingService, private orderFulfillmentService, private rbkeyService){
        this.defaultContainersStruct = this.defaultContainerJson;
        this.packageCount =  this.defaultContainersStruct['packageCount'];
        delete this.defaultContainersStruct['packageCount'];

        if(this.hasIntegration){
            this.useShippingIntegrationForTrackingNumber = true;
        }else{
            this.useShippingIntegrationForTrackingNumber = false;
        }
        this.boxes = [];
        this.unassignedContainerItems={};
        
        for (var key in this.defaultContainersStruct){
            for (var index in this.defaultContainersStruct[key] ){
                var container = this.defaultContainersStruct[key][index];
                
                var box = {};
                box['containerName'] = container.containerName;
                box['containerPresetID'] = container.containerPresetID;
                box['depth'] = container.depth || 1;
                box['height'] = container.height || 1;
                box['itemcount'] = container.itemcount;
                box['maxQuantity'] = container.maxQuantity;
                box['value'] = container.value;
                box['weight'] = container.weight;
                box['width'] = container.width || 1;
                box['containerItems'] = container.containerItems;
                //Do this for UI tracking
                box['containerPreset'] = {
                    //Don't judge me
                    containerPresetID: container.containerPresetID
                }

                this.boxes.push(box);
            }
            
        }

        this.getContainerPresetList();
    }
    
    /**
     * Setup the container preset list
     */
     private getContainerPresetList = () => {
        this.containerPresetCollection = this.collectionConfigService.newCollectionConfig("ContainerPreset");
        this.containerPresetCollection.addDisplayProperty("containerPresetID");
        this.containerPresetCollection.addDisplayProperty("containerName");
        this.containerPresetCollection.addDisplayProperty("height");
        this.containerPresetCollection.addDisplayProperty("width");
        this.containerPresetCollection.addDisplayProperty("depth");
        this.containerPresetCollection.getEntity().then( 
            (result) => {
                this.containerPresetCollection = result.pageRecords || [];
            });
     }
    
    /** Populates box dimensions with dimensions from container preset */
      
    public userAddingNewBox = () => {
        this.boxes.push({containerItems:[]});
    }

    public userRemovingBox = (index) => {
        this.boxes.splice(index, 1);
    }
    
    /**
     * Updates the quantity of a container item.
    */ 
    private updateContainerItemQuantity = (containerItem, newQuantity) =>{
        newQuantity = +newQuantity;
        if(newQuantity == undefined || isNaN(newQuantity)){
            return;
        }
        if(newQuantity < 0){
            newQuantity = 0;
        }
        
        if(newQuantity > containerItem.packagedQuantity){
            
            let quantityDifference = newQuantity - containerItem.packagedQuantity;
            
            if(!this.unassignedContainerItems[containerItem.sku.skuCode]){
                containerItem.newQuantity = containerItem.packagedQuantity;
                return;
            }else if(this.unassignedContainerItems[containerItem.sku.skuCode].quantity <= quantityDifference){
                newQuantity = containerItem.packagedQuantity + this.unassignedContainerItems[containerItem.sku.skuCode].quantity;
                quantityDifference = newQuantity - containerItem.packagedQuantity;
                containerItem.newQuantity = newQuantity;
                containerItem.packagedQuantity = newQuantity;
                this.unassignedContainerItems[containerItem.sku.skuCode].quantity -= quantityDifference;
            }
            
        }else if(newQuantity < containerItem.packagedQuantity){
            if(!this.unassignedContainerItems[containerItem.sku.skuCode]){
                this.unassignedContainerItems[containerItem.sku.skuCode] = {
                    sku:containerItem.sku,
                    item:containerItem.item,
                    quantity:0
                };
            }
            this.unassignedContainerItems[containerItem.sku.skuCode].quantity += containerItem.packagedQuantity - newQuantity;
            containerItem.packagedQuantity = newQuantity;
            containerItem.newQuantity = newQuantity;
        }
        if(this.unassignedContainerItems[containerItem.sku.skuCode].quantity == 0){
            delete this.unassignedContainerItems[containerItem.sku.skuCode];
        }
        
        this.cleanUpContainerItems();
        
        //this.emitUpdateToClient();
    }
    
    /**Sets container for unassigned item */
    public userSettingUnassignedItemContainer = (skuCode,container) =>{

        let containerItem = container.containerItems.find(item=>{
            return item.sku.skuCode == skuCode;
        });
        
        if(!containerItem){
            containerItem = {
                item:this.unassignedContainerItems[skuCode].item,
                sku:this.unassignedContainerItems[skuCode].sku,
                packagedQuantity:0
            };
            
            container.containerItems.push(containerItem);
        }
        
        containerItem.packagedQuantity += this.unassignedContainerItems[skuCode].quantity;
        
        delete this.unassignedContainerItems[skuCode];

        this.cleanUpContainerItems();
        //this.emitUpdateToClient();
    }
    
     /**
     * Removes any container items from their container if the packaged quantity is zero
     */
    private cleanUpContainerItems = ()=>{
        for(let i = 0; i < this.boxes.length; i++){
            let box = this.boxes[i];
            for(let j = box.containerItems.length-1; j >= 0; j--){
                let containerItem = box.containerItems[j];
                if(containerItem.packagedQuantity == 0){
                    box.containerItems.splice(j,1);
                }else{
                    containerItem.newQuantity = containerItem.packagedQuantity;
                }
            }
        }
    }
    
    /** Populates box dimensions with dimensions from container preset */
    public userUpdatingBoxPreset = (box) => {
        if(!box.containerPreset){
            return;
        }
        box.height = box.containerPreset.height;
        box.width = box.containerPreset.width;
        box.depth = box.containerPreset.depth;
        box.containerName = box.containerPreset.containerName;
        box.containerPresetID = box.containerPreset.containerPresetID;
        
    }
}

/**
 * This is a view helper class that uses the collection helper class.
 */
class SWOrderDeliveryDetail implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
        orderFulfillmentId: "@?",
        defaultContainerJson: "=",
        hasIntegration:'='
    }

    public controller=SWOrderDeliveryDetailController;
    public controllerAs="swOrderDeliveryDetailController";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			orderDeliveryDetailPartialsPath,
			slatwallPathBuilder
		) => new SWOrderDeliveryDetail (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			orderDeliveryDetailPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService',
			'orderDeliveryDetailPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private orderDeliveryDetailPartialsPath, slatwallPathBuilder){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderDeliveryDetailPartialsPath) + "/orderdeliverydetail.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}

export {
    SWOrderDeliveryDetailController,
	SWOrderDeliveryDetail
};