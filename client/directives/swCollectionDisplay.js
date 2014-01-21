slatwall.directive('swCollectionDisplay', function($http){
	return {
		link: function(scope, element, attrs, controller) {
			
			// Setup the scope
			scope.showConfig = true;
			
			// Data
			scope.pageRecords = [];
			
			// Persistable Collection Data
			scope.collectionID = '';
			scope.collectionIDOptions = [];
			scope.collectionObject = '';
			scope.collectionObjectOptions = [];
			scope.collectionConfig = {};
			scope.collectionConfig.columns = [];
			
			scope.updateSwCollectionDisplay = function( updateType ) {
				var updateData = {
					'updateType' : updateType,
					'collectionObject' : scope.collectionObject,
					'collectionID' : scope.collectionID,
					'collectionConfig': angular.toJson(scope.collectionConfig)
				};
				
				$http.post('/?slatAction=client:server.updateswcollectiondisplay', $.param(updateData)).success(function( result ){
					angular.extend(scope, result);
				});
			};
			
			// Fire off initial update from Server
			scope.updateSwCollectionDisplay( 'init' );

		},
		scope: {
			linkitup: "="
		}
	}
});