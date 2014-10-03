//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('productBundleService',['$log',
function($log){
	//properties
	var _productBundle = null;
	var _newProductBundle = {
		minimumQuantity:1,
		maximumQuantity:1,
		active:true,
		productBundleGroupType:{
			typeName:null
		}
	};
	
	return productBundleService = {
			
		getProductBundle: function(){
			return _collection;
		},
		setProductBundle: function(productBundle){
			_productBundle = productBundle;
		},
		newProductBundle:function(){
			
			return _newProductBundle;
		}
		
		//private functions
		
	};
}]);
