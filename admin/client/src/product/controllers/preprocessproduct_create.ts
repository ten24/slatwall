/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class ProductCreateController{
        public collectionConfig;

        //@ngInject
        constructor(
                private $q, 
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

            this.$scope.productTypeIDPaths = {}; 
            
            this.$scope.preprocessproduct_createCtrl.getCollection = ()=>{
                var productTypeDeffered = this.$q.defer(); 
                var productTypePromise = productTypeDeffered.promise; 
                
                if(angular.isUndefined(this.$scope.productTypeIDPaths[this.$scope.preprocessproduct_createCtrl.selectedOption.value])){
                        var productTypeCollectionConfig = this.collectionConfigService.newCollectionConfig('ProductType');
                        productTypeCollectionConfig.addDisplayProperty('productTypeID, productTypeIDPath');
                        productTypeCollectionConfig.addFilter('productTypeID', this.$scope.preprocessproduct_createCtrl.selectedOption.value, "="); 
                        productTypeCollectionConfig.getEntity().then(
                                (result)=>{
                                      if(angular.isDefined(result.pageRecords[0])){
                                                this.$scope.productTypeIDPaths[result.pageRecords[0].productTypeID] = result.pageRecords[0].productTypeIDPath; 
                                      }
                                      productTypeDeffered.resolve(); 
                                },
                                (reason)=>{
                                      productTypeDeffered.reject(); 
                                      throw("ProductCreateController was unable to retrieve the product type ID Path.");
                                }
                        ); 
                } else {
                        productTypeDeffered.resolve(); 
                }

                productTypePromise.then(
                        ()=>{
                                var collectionConfig = this.collectionConfigService.newCollectionConfig('Option');
                                collectionConfig.setDisplayProperties('optionGroup.optionGroupName,optionName',undefined,{isVisible:true});
                                collectionConfig.setDisplayProperties('optionID',undefined,{isVisible:false});
                                //this.collectionConfig.addFilter('optionGroup.optionGroupID',$('input[name="currentOptionGroups"]').val(),'NOT IN')
                                collectionConfig.addFilter('optionGroup.globalFlag',1,'=');
                                var productTypeIDArray = this.$scope.productTypeIDPaths[this.$scope.preprocessproduct_createCtrl.selectedOption.value].split(","); 
                                for(var j = 0 ; j < productTypeIDArray.length; j++){
                                        collectionConfig.addFilter('optionGroup.productTypes.productTypeID',productTypeIDArray[j],'=','OR');
                                }
                                collectionConfig.setOrderBy('optionGroup.sortOrder|ASC,sortOrder|ASC');
                                this.$scope.preprocessproduct_createCtrl.collectionListingPromise = collectionConfig.getEntity();
                                this.$scope.preprocessproduct_createCtrl.collectionListingPromise.then((data)=>{
                                        this.$scope.preprocessproduct_createCtrl.collection = data;    
                                        this.$scope.preprocessproduct_createCtrl.collection.collectionConfig = collectionConfig;
                                });
                        },
                        ()=>{
                                throw("ProductCreateController was unable to resolve the product type.");
                        }
                )
                
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