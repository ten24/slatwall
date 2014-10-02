//collection service is used to maintain the state of the ui

angular.module('slatwalladmin.services')
.factory('productBundleService',['$log',
function($log){
	//properties
	var _productBundle = null;
	
	return productBundleService = {
			
		getProductBundle: function(){
			return _collection;
		},
		setProductBundle: function(productBundle){
			_productBundle = productBundle;
		}
		//private functions
		
	};
}]);
