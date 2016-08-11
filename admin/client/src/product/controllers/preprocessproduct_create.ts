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
            //on select change get collection
            this.$scope.preprocessproduct_createCtrl.productTypeChanged = (selectedOption)=>{
                    this.$scope.preprocessproduct_createCtrl.selectedOption = selectedOption;
                    this.$scope.preprocessproduct_createCtrl.getCollection();
                    this.selectionService.clearSelection('ListingDisplay');
            }  
            
            this.$scope.preprocessproduct_createCtrl.getCollection = ()=>{
                var collectionConfig = this.collectionConfigService.newCollectionConfig('Option');
                collectionConfig.setDisplayProperties('optionGroup.optionGroupName,optionName',undefined,{isVisible:true});
                collectionConfig.setDisplayProperties('optionID',undefined,{isVisible:false});
                //this.collectionConfig.addFilter('optionGroup.optionGroupID',$('input[name="currentOptionGroups"]').val(),'NOT IN')
                collectionConfig.addFilter('optionGroup.globalFlag',1,'=');
                collectionConfig.addFilter('optionGroup.productTypes.productTypeID',this.$scope.preprocessproduct_createCtrl.selectedOption.value,'=','OR');
                collectionConfig.setOrderBy('optionGroup.sortOrder|ASC,sortOrder|ASC');
                this.$scope.preprocessproduct_createCtrl.collectionListingPromise = collectionConfig.getEntity();
                this.$scope.preprocessproduct_createCtrl.collectionListingPromise.then((data)=>{
                    this.$scope.preprocessproduct_createCtrl.collection = data;    
                    this.$scope.preprocessproduct_createCtrl.collection.collectionConfig = collectionConfig;
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
            
            
            var productTypeOptions = $("select[name='product.productType.productTypeID']")[0];
             
            this.$scope.preprocessproduct_createCtrl.options = [];
            
            angular.forEach(productTypeOptions,(jQueryOption)=>{
                    var option = {
                            label:jQueryOption.label,
                            value:jQueryOption.value    
                    }
                    this.$scope.preprocessproduct_createCtrl.options.push(option); 
            });
            
            this.$scope.preprocessproduct_createCtrl.selectedOption = {};
            
            if(angular.isDefined(this.$scope.preprocessproduct_createCtrl.options[0]) && angular.isDefined(this.$scope.preprocessproduct_createCtrl.options[0].value)){
                this.$scope.preprocessproduct_createCtrl.selectedOption.value = this.$scope.preprocessproduct_createCtrl.options[0].value;
            } else {
                this.$scope.preprocessproduct_createCtrl.selectedOption.value = "";
            }
          
        }

}
export{ProductCreateController}