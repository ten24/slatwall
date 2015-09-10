'use strict';

angular.module('slatwalladmin').directive('swCollectionBuilder', [
	'$http','$compile','$log','collectionPartialsPath','paginationService','$slatwall',
	
	function($http,$compile,$log,collectionPartialsPath,paginationService,$slatwall){
		return {
			restrict: 'E',
			templateUrl:collectionPartialsPath+"collectiontable.html",
			scope:{
			},
			link: function(scope,element,attrs){
				/** using build example */
                scope.productCollectionConfig = new slatwalladmin 
					.CollectionConfig($slatwall, "Product", "product") 
					.addColumn("productID",   "Product ID",  {isVisible:true, isDeletable:false, isSearchable:true, isExportable:false, ormType:'string', attributeID: '', attributeSetObject: ""})
					.addColumn("activeFlag",  "activeFlag",  {isVisible:true, isDeletable:false, isSearchable:true, isExportable:false, ormType:'string',attributeID: '', attributeSetObject: ""})
					.addColumn("urlTitle",    "urlTitle"   , {isVisible:false, isDeletable:false, isSearchable:true, isExportable:false, ormType:'string',attributeID: '', attributeSetObject: ""})
					.addColumn("productName", "productName", {isVisible:false, isDeletable:false, isSearchable:true, isExportable:false, ormType:'string',attributeID: '', attributeSetObject: ""})
					.getCollectionConfig();
				console.log("My Product Collection", scope.productCollectionConfig);
				//or
				var columnConfig = new slatwalladmin.Column()
													.setColumn("productCode")
													.setTitle("Product Code")
													.setVisible(true)
													.setOrmType('string')
													.setExportable(true).setDeletable(true).setSearchable(false)
													.setAttributeID("someAttributeID").setAttributeSetObject("sku");
													
				scope.productCollection2 = new slatwalladmin.CollectionConfig($slatwall, "Product", "product")
															.addColumn(columnConfig)
															.getCollectionConfig();
				console.log(scope.productCollection2);
			} 
		};
	}
]);
	