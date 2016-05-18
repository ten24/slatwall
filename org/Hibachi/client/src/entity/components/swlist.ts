/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWList{
	public static Factory(){
		var directive = (
			$log,
			$hibachi,
			coreEntityPartialsPath,
			hibachiPathBuilder
		)=> new SWList(
			$log,
			$hibachi,
			coreEntityPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'coreEntityPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		coreEntityPartialsPath,
			hibachiPathBuilder
	){
		return {
	        restrict: 'E',
	        templateUrl:hibachiPathBuilder.buildPartialsPath(coreEntityPartialsPath)+'/list.html',
	        link: function (scope, element, attr) {
	        	$log.debug('slatwallList init');

	        	//scope.getCollection = function(){
                //
	        	//	var pageShow = 50;
	        	//	if(scope.pageShow !== 'Auto'){
	        	//		pageShow = scope.pageShow;
	        	//	}
	        	//	scope.entityName = scope.entityName.charAt(0).toUpperCase()+scope.entityName.slice(1);
	        	//	var collectionListingPromise = $hibachi.getEntity(scope.entityName, {currentPage:scope.currentPage, pageShow:pageShow, keywords:scope.keywords});
	        	//	collectionListingPromise.then(function(value){
	        	//		scope.collection = value;
	        	//		scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
	        	//	});
	        	//};
	        	//scope.getCollection();
	        }
	    };
	}
}
export{
	SWList
}