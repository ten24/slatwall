/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class DefaultSkuService { 

    private observerKeys = {}; 
    private defaultSkuSelections = {}; 

    //@ngInject
    constructor(public $hibachi,
                public observerService
    ){
    }

    public attachObserver = (selectionID,productID) =>{
        if(angular.isUndefined(this.observerKeys[selectionID])){
            this.observerKeys[selectionID] = {attached:true, productID:productID, hasBeenCalled:false}; 
            this.observerService.attach(this.decideToSaveSku,'swSelectionToggleSelection' + selectionID);
        }//otherwise the event has been attached
    }

    private decideToSaveSku = (args) =>{
        if(this.defaultSkuSelections[args.selectionid] == null){
            this.defaultSkuSelections[args.selectionid] = args.selection;
        } else if(this.defaultSkuSelections[args.selectionid] != args.selection ) { 
            this.defaultSkuSelections[args.selectionid] = args.selection;
            this.saveDefaultSku(args);
        }
    }

    private saveDefaultSku = (args) =>{ 
        //we only want to call save on the second and subsequent times the event fires, because it will fire when it is initialized
        this.$hibachi.getEntity( "Product", this.observerKeys[args.selectionid].productID ).then(
            (product)=>{
                var product = this.$hibachi.populateEntity("Product",product); 
                product.$$setDefaultSku(this.$hibachi.populateEntity("Sku",{skuID:args.selection}));
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
    }
}