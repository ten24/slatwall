/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class DefaultSkuService { 

    private observerKeys = {}; 

    //@ngInject
    constructor(public $hibachi,
                public observerService
    ){
    }

    public attachObserver = (selectionID,productID) =>{
        if(angular.isUndefined(this.observerKeys[selectionID])){
            this.observerKeys[selectionID] = {attached:true, productID:productID, hasBeenCalled:false}; 
            this.observerService.attach(this.saveDefaultSku,'swSelectionToggleSelection' + selectionID);
        }//otherwise the event has been attached
    }

    private saveDefaultSku = (response) =>{ 
        //we only want to call save on the second and subsequent times the event fires, because it will fire when it is initialized
        if(
           angular.isDefined(this.observerKeys[response.selectionid]) &&
           angular.isDefined(this.observerKeys[response.selectionid].hasBeenCalled) &&
           this.observerKeys[response.selectionid].hasBeenCalled    
        ){
            this.$hibachi.getEntity( "Product", this.observerKeys[response.selectionid].productID ).then(
                (product)=>{
                    var product = this.$hibachi.populateEntity("Product",product); 
                    product.$$setDefaultSku(this.$hibachi.populateEntity("Sku",{skuID:response.selection}));
                    product.$$save().then(
                        ()=>{
                            //there was success
                        },
                        ()=>{
                            //there was a problem
                        });
                },
                (reason)=>{

                }
            );
        } else { 
            this.observerKeys[response.selectionid].hasBeenCalled = true; 
        }
    }
}