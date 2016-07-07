export class SkuPriceService { 

    private currencies = {}; 
    private skuPrices = {};
    private skuPriceCollectionConfigs = {}; 
    private skuPriceGetEntityPromises = {}; 
    private skuPriceHasEntityDeferred = {}; 
    private skuPriceHasEntityPromises = {}; 

    //@ngInject
    constructor(public $http,
                public $q, 
                public $hibachi,
                public cacheService,
                public collectionConfigService, 
                public observerService,
                public utilityService
    ){
         this.observerService.attach(this.updateSkuPrices,'skuPricesUpdate');
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

    //wrapper function to split up args
    public updateSkuPrices = (args) =>{
        this.loadSkuPricesForSku(args.skuID, args.refresh); 
    }

    public loadSkuPricesForSku = (skuID, refresh?) =>{
        this.skuPriceHasEntityDeferred[skuID] = this.$q.defer();
        this.skuPriceHasEntityPromises[skuID] = this.skuPriceHasEntityDeferred[skuID].promise;
        if(angular.isUndefined(this.skuPriceCollectionConfigs[skuID])){
            this.skuPriceCollectionConfigs[skuID] = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
            this.skuPriceCollectionConfigs[skuID].addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price");
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
                angular.forEach(response.records,(value,key)=>{
                    this.setSkuPrices(skuID, [this.$hibachi.populateEntity("SkuPrice", value)]);
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
        var currencyRatePromise = this.$http({
                method:"POST", 
                url:this.$hibachi.getUrlWithActionPrefix()+"api:main.getcurrencyrates"
        })
        currencyRatePromise.then(
            (response)=>{
                console.log("currr",response);
                this.currencies = response.data;
                loadCurrenciesDeferred.resolve(this.currencies); 
            },
            (reason)=>{
                loadCurrenciesDeferred.reject(reason);
            }
        );
        return loadCurrenciesPromise        
    }

    private createInferredSkuPriceForCurrency = (sku, currencyCode, minQuantity?, maxQuantity?) =>{
        var nonPersistedSkuPrice = this.$hibachi.newSkuPrice(); 
        nonPersistedSkuPrice.$$setSku(sku);
        nonPersistedSkuPrice.data.currencyCode = currencyCode; 
        if(angular.isDefined(this.currencies[currencyCode]) && sku.data.currencyCode != currencyCode){
            var currencyData = this.currencies[currencyCode];
            if(currencyData.CONVERTFROM == sku.data.currencyCode){
                nonPersistedSkuPrice.data.price = sku.data.price * (1 / currencyData.CONVERSIONRATE);
            } else if(this.currencies["USD"].CONVERTFROM == "EUR"){
                //not getting hit right now
                console.log("need to convert from euro");
                
            }
        } else if (sku.data.currencyCode == currencyCode) {
            nonPersistedSkuPrice.data.price = sku.data.price;
        } else { 
            nonPersistedSkuPrice.data.price = "N/A";//will become NaN
        }
        if(angular.isDefined(minQuantity)){
            nonPersistedSkuPrice.data.minQuantity = minQuantity;
        }
        if(angular.isDefined(maxQuantity)){
            nonPersistedSkuPrice.data.maxQuantity = maxQuantity;
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

    private loadInferredSkuPricesForSkuPriceSet = (skuID, skuPriceSet, eligibleCurrencyCodes) =>{
        var deferred = this.$q.defer(); 
        var promise = deferred.promise; 
        this.loadCurrencies().then(
            ()=>{
                this.$hibachi.getEntity("Sku", skuID).then(
                    (response)=>{
                        var sku = this.$hibachi.populateEntity("Sku", response);
                        for(var j=0; j < eligibleCurrencyCodes.length; j++){
                            if( ( sku.data.currencyCode != eligibleCurrencyCodes[j]) &&
                                ( skuPriceSet.length > 0 && !this.skuPriceSetHasCurrencyCode(skuPriceSet,eligibleCurrencyCodes[j]) ) ||
                                  skuPriceSet.length == 0
                            ){
                                skuPriceSet.push(this.createInferredSkuPriceForCurrency(sku,eligibleCurrencyCodes[j]));
                            }
                        }
                        skuPriceSet = this.sortSkuPrices(skuPriceSet);
                    },
                    (reason)=>{
                        deferred.reject(reason);
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
                            deferred.resolve(data); 
                        }
                    );
                } else {
                    deferred.resolve(skuPriceSet); 
                }   
            });
        }
        return promise; 
    }

    public getSkuPricesForQuantityRange = (skuID, minQuantity, maxQuantity, eligibleCurrencyCodes?) => {
        var deferred = this.$q.defer(); 
        var promise = deferred.promise; 
        var skuPriceSet = []; 
        if(angular.isDefined(this.skuPriceHasEntityPromises[skuID])){
            this.skuPriceGetEntityPromises[skuID].then(()=>{
                var skuPrices = this.getSkuPrices(skuID);
                for(var i=0; i < skuPrices.length; i++){
                    var skuPrice = skuPrices[i];
                    if( parseInt(skuPrice.data.minQuantity) == parseInt(minQuantity) &&
                        parseInt(skuPrice.data.maxQuantity) == parseInt(maxQuantity)
                    ){
                        skuPriceSet.push(skuPrice);
                    }
                }
                skuPriceSet = this.sortSkuPrices(skuPriceSet);
            }).finally(()=>{
                if(angular.isDefined(eligibleCurrencyCodes)){
                    this.loadInferredSkuPricesForSkuPriceSet(skuID, skuPriceSet, eligibleCurrencyCodes).then(
                        (data)=>{
                            deferred.resolve(data); 
                        }
                    );
                } else {
                    deferred.resolve(skuPriceSet); 
                }  
            });
        }
        return promise; 
    }

    public getKeyOfSkuPriceMatch = (skuID, skuPrice) =>{
        if(this.hasSkuPrices(skuID)){
            for(var i=0; i < this.getSkuPrices(skuID).length; i++){
                var savedSkuPriceData = this.getSkuPrices(skuID)[i].data;
                if( savedSkuPriceData.currencyCode == skuPrice.data.currencyCode &&
                    ( this.isBaseSkuPrice(savedSkuPriceData) ||
                        ( parseInt(savedSkuPriceData.minQuantity) == parseInt(skuPrice.data.minQuantity) &&
                          parseInt(savedSkuPriceData.maxQuantity) == parseInt(skuPrice.data.maxQuantity))
                    )
                ){
                    return i; 
                }
            }
        }
        return -1; 
    }

    private isBaseSkuPrice = (skuPriceData)=>{
         return (angular.isUndefined(skuPriceData.minQuantity) || (angular.isString(skuPriceData.minQuantity) && skuPriceData.minQuantity.trim().length == 0)) &&
                (angular.isUndefined(skuPriceData.maxQuantity) || (angular.isString(skuPriceData.maxQuantity) && skuPriceData.maxQuantity.trim().length == 0));
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