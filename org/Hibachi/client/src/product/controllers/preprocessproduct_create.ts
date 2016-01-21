/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class ProductCreateController{
        public collectionConfig;

        //@ngInject

        constructor(
                private $scope,
                private $element, private $log:ng.ILogService,
                private $hibachi,
                private collectionConfigService,
                private selectionService,
                private rbkeyService
        ){
            this.$log.debug('init product_create controller');
            //on select change get collection
            this.$scope.preprocessproduct_createCtrl.productTypeChanged = (selectedOption)=>{
                    this.$scope.preprocessproduct_createCtrl.selectedOption = selectedOption;
                    this.$scope.preprocessproduct_createCtrl.getCollection();
                    this.selectionService.clearSelection('ListingDisplay');
            }  
            
            this.$scope.preprocessproduct_createCtrl.getCollection = ()=>{
                    this.collectionConfig = this.collectionConfigService.newCollectionConfig('Option');
                    this.collectionConfig.setDisplayProperties('optionGroup.optionGroupName,optionName',undefined,{isVisible:true});
                    this.collectionConfig.setDisplayProperties('optionID',undefined,{isVisible:false});
                    //this.collectionConfig.addFilter('optionGroup.optionGroupID',$('input[name="currentOptionGroups"]').val(),'NOT IN')
                    this.collectionConfig.addFilter('optionGroup.globalFlag',1,'=');
                    this.collectionConfig.addFilter('optionGroup.productTypes.productTypeID',this.$scope.preprocessproduct_createCtrl.selectedOption.value,'=','OR');
                    this.collectionConfig.setOrderBy('optionGroup.sortOrder|ASC,sortOrder|ASC');
                    this.$scope.preprocessproduct_createCtrl.collectionListingPromise = this.collectionConfig.getEntity();
                    this.$scope.preprocessproduct_createCtrl.collectionListingPromise.then((data)=>{
                    this.$scope.preprocessproduct_createCtrl.collection = data;    
                    this.$scope.preprocessproduct_createCtrl.collection.collectionConfig = this.collectionConfig;
                    })
            }
            
            var renewalMethodOptions = $("select[name='renewalMethod']")[0];
            
            this.$scope.preprocessproduct_createCtrl.renewalMethodOptions = [];
            
            angular.forEach(renewalMethodOptions,(option)=>{
                    var optionToAdd = {
                            label:option.label,
                            value:option.value    
                    }
                    this.$scope.preprocessproduct_createCtrl.renewalMethodOptions.push(optionToAdd); 
            });
            
            this.$scope.preprocessproduct_createCtrl.renewalSkuChoice =  this.$scope.preprocessproduct_createCtrl.renewalMethodOptions[1];
            
            var jQueryOptionsRedemptionAmountType = $("select[name='redemptionAmountType'")[0];
            
            this.$scope.preprocessproduct_createCtrl.redemptionAmountTypeOptions = [];
            
            angular.forEach(jQueryOptionsRedemptionAmountType,(jQueryOption)=>{
                var option = {
                    label:jQueryOption.label,
                    value:jQueryOption.value    
                }
                this.$scope.preprocessproduct_createCtrl.redemptionAmountTypeOptions.push(option); 
            });
            
            this.$scope.redemptionType = this.$scope.preprocessproduct_createCtrl.redemptionAmountTypeOptions[0];
            
            var productTypeOptions = $("select[name='product.productType.productTypeID']")[0];
             
            this.$scope.preprocessproduct_createCtrl.options = [];
            
            angular.forEach(productTypeOptions,(jQueryOption)=>{
                    var option = {
                            label:jQueryOption.label,
                            value:jQueryOption.value    
                    }
                    this.$scope.preprocessproduct_createCtrl.options.push(option); 
            });
          
        }

}
export{ProductCreateController}