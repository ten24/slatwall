/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class SkuPriceService { 

    private currencies:{}; 
    private skuPrices = {};
    private skuPriceCollectionConfigs = {}; 
    private skuPriceGetEntityPromises = {};
    private skuDictionary = {};  
    private skuPriceHasEntityDeferred = {}; 
    private skuPriceHasEntityPromises = {}; 

    //@ngInject
    constructor(public $http,
                public $q, 
                public $hibachi,
                public entityService,
                public cacheService,
                public collectionConfigService, 
                public observerService,
                public utilityService
    ){
         this.observerService.attach(this.updateSkuPrices,'skuPricesUpdate');
    }

    public newSkuPrice = () =>{
        return this.entityService.newEntity('SkuPrice');
    }

    public getRelatedSkuPriceCollectionConfig = (skuID,currencyCode,minQuantity,maxQuantity) =>{
        var relatedSkuPriceCollectionConfig = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
        relatedSkuPriceCollectionConfig.addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price,priceGroup.priceGroupID");
        relatedSkuPriceCollectionConfig.addFilter("minQuantity",minQuantity,"=");
        relatedSkuPriceCollectionConfig.addFilter("maxQuantity",maxQuantity,"=");
        relatedSkuPriceCollectionConfig.addFilter("currencyCode",currencyCode,"!=");
        relatedSkuPriceCollectionConfig.addFilter("sku.skuID",skuID,"=");
        relatedSkuPriceCollectionConfig.addOrderBy("currencyCode|asc");
        relatedSkuPriceCollectionConfig.setAllRecords(true);
        return relatedSkuPriceCollectionConfig;
    }

    //wrapper function to split up args
    public updateSkuPrices = (args) =>{
        this.loadSkuPricesForSku(args.skuID, args.refresh); 
    }

    public loadSkuPricesForSku = (skuID, refresh?) =>{
        this.skuPriceHasEntityDeferred[skuID] = this.$q.defer();
        this.skuPriceHasEntityPromises[skuID] = this.skuPriceHasEntityDeferred[skuID].promise;
        if(angular.isUndefined(this.skuPriceCollectionConfigs[skuID])){
            this.skuPriceCollectionConfigs[skuID] = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
            //get info to compare for line items
            this.skuPriceCollectionConfigs[skuID].addDisplayProperty("skuPriceID,minQuantity,maxQuantity,currencyCode,price,sku.skuID,priceGroup.priceGroupID,priceGroup.priceGroupCode");
            this.skuPriceCollectionConfigs[skuID].addFilter("sku.skuID",skuID,"=");
            this.skuPriceCollectionConfigs[skuID].addOrderBy("currencyCode|asc");
            this.skuPriceCollectionConfigs[skuID].setAllRecords(true);
        }
        if(angular.isUndefined(this.skuPriceGetEntityPromises[skuID]) || refresh){
            this.skuPriceGetEntityPromises[skuID] = this.skuPriceCollectionConfigs[skuID].getEntity(); 
            refresh = true; 
        }
        if(refresh){
            this.skuPriceGetEntityPromises[skuID].then( (response) => {
                angular.forEach(response.records, (value, key)=>{
                    var skuPrice = this.$hibachi.populateEntity("SkuPrice", value);
                    var priceGroup = this.$hibachi.populateEntity('PriceGroup',{priceGroupID:value.priceGroup_priceGroupID,priceGroupCode:value.priceGroup_priceGroupCode});
                    skuPrice.$$setPriceGroup(priceGroup);
                    var skuPrices = [skuPrice];
                    this.setSkuPrices(skuID, skuPrices);
                }); 
            },
            (reason) => {
                this.skuPriceHasEntityPromises[skuID].reject(); 
                throw("skupriceservice failed to get sku prices" + reason);
            }).finally( () => {
                this.skuPriceHasEntityPromises[skuID].resolve(); 
            });
        }
        return this.skuPriceGetEntityPromises[skuID];
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

    public loadCurrencies = () =>{
        var loadCurrenciesDeferred = this.$q.defer(); 
        var loadCurrenciesPromise = loadCurrenciesDeferred.promise;
        if(angular.isDefined(this.currencies)){
            loadCurrenciesDeferred.resolve(this.currencies); 
        } else {
            var currencyRatePromise = this.$http({
                    method:"POST", 
                    url:this.$hibachi.getUrlWithActionPrefix()+"api:main.getcurrencyrates"
            })
            currencyRatePromise.then(
                (response)=>{
                    this.currencies = response.data;
                    loadCurrenciesDeferred.resolve(this.currencies); 
                },
                (reason)=>{
                    loadCurrenciesDeferred.reject(reason);
                }
            );
        }
        return loadCurrenciesPromise        
    }

    //logic for inferred currency prices
    public getInferredSkuPrice = (sku, basePrice, currencyCode) =>{
         if(angular.isDefined(this.currencies[currencyCode]) && sku.data.currencyCode != currencyCode){
            
            var currencyData = this.currencies[currencyCode];
            if(currencyData.CONVERTFROM == sku.data.currencyCode){
                return basePrice * (currencyData.CONVERSIONRATE);
            } else if(currencyData.CONVERTFROM == "EUR" && this.currencies[sku.data.currencyCode].CONVERTFROM == "EUR") {
                //Convert using euro
                var tempPrice =  basePrice * (currencyData.CONVERSIONRATE);
                return tempPrice * (this.currencies[sku.data.currencyCode].CONVERSIONRATE); 
            } else {
                return "N/A";//will become NaN
            }

        } else if (sku.data.currencyCode == currencyCode) {
            return basePrice;
        } 
        return "N/A";//will become NaN
    }

    private createInferredSkuPriceForCurrency = (sku, skuPrice, currencyCode) =>{
        var nonPersistedSkuPrice = this.entityService.newEntity('SkuPrice'); 
        nonPersistedSkuPrice.$$setSku(sku);
        nonPersistedSkuPrice.data.currencyCode = currencyCode; 
        //if for some reason the price that came back was preformatted althought this really shouldn't be needed
        if(angular.isString(sku.data.price) && isNaN(parseFloat(sku.data.price.substr(0,1)))){
            //strip currency symbol
            sku.data.price = parseFloat(sku.data.price.substr(1,sku.data.price.length));
        }
        var basePrice = 0; 
        if(angular.isDefined(skuPrice)){
            basePrice = skuPrice.data.price;
        } else {
            basePrice = sku.data.price; 
        }

        nonPersistedSkuPrice.data.price = this.getInferredSkuPrice(sku,basePrice,currencyCode); 
       
        if(angular.isDefined(skuPrice) && angular.isDefined(skuPrice.data.minQuantity) && !isNaN(skuPrice.data.minQuantity)){
            nonPersistedSkuPrice.data.minQuantity = skuPrice.data.minQuantity;
        }
        if(angular.isDefined(skuPrice) && angular.isDefined(skuPrice.data.maxQuantity) && !isNaN(skuPrice.data.maxQuantity)){
            nonPersistedSkuPrice.data.maxQuantity = skuPrice.data.maxQuantity;
        }
        nonPersistedSkuPrice.data.inferred = true; 
        return nonPersistedSkuPrice;
    }

    private skuPriceSetHasCurrencyCode = (skuPriceSet, currencyCode)=>{
        for(var k=0; k < skuPriceSet.length; k++){
            if(currencyCode == skuPriceSet[k].data.currencyCode){
                return true;
            }
        }
        return false; 
    }

    private defaultCurrencySkuPriceForSet = (skuPriceSet)=>{
        for(var i = 0; i < skuPriceSet.length; i++){
            //temporarily hard coded
            if(skuPriceSet[i].data.currencyCode == "USD"){
                return skuPriceSet[i]; 
            }
        }
    }

    private getSku = (skuID) =>{
        var deferred = this.$q.defer(); 
        var promise = deferred.promise; 
        if(skuID in this.skuDictionary){
            var sku = this.skuDictionary[skuID];
            deferred.resolve(sku);
        } else {
            this.$hibachi.getEntity("Sku", skuID).then(
                (response)=>{
                    this.skuDictionary[skuID] = this.$hibachi.populateEntity("Sku", response);
                    deferred.resolve(this.skuDictionary[skuID]);
                },
                (reason)=>{
                    deferred.reject(reason);
                }
            );
        }
        return promise;
    }

    private loadInferredSkuPricesForSkuPriceSet = (skuID, skuPriceSet, eligibleCurrencyCodes) =>{
        var deferred = this.$q.defer(); 
        var promise = deferred.promise; 
        this.loadCurrencies().then(
            ()=>{
                this.getSku(skuID).then(
                    (sku)=>{
                        for(var j=0; j < eligibleCurrencyCodes.length; j++){
                            if( ( sku.data.currencyCode != eligibleCurrencyCodes[j]) &&
                                ( skuPriceSet.length > 0 && !this.skuPriceSetHasCurrencyCode(skuPriceSet,eligibleCurrencyCodes[j]) ) ||
                                ( ( sku.data.currencyCode != eligibleCurrencyCodes[j]) && skuPriceSet.length == 0)
                            ){
                                skuPriceSet.push(this.createInferredSkuPriceForCurrency(sku,this.defaultCurrencySkuPriceForSet(skuPriceSet),eligibleCurrencyCodes[j]));
                            }
                        }
                        skuPriceSet = this.sortSkuPrices(skuPriceSet);
                    },
                    (reason)=>{

                    }
                ).finally(
                    ()=>{
                        deferred.resolve(skuPriceSet)
                    }
                );
            }
        );
        return promise; 
    }

    public getBaseSkuPricesForSku = (skuID, eligibleCurrencyCodes?) =>{
        var deferred = this.$q.defer(); 
        var promise = deferred.promise; 
        var skuPriceSet = [];
        if(angular.isDefined(this.skuPriceHasEntityPromises[skuID])){
            this.skuPriceGetEntityPromises[skuID].then(()=>{
                var skuPrices = this.getSkuPrices(skuID) || [];
                for(var i=0; i < skuPrices.length; i++){
                    var skuPrice = skuPrices[i];
                    if( this.isBaseSkuPrice(skuPrice.data)
                    ){
                        skuPriceSet.push(skuPrice);
                    }
                }
            }).finally(()=>{   
                if(angular.isDefined(eligibleCurrencyCodes)){
                    this.loadInferredSkuPricesForSkuPriceSet(skuID, skuPriceSet, eligibleCurrencyCodes).then(
                        (data)=>{
                            deferred.resolve(this.sortSkuPrices(data)); 
                        }
                    );
                } else {
                    deferred.resolve(this.sortSkuPrices(skuPriceSet)); 
                }   
            });
        }
        return promise; 
    }

    public getSkuPricesForQuantityRange = (skuID, minQuantity, maxQuantity, eligibleCurrencyCodes?,priceGroupID?) => {
        var deferred = this.$q.defer(); 
        var promise = deferred.promise; 
        var skuPriceSet = []; 
        if(angular.isDefined(this.skuPriceHasEntityPromises[skuID])){
            this.skuPriceGetEntityPromises[skuID].then(()=>{
                var skuPrices = this.getSkuPrices(skuID);
                for(var i=0; i < skuPrices.length; i++){
                    var skuPrice = skuPrices[i];
                    if( 
                        this.isQuantityRangeSkuPrice(skuPrice.data, minQuantity, maxQuantity,priceGroupID)
                    ){
                        skuPriceSet.push(skuPrice);
                    }
                }
            }).finally(()=>{
                if(angular.isDefined(eligibleCurrencyCodes)){
                    this.loadInferredSkuPricesForSkuPriceSet(skuID, skuPriceSet, eligibleCurrencyCodes).then(
                        (data)=>{
                            deferred.resolve(this.sortSkuPrices(data)); 
                        }
                    );
                } else {
                    deferred.resolve(this.sortSkuPrices(skuPriceSet)); 
                }  
            });
        }
        return promise; 
    }

    public getKeyOfSkuPriceMatch = (skuID, skuPrice) =>{
        if(this.hasSkuPrices(skuID)){
            for(var i=0; i < this.getSkuPrices(skuID).length; i++){
                var savedSkuPriceData = this.getSkuPrices(skuID)[i].data; 
                var priceGroupID = undefined;
                if(skuPrice.data.priceGroup){
                    priceGroupID = skuPrice.data.priceGroup.$$getID() || skuPrice.data.priceGroup_priceGroupID;
                }
                
                if( savedSkuPriceData.currencyCode == skuPrice.data.currencyCode &&
                    ( ( this.isBaseSkuPrice(savedSkuPriceData) &&
                        this.isBaseSkuPrice(savedSkuPriceData) == this.isBaseSkuPrice(skuPrice.data) 
                      ) || this.isQuantityRangeSkuPrice(savedSkuPriceData, skuPrice.data.minQuantity, skuPrice.data.maxQuantity,priceGroupID)
                    )
                ){
                    return i; 
                }
            }
        }
        return -1; 
    }

    private isBaseSkuPrice = (skuPriceData)=>{
        return isNaN(parseInt(skuPriceData.minQuantity)) && isNaN(parseInt(skuPriceData.maxQuantity)) && !(skuPriceData.priceGroup && skuPriceData.priceGroup.$$getID().trim().length);
    }

    private isQuantityRangeSkuPrice = (skuPriceData, minQuantity, maxQuantity, priceGroupID) =>{
         var minQuantityMatch = (parseInt(skuPriceData.minQuantity) == parseInt(minQuantity)) 
            || (
                isNaN(parseInt(skuPriceData.minQuantity)) 
                && isNaN(parseInt(minQuantity))
            ); 
         var maxQuantityMatch = (
                parseInt(skuPriceData.maxQuantity) == parseInt(maxQuantity)
            )|| (
                isNaN(parseInt(skuPriceData.maxQuantity)) 
                && isNaN(parseInt(maxQuantity))
            );
            
            var priceGroupMatch = false;
            
            if(typeof priceGroupID !== 'undefined' && typeof skuPriceData.priceGroup_priceGroupID !== 'undefined'){
                
                if(skuPriceData.priceGroup_priceGroupID.length){
                    priceGroupMatch = skuPriceData.priceGroup_priceGroupID == priceGroupID
                }else{
                    skuPriceData.priceGroup_priceGroupID == priceGroupID
                }
            }else{
                if(typeof priceGroupID=='undefined'
                && typeof skuPriceData.priceGroup_priceGroupID == 'undefined'){
                    priceGroupMatch = true;
                }else{
                    priceGroupMatch = false;
                }
            }
            
         return minQuantityMatch && maxQuantityMatch && priceGroupMatch;
    }

    public sortSkuPrices = (skuPriceSet)=>{
        function compareSkuPrices(a,b) {
            //temporarily hardcoded to usd needs to be default sku value
            if (a.data.currencyCode == "USD") 
                return -1;
            if (a.data.currencyCode < b.data.currencyCode)
                return -1; 
            if (a.data.currencyCode > b.data.currencyCode)
                return 1;
            return 0;
        }
        return skuPriceSet.sort(compareSkuPrices);
    }
}
