slatwall.directive('swCollectionDisplay', function($http){
	return {
		link: function(scope, element, attrs, controller) {
			
			console.log(scope);
			console.log(attrs);
			
			$http.get('/?slatAction=admin:ajax.swcollectiondisplay&collectionID=402881c140e4ce650140e554997d000a').success(function( result ){
				scope.collection = result;
			});
			
			// addFilter
			// removeFilter
			// addLikeFilter
			// removeLikeFilter
			// addInFilter
			// removeInFilter
			// addColumn
			// removeColumn
			// globalSearch
			// update
			//
			
			scope.addFilter = function(){
				console.log('addFilter clicked');
			};
			
			/*
			scope.propertyIdentifiers = {
				'productName': {'header': 'Product Name'},
				'productCode': {'header': 'Product Code'}
			}
			
			scope.pageRecords = [{'productName':'Air Jordan','productCode':'AJ1000'},{'productName':'Simple Green','productCode':'SG1000'}];
			
			scope.testing = [1,2,3];
			element[0].cool = ['a','b','c'];
			*/
		},
		scope: {
			linkitup: "="
		}
	}
});