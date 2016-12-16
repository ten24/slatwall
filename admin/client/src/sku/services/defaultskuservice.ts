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
            this.observerKeys[selectionID] = productID; 
            this.observerService.attach(this.decideToSaveSku,'swSelectionToggleSelection' + selectionID);
        }
    }

    private decideToSaveSku = (args) =>{
        if(this.observerKeys[args.selectionid] == null){
            this.observerKeys[args.selectionid] = args.selection;
        } else if(this.observerKeys[args.selectionid] != args.selection ) { 
            this.observerKeys[args.selectionid] = args.selection;
            this.saveDefaultSku(args);
        }
    }

    private saveDefaultSku = (args) =>{ 
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