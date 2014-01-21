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
			scope.collectionObjectColumnProperties = [];
			scope.collectionObjectColumnNestedProperties = {};
			scope.collectionConfig = {};
			scope.collectionConfig.columns = [];
			
			scope.$watch('showConfig', function() {
				scope.updateConfigDisplay();
			});
			
			scope.updateConfigDisplay = function() {
				if(scope.showConfig && scope.collectionObject != '') {
					if(!scope.collectionConfig.columns.length || scope.collectionConfig.columns[ scope.collectionConfig.columns.length-1 ].propertyIdentifier != '') {
						scope.collectionConfig.columns.push( {propertyIdentifier:''} );
					}
				} else {
					for (var index in scope.collectionConfig.columns) {
						if(scope.collectionConfig.columns[index].propertyIdentifier == ''){
							scope.collectionConfig.columns.splice(index, 1);
						}
					}
				}
			}
			
			scope.getColumnPropertyOptions = function( colIndex ) {
				console.log( colIndex );
				console.log( scope.collectionObjectColumnProperties );
				
				return scope.collectionObjectColumnProperties;
			}
			
			scope.updateCollectionObject = function() {
				scope.collectionConfig.columns = [];
				scope.updateSwCollectionDisplay( 'collectionObjectChange' );
			}
			
			scope.updateColumn = function(colIndex) {
				for(var option in scope.collectionObjectColumnProperties) {
					if(scope.collectionConfig.columns[colIndex].propertyIdentifier == scope.collectionObjectColumnProperties[option].propertyIdentifier) {
						scope.collectionConfig.columns[colIndex] = scope.collectionObjectColumnProperties[option];
						break;
					}
				}
				scope.updateConfigDisplay();
				scope.updateSwCollectionDisplay( 'adjustColumn' );
			}
			
			scope.updateSwCollectionDisplay = function( updateType ) {
				
				for (var index in scope.collectionConfig.columns) {
					if(scope.collectionConfig.columns[index].propertyIdentifier == ''){
						scope.collectionConfig.columns.splice(index, 1);
					}
				}
				
				var updateData = {
					'updateType' : updateType,
					'collectionObject' : scope.collectionObject,
					'collectionID' : scope.collectionID,
					'collectionConfig': angular.toJson(scope.collectionConfig)
				};
				
				$http.post('/?slatAction=client:server.updateswcollectiondisplay', $.param(updateData)).success(function( result ){
					angular.extend(scope, result);
					scope.updateConfigDisplay();
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