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
    public skuPrices=[]; 
    public isDirty:boolean;
    public relatedSkuPriceCollectionConfig;
    
    
    //@ngInject
    constructor(
        private $q, 
        private $hibachi,
        private collectionConfigService,
        private observerService
    ){ 
        this.isDirty = false; 
        if(angular.isUndefined(this.skuPrice)){
            var skuPriceData = {
                skuPriceID:this.skuPriceId, 
                minQuantity:this.minQuantity, 
                maxQuantity:this.maxQuantity,
                currencyCode:this.currencyCode
            }
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice",skuPriceData);
            this.skuPrices.push(this.skuPrice);
        }
        this.relatedSkuPriceCollectionConfig = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
        this.relatedSkuPriceCollectionConfig.addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price");
        this.relatedSkuPriceCollectionConfig.addFilter("minQuantity",this.minQuantity,"=");
        this.relatedSkuPriceCollectionConfig.addFilter("maxQuantity",this.maxQuantity,"=");
        this.relatedSkuPriceCollectionConfig.addFilter("currencyCode",this.currencyCode,"!=");
        this.relatedSkuPriceCollectionConfig.addFilter("sku.skuID",this.skuSkuId,"=");
        this.relatedSkuPriceCollectionConfig.addOrderBy("currencyCode|asc");
        this.relatedSkuPriceCollectionConfig.setAllRecords(true);
        this.refreshSkuPrices();
        this.observerService.attach(this.refreshSkuPrices, "skuPricesUpdate");
    }    

    public refreshSkuPrices = () => {
         this.relatedSkuPriceCollectionConfig.getEntity().then(
            (response)=>{
                angular.forEach(response.records, (value,key)=>{
                    this.skuPrices.push(this.$hibachi.populateEntity("SkuPrice", value));
                });  
            },
            (reason)=>{
            }
        );
    }

    public updateSkuPrices = () =>{ 
        if(!this.isDirty){
            this.isDirty = true; 
        }
        angular.forEach(this.skuPrices,(value,key)=>{
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
        console.log("skuprices",this.skuPrices);
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
        maxQuantity:"@"
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
