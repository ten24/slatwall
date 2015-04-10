'use strict';
angular.module('slatwalladmin')
.directive('swCollectionTable', [
	'$http',
	'$compile',
	'$log',
	'collectionPartialsPath',
	'paginationService',
	function(
		$http,
		$compile,
		$log,
		collectionPartialsPath,
		paginationService
	){
		return {
			restrict: 'E',
			templateUrl:collectionPartialsPath+"collectiontable.html",
			scope:{
				collection:"=",
				collectionConfig:"="
			},
			link: function(scope,element,attrs){
				
				var _collectionObject = scope.collection.collectionObject.charAt(0).toLowerCase()+scope.collection.collectionObject.slice(1) ;
				var _recordKeyForObjectID = _collectionObject + 'ID';
				$log.debug("Collection Table");
				$log.debug(_collectionObject);
				$log.debug(_recordKeyForObjectID);
				
				for(var record in scope.collection.pageRecords){
					$log.debug(record);
					$log.debug(scope.collection);
					var _detailLink;
					var _editLink;
					
					var _pageRecord = scope.collection.pageRecords[ record ];
					var _objectID = _pageRecord[ _recordKeyForObjectID ];
					
					if(_objectID && (_collectionObject !== 'country' && _collectionObject !== 'workflowTrigger')){
						$log.debug("Collection Object was:");
						$log.debug(_collectionObject); 
						_detailLink = "?slatAction=entity.detail" + _collectionObject + "&" + _collectionObject + "ID=" + _objectID;
						_editLink = "?slatAction=entity.edit" + _collectionObject + "&" + _collectionObject + "ID=" + _objectID;
						
					} else if (_collectionObject === 'country' ){
						
						_detailLink = "?slatAction=entity.detail" + _collectionObject + "&countryCode=" + _pageRecord["countryCode"];
						_detailLink = "?slatAction=entity.edit" + _collectionObject + "&countryCode=" + _pageRecord["countryCode"];
						
					}
					//Only attach _detailLink if we have a page to display so that the view can hide the buttons when null.
					if (_detailLink !== null || angular.isDefined(_detailLink)){
					_pageRecord["detailLink"] = _detailLink;
					_pageRecord["editLink"] = _editLink;
					}
				}
				
				/* 
				 * Handles setting the key on the data.
				 * */
				angular.forEach(scope.collectionConfig.columns,function(column){
					$log.debug("Config Key : ");$log.debug(column);
					column.key = column.propertyIdentifier.replace(/\./g, '_').replace(scope.collectionConfig.baseEntityAlias+'_','');
				});
				
			}
		};
	}
]);
	