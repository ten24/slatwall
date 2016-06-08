export class DefaultSkuService { 

    private observerKeys = {}; 

    //@ngInject
    constructor(public $hibachi,
                public observerService
    ){
    }

    public attachObserver = (selectionID,productID) =>{
        if(angular.isUndefined(this.observerKeys[selectionID])){
            this.observerKeys[selectionID] = {attached:true, productID:productID}; 
            this.observerService.attach(this.saveDefaultSku,'swSelectionToggleSelection' + selectionID);
        }//otherwise the event has been attached
    }

    private saveDefaultSku = (response) =>{ 
        if(angular.isDefined(this.observerKeys[response.selectionid]) &&
           angular.isDefined(this.observerKeys[response.selectionid].productID &&
           angular.isDefined(response.selection)   
        )){
            this.$hibachi.getEntity("Product",this.observerKeys[response.selectionid].productID).then(
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
        }
    }
}