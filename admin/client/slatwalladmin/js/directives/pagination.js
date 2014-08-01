angular.module('slatwalladmin')
.directive('swPaginationBar', function(){
	return {
		retrict:'A',
		templateUrl: '/admin/client/slatwalladmin/js/directives/partials/paginationBar.html',
		scope: {
			collection: '='
		}
	}
});
	

/*
, function($http){
	return {
		link: function(scope, element, attrs, controller) {

			// Setup the scope
			scope.showConfig = true;

			// Data
			scope.pageRecords = [];

			// Persistable Collection Data
			scope.collectionID = '';
			scope.collectionIDOptions = [];
			scope.baseEntityName = '';
			scope.baseEntityNameOptions = [];
			scope.baseEntityNameColumnProperties = [];
			scope.baseEntityNameColumnNestedProperties = {};
			scope.collectionConfig = {};
			scope.collectionConfig.columns = [];

			scope.$watch('showConfig', function() {
				scope.updateConfigDisplay();
			});
			scope.updateConfigDisplay = function() {

				if(scope.showConfig && scope.baseEntityName != '') {
					if(!scope.collectionConfig.columns.length || scope.collectionConfig.columns[ scope.collectionConfig.columns.length-1 ].propertyIdentifier != '') {
						scope.collectionConfig.columns.push( {propertyIdentifier:''} );
					}
				} else {
					if(scope.collectionConfig !== null){
						for (var index in scope.collectionConfig.columns) {
							if(scope.collectionConfig.columns[index].propertyIdentifier == ''){
								scope.collectionConfig.columns.splice(index, 1);
							}
						}
					}
				}
			}

			scope.getColumnPropertyOptions = function( colIndex ) {
				console.log( colIndex );
				console.log( scope.baseEntityNameColumnProperties );

				return scope.baseEntityNameColumnProperties;
			}

			scope.updatebaseEntityName = function() {
				scope.collectionConfig.columns = [];
				scope.updateSwCollectionDisplay( 'baseEntityNameChange' );
			}

			scope.updateColumn = function(colIndex) {
				for(var option in scope.baseEntityNameColumnProperties) {
					if(scope.collectionConfig.columns[colIndex].propertyIdentifier == scope.baseEntityNameColumnProperties[option].propertyIdentifier) {
						scope.collectionConfig.columns[colIndex] = scope.baseEntityNameColumnProperties[option];
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
					'baseEntityName' : scope.baseEntityName,
					'collectionID' : scope.collectionID,
					'collectionConfig': angular.toJson(scope.collectionConfig)
				};

				$http.post('/Slatwall/?slatAction=client:server.updateswcollectiondisplay', $.param(updateData)).success(function( result ){
					angular.extend(scope, result);
					console.log(result);
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
*/