export class SkuPriceService { 

    private skuPrices = {};
    private skuPriceCollectionConfigs = {}; 
    private skuPricePromises = {}; 

    //@ngInject
    constructor(public $hibachi,
                public collectionConfigService, 
                public observerService
    ){
    }

    public getRelatedSkuPriceCollectionConfig = (skuID,currencyCode,minQuantity,maxQuantity) =>{
        var relatedSkuPriceCollectionConfig = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
        relatedSkuPriceCollectionConfig.addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price");
        relatedSkuPriceCollectionConfig.addFilter("minQuantity",minQuantity,"=");
        relatedSkuPriceCollectionConfig.addFilter("maxQuantity",maxQuantity,"=");
        relatedSkuPriceCollectionConfig.addFilter("currencyCode",currencyCode,"!=");
        relatedSkuPriceCollectionConfig.addFilter("sku.skuID",skuID,"=");
        relatedSkuPriceCollectionConfig.addOrderBy("currencyCode|asc");
        relatedSkuPriceCollectionConfig.setAllRecords(true);
        return relatedSkuPriceCollectionConfig;
    }

    public loadSkuPricesForSku = (skuID, refresh?) =>{
        if(angular.isUndefined(this.skuPriceCollectionConfigs[skuID])){
            this.skuPriceCollectionConfigs[skuID] = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
            this.skuPriceCollectionConfigs[skuID].addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price");
            this.skuPriceCollectionConfigs[skuID].addFilter("sku.skuID",skuID,"=");
            this.skuPriceCollectionConfigs[skuID].addOrderBy("currencyCode|asc");
            this.skuPriceCollectionConfigs[skuID].setAllRecords(true);
        }
        if(angular.isUndefined(this.skuPricePromises[skuID])){
            this.skuPricePromises[skuID] = this.skuPriceCollectionConfigs[skuID].getEntity(); 
            refresh=true; 
        }
        if(refresh){
            this.skuPricePromises[skuID].then((response)=>{
                angular.forEach(response.records,(value,key)=>{
                    this.setSkuPrices(skuID, [this.$hibachi.populateEntity("SkuPrice", value)]);
                }); 
            },
            (reason)=>{
                
            })
        }
        return this.skuPricePromises[skuID];
    }

    public setSkuPrices = (skuID, skuPrices) => { 
        if(angular.isDefined(this.skuPrices[skuID])){
            for(var i=0; i < skuPrices.length; i++){
                if(this.getKeyOfSkuPriceMatch(skuID, skuPrices[i]) != -1){
                    this.getSkuPrices(skuID)[this.getKeyOfSkuPriceMatch(skuID, skuPrices[i])].data.price = skuPrices[i].data.price; 
                    skuPrices.splice(i, 1);
                    i--;
                }
            }
            this.skuPrices[skuID] = this.skuPrices[skuID].concat(skuPrices);
        } else {
            this.skuPrices[skuID] = skuPrices; 
        }
    };

    public hasSkuPrices = (skuID) =>{
        if(angular.isDefined(this.skuPrices[skuID])){
            return true;
        }
        return false; 
    }

    public getSkuPrices = (skuID) =>{
        if(angular.isDefined(this.skuPrices[skuID])){
            return this.skuPrices[skuID];
        }
    }

    public getSkuPricesForQuantityRange = (skuID, minQuantity, maxQuantity) => {
        var skuPriceSet = []; 
        if(angular.isDefined(this.skuPrices[skuID])){
            for(var i=0; i < this.getSkuPrices(skuID).length; i++){
                var skuPrice = this.getSkuPrices(skuID)[i];
                if( skuPrice.data.minQuantity == minQuantity &&
                    skuPrice.data.maxQuantity == maxQuantity
                ){
                    skuPriceSet.push(skuPrice);
                }
            }
        }
        return skuPriceSet; 
    }

    public getKeyOfSkuPriceMatch = (skuID, skuPrice) =>{
        if(this.hasSkuPrices(skuID)){
            for(var i=0; i < this.getSkuPrices(skuID).length; i++){
                var savedSkuPriceData = this.getSkuPrices(skuID)[i].data;
                if(savedSkuPriceData.currencyCode == skuPrice.data.currencyCode &&
                   savedSkuPriceData.minQuantity == skuPrice.data.minQuantity &&
                   savedSkuPriceData.maxQuantity == skuPrice.data.maxQuantity
                ){
                    return i; 
                }
            }
        }
        return -1; 
    }
}