/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceQuantityEditController{
    
    public skuPriceId:string;
    public skuPrice:any; 
    public skuSkuId:any;
    public column:any; 
    public columnPropertyIdentifier:string; 
    public currencyCode:any;
    public filterOnCurrencyCode:string;
    public minQuantity:string; 
    public maxQuantity:string; 
    public price:string;
    public skuPrices=[]; 
    public isDirty:boolean;
    public relatedSkuPriceCollectionConfig;
    
    
    //@ngInject
    constructor(
        private $q, 
        private $hibachi,
        private collectionConfigService,
        private observerService,
        private skuPriceService
    ){ 
        this.isDirty = false; 
        if(angular.isDefined(this.skuSkuId) && angular.isUndefined(this.skuPrice)){
            var skuPriceData = {
                skuPriceID:this.skuPriceId, 
                minQuantity:this.minQuantity, 
                maxQuantity:this.maxQuantity,
                currencyCode:this.currencyCode,
                price:this.price
            }
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice",skuPriceData);
            this.skuPriceService.setSkuPrices(this.skuSkuId,[this.skuPrice]);
            this.relatedSkuPriceCollectionConfig = this.skuPriceService.getRelatedSkuPriceCollectionConfig(this.skuSkuId,this.currencyCode,this.minQuantity,this.maxQuantity);
            this.refreshSkuPrices();
            this.observerService.attach(this.refreshSkuPrices, "skuPricesUpdate");
        }
    }    

    public refreshSkuPrices = () => {
         this.skuPriceService.loadSkuPricesForSku(this.skuSkuId).finally(()=>{
            this.getSkuPrices(); 
         });
    }

    public updateSkuPrices = () =>{ 
        if(!this.isDirty){
            this.isDirty = true; 
        }
        angular.forEach(this.skuPriceService.getSkuPrices(this.skuSkuId),(value,key)=>{
            if(key > 0){
                value.forms["form" + value.data.skuPriceID].$setDirty(true);
                value.forms["form" + value.data.skuPriceID][this.columnPropertyIdentifier].$setDirty(true);
                value.data[this.columnPropertyIdentifier] = this.skuPrice.data[this.columnPropertyIdentifier];
            }
        });
    }

    public saveSkuPrices = () =>{
        var savePromises = [];
        angular.forEach(this.skuPrices,(value,key)=>{
            if(key > 0){
                savePromises.push(value.$$save()); 
            }
        });
        this.$q.all(savePromises).then(
            (response)=>{
                this.isDirty = false; 
            },
            (reason)=>{
                //failure
            }
        );
    }

    public getSkuPrices = () =>{
        this.skuPriceService.getSkuPricesForQuantityRange(this.skuSkuId,this.minQuantity,this.maxQuantity).then((data)=>{
            console.log("got data",data);
            this.skuPrices = data;
        });
    }

}

class SWSkuPriceQuantityEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuPrice:"=?",
        skuPriceId:"@",
        currencyCode:"@",
        skuSkuId:"@",
        column:"=?",
        columnPropertyIdentifier:"@",
        minQuantity:"@",
        maxQuantity:"@",
        price:"@"
    };
    public controller = SWSkuPriceQuantityEditController;
    public controllerAs="swSkuPriceQuantityEdit";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceQuantityEdit(
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricequantityedit.html";
    }
}
export{
    SWSkuPriceQuantityEdit,
    SWSkuPriceQuantityEditController
}
