/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class CollectionController{
	//@ngInject
	constructor(
		$scope,
		$attrs,
		$log,
		$timeout,
		$hibachi,
		collectionService,
		metadataService,
		selectionService,
		paginationService,
		collectionConfigService,
        appConfig,
        observerService
	){
        $scope.saveCollection = (collectionData)=>{
			var data = {
				collectionID:$attrs.collectionId,
				collectionConfig:collectionData.collectionConfig
		};

		var saveCollectionPromise = $hibachi.saveEntity('Collection',$attrs.collectionId,data,'save');
			saveCollectionPromise.then(function(value){

			}, function(reason){
			});

		};
		observerService.attach($scope.saveCollection,'swPaginationUpdate',$attrs.tableId);
	}
	
}
export{
	CollectionController
}

// 'use strict';
// angular.module('slatwalladmin')
// //using $location to get url params, this will probably change to using routes eventually
// .controller('collections', [
// 	'$scope',
// '$location',
// '$log',
// '$timeout',
// '$hibachi',
// 'collectionService',
// 'metadataService',
// 'selectionService',
// 'paginationService',
// 	function(
// 		$scope,
// $location,
// $log,
// $timeout,
// $hibachi,
// collectionService,
// metadataService,
// selectionService,
// paginationService
// 	){
//
// 	}
// ]);
