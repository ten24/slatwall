export class SkuPriceService { 

    private skuPrices = {};

    //@ngInject
    constructor(public $hibachi,
                public observerService
    ){
    }

    public setSkuPrices = (skuID, skuPrices) => { 
        if(angular.isDefined(this.skuPrices[skuID])){
            for(var i=0; i < skuPrices.length; i++){
                if(this.getKeyOfSkuPriceMatch(skuID, skuPrices[i]) != -1){
                    this.getSkuPrices(skuID)[i].data.price = skuPrices[i].data.price; 
                    skuPrices.splice(i, 1);
                }
            }
            this.skuPrices[skuID] = this.skuPrices[skuID].concat(skuPrices);
        } else {
            this.skuPrices[skuID] = skuPrices; 
        }
    };

    public getSkuPrices = (skuID) =>{
        if(angular.isDefined(this.skuPrices[skuID])){
            return this.skuPrices[skuID];
        }
    }

    public getKeyOfSkuPriceMatch = (skuID, skuPrice) =>{
        if(angular.isDefined(this.skuPrices[skuID])){
            for(var i=0; i < this.getSkuPrices(skuID).length; i++){
                var savedSkuPriceData = this.getSkuPrices(skuID)[i].data;
                if(savedSkuPriceData.currencyCode == skuPrice.data.currencyCode &&
                   savedSkuPriceData.minQuantity == skuPrice.data.minQuantity &&
                   savedSkuPriceData.maxQuantity == skuPrice.data.minQuantity
                ){
                    return i; 
                }
            }
        }
        return -1; 
    }
}