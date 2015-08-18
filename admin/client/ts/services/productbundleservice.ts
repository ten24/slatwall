/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />

module slatwalladmin{
    export class ProductBundleService extends BaseService{
        public static $inject = [
            '$log','$slatwall','utilityService'
        ];
        
        constructor(private $log:ng.ILogService, private $slatwall:ngSlatwall.$slatwall, private utilityService:slatwalladmin.UtilityService){
            super();
            this.$log = $log;
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
        }
        
        public decorateProductBundleGroup = (productBundleGroup):void =>{
            productBundleGroup.data.$$editing = true;
            var prototype = {
                $$setMinimumQuantity:function(quantity) {
                    if(quantity < 0 || quantity === null ){
                        this.minimumQuantity = 0;
                    }
                    
                    if(quantity > this.maximumQuantity){
                        this.maximumQuantity = quantity;
                    } 
                    
                },
                $$setMaximumQuantity:function(quantity){
                    if(quantity < 1 || quantity === null ){
                        this.maximumQuantity = 1;
                    }
                    if(this.maximumQuantity < this.minimumQuantity){
                        this.minimumQuantity = this.maximumQuantity;
                        
                    }
                },
                $$setActive:function(value){
                    this.active=value;
                },
                $$toggleEdit:function(){
                    if(angular.isUndefined(this.$$editing) || this.$$editing === false){
                        this.$$editing = true;
                    }else{
                        this.$$editing = false;
                    }
                }
            };
            
            angular.extend(productBundleGroup.data,prototype);
        }
    
        public formatProductBundleGroupFilters = (productBundelGroupFilters,filterTerm):any =>{
            this.$log.debug('formatProductBundleGroupFilters');
            this.$log.debug(filterTerm);
            if(filterTerm.value === 'sku'){
                for(var i in productBundelGroupFilters){
                    productBundelGroupFilters[i].name = productBundelGroupFilters[i][filterTerm.value+'Code'];
                    productBundelGroupFilters[i].type = filterTerm.name;
                    productBundelGroupFilters[i].entityType = filterTerm.value;
                    productBundelGroupFilters[i].propertyIdentifier='_sku.skuID';
                }
            } else{
                for(var i in productBundelGroupFilters){
                    productBundelGroupFilters[i].name = productBundelGroupFilters[i][filterTerm.value+'Name'];
                    productBundelGroupFilters[i].type = filterTerm.name;
                    productBundelGroupFilters[i].entityType = filterTerm.value;
                    if(filterTerm.value === 'brand' || filterTerm.value === 'productType'){
                        productBundelGroupFilters[i].propertyIdentifier='_sku.product.'+filterTerm.value+'.'+filterTerm.value+'ID';
                    }else{
                        productBundelGroupFilters[i].propertyIdentifier='_sku.'+filterTerm.value+'.'+filterTerm.value+'ID';
                    }
                    
                }
            }
            
            this.$log.debug(productBundelGroupFilters);
            return productBundelGroupFilters;
        }
    }
    angular.module('slatwalladmin').service('productBundleService',ProductBundleService);
}

