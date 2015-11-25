module slatwalladmin {
        'use strict';
	
	
	export class ProductCreateController{
                
                
                public static $inject=["$scope",'$element','$log', "$slatwall","collectionConfigService","selectionService"];        
        
                constructor(
                        private $scope: IOrderItemGiftRecipientScope, 
                        private $element, private $log:ng.ILogService,  
                        private $slatwall:ngSlatwall.$Slatwall, 
                        private collectionConfigService,
                        private selectionService
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
                                this.collectionConfig.addDisplayProperty('optionID',undefined,{isVisible:false});
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
                        
                        this.$scope.preprocessproduct_createCtrl.rskuOptions = [
                                {
                                        label:this.$slatwall.getRBKey('admin.entity.processproduct.create.selectRenewalSku'),
                                        value:'rsku'
                                },
                                {
                                        label:this.$slatwall.getRBKey('admin.entity.processproduct.create.selectCustomRenewal'),
                                        value:'custom'
                                }
                        ];
                        //
                        this.$scope.preprocessproduct_createCtrl.rskuChoice = this.$scope.preprocessproduct_createCtrl.rskuOptions[0];
                        
                        var jQueryOptions = $("select[name='product.productType.productTypeID']")[0];
                        this.$scope.preprocessproduct_createCtrl.options = [];
                        if(jQueryOptions > 1){
                                this.$scope.preprocessproduct_createCtrl.options.push({label:this.$slatwall.getRBKey('processObject.Product_Create.selectProductType'),value:""})
                        }
                        angular.forEach(jQueryOptions,(jQueryOption)=>{
                                var option = {
                                        label:jQueryOption.label,
                                        value:jQueryOption.value    
                                }
                                this.$scope.preprocessproduct_createCtrl.options.push(option); 
                        });
                        this.$scope.preprocessproduct_createCtrl.productTypeChanged(this.$scope.preprocessproduct_createCtrl.options[0]);
                }
        
	}
	
	angular.module('slatwalladmin').controller('preprocessproduct_create', ProductCreateController);

}
