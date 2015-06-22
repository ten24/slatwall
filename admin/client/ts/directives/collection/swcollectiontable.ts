'use strict';
angular.module('slatwalladmin')
.directive('swCollectionTable', [
	'$http',
	'$compile',
	'$log',
	'collectionPartialsPath',
	'paginationService',
    'selectionService',
    '$slatwall',
	function(
		$http,
		$compile,
		$log,
		collectionPartialsPath,
		paginationService,
        selectionService,
        $slatwall
	){
		return {
			restrict: 'E',
			templateUrl:collectionPartialsPath+"collectiontable.html",
			scope:{
				collection:"=",
				collectionConfig:"="
			},
			link: function(scope,element,attrs){
                scope.collectionObject = $slatwall['new'+scope.collection.collectionObject]();
				
                scope.$watch('collection.pageRecords',function(){
                    for(var record in scope.collection.pageRecords){
                        var _detailLink;
                        var _editLink;
                        
                        var _pageRecord = scope.collection.pageRecords[ record ];
                        var _objectID = _pageRecord[ scope.collectionObject.$$getIDName() ];
                        
                       _detailLink = "?slatAction=entity.detail" + scope.collection.collectionObject + "&" + scope.collectionObject.$$getIDName() + '=' + _objectID;
                       _editLink = "?slatAction=entity.edit" + scope.collection.collectionObject + "&" + scope.collectionObject.$$getIDName() + '=' + _objectID;
                        
                        _pageRecord["detailLink"] = _detailLink;
                        _pageRecord["editLink"] = _editLink;
                    }
                })
				
				
				/* 
				 * Handles setting the key on the data.
				 * */
				angular.forEach(scope.collectionConfig.columns,function(column){
					$log.debug("Config Key : " + column);
					column.key = column.propertyIdentifier.replace(/\./g, '_').replace(scope.collectionConfig.baseEntityAlias+'_','');
				});
                
                scope.addSelection = function(selectionid,selection){
                    selectionService.addSelection(selectionid,selection);
                }
				
			}
		};
	}
]);
	