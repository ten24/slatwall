//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
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
	//properties
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
		this.productBundleGroupType={
			type:null
		};
		this.$$editing=true;
	}
	
	_productBundleGroup.prototype = {
		setMinimumQuantity:function(quantity) {
			if(quantity < 0 || !angular.isNumber(quantity)){
				this.minimumQuantity = 0;
			}
			
			if(quantity > this.maximumQuantity){
				this.maximumQuantity = quantity;
			} 
			
		},
		setMaximumQuantity:function(quantity){
			if(quantity < 1 || !angular.isNumber(quantity)){
				this.maximumQuantity = 1;
			}
			if(quantity < this.minimumQuantity){
				this.minimumQuantity = quantity;
				 
			}
		},
		setActive:function(value){
			this.active=value;
		},
		toggleEdit:function(){
			if(angular.isUndefined(this.$$editing) || this.$$editing === false){
				this.$$editing = true;
			}else{
				this.$$editing = false;
			}
		}
		
	};
	
	return productBundleService = {
		newProductBundle:function(){
			return new _productBundleGroup;
		},
		newProductBundleGroupType:function(productBundleGroupType){
			return new _productBundleGroupType(productBundleGroupType);
		},
		formatProductBundleGroupFilters:function(productBundelGroupFilters,filterTerm){
			console.log('formatProductBundleGroupFilters');
			for(i in productBundelGroupFilters){
				productBundelGroupFilters[i].name = productBundelGroupFilters[i][filterTerm+'Name'];
				productBundelGroupFilters[i].type = filterTerm;
			}
			return productBundelGroupFilters;
		}
	};
}]);
