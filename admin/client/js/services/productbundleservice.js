'use strict';
angular.module('slatwalladmin')
.factory('productBundleService',
[
	'$log',
	'$slatwall',
	'alertService',
function(
	$log,
	$slatwall,
	alertService
){
	function _productBundleGroupType(productBundleGroupType){
		this.parentTypeID = '154dcdd2f3fd4b5ab5498e93470957b8';
		this.type=productBundleGroupType.type;
		this.systemCode=productBundleGroupType.systemCode;
		this.typeDescription=productBundleGroupType.typeDescription;
	}
		
	function _productBundleGroup(){
		this.minimumQuantity=1;
		this.maximumQuantity=1;
		this.active=true;
		this.amount=0;
		this.amountType='None',
		this.productBundleGroupType={
			type:null
		};
		this.skuCollectionConfig = {
				baseEntityName:"SlatwallSku",
				baseEntityAlias:"Sku",
				filterGroups:[]
		};
		this.$$editing=true;
	}
	
	_productBundleGroup.prototype = {
		$$setMinimumQuantity:function(quantity) {
			if(quantity < 0 || !angular.isNumber(parseInt(quantity))){
				this.minimumQuantity = 0;
			}
			
			if(quantity > this.maximumQuantity){
				this.maximumQuantity = quantity;
			} 
			
		},
		$$setMaximumQuantity:function(quantity){
			if(quantity < 1 || !angular.isNumber(parseInt(quantity))){
				this.maximumQuantity = 1;
			}
			if(quantity < this.minimumQuantity){
				this.minimumQuantity = quantity;
				 
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
	
	var productBundleService = {
		formatProductBundleGroup:function(productBundleGroup){
			var formattedProductBundleGroup = this.newProductBundle();
			
			for(key in productBundleGroup){
				formattedProductBundleGroup[key] = productBundleGroup[key];
			}
			
			$log.debug('formattedProductBundleGroup');
			$log.debug(formattedProductBundleGroup);
			return formattedProductBundleGroup;
		},
		newProductBundle:function(){
			return new _productBundleGroup;
		},
		newProductBundleGroupType:function(productBundleGroupType){
			return new _productBundleGroupType(productBundleGroupType);
		},
		formatProductBundleGroupFilters:function(productBundelGroupFilters,filterTerm){
			$log.debug('formatProductBundleGroupFilters');
			$log.debug(filterTerm);
			for(var i in productBundelGroupFilters){
				productBundelGroupFilters[i].name = productBundelGroupFilters[i][filterTerm.value+'Name'];
				productBundelGroupFilters[i].type = filterTerm.name;
			}
			$log.debug(productBundelGroupFilters);
			return productBundelGroupFilters;
		}
	};
	
	return productBundleService;
}]);
