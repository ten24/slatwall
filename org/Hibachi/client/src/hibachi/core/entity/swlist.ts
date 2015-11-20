class SWList{
	public static Factory(){
		var directive = (
			$log,
			$slatwall,
			partialsPath
		)=> new SWList(
			$log,
			$slatwall,
			partialsPath
		);
		directive.$inject = [
			'$log',
			'$slatwall',
			'partialsPath'
		];
		return directive;
	}
	constructor(
		$log,
		$slatwall,
		partialsPath
	){
		return {
	        restrict: 'E',
	        templateUrl:partialsPath+'entity/list.html',
	        link: function (scope, element, attr) {
	        	$log.debug('slatwallList init');
	        	
	        	scope.getCollection = function(){
	        		
	        		var pageShow = 50;
	        		if(scope.pageShow !== 'Auto'){
	        			pageShow = scope.pageShow;
	        		}
	        		scope.entityName = scope.entityName.charAt(0).toUpperCase()+scope.entityName.slice(1);
	        		var collectionListingPromise = $slatwall.getEntity(scope.entityName, {currentPage:scope.currentPage, pageShow:pageShow, keywords:scope.keywords});
	        		collectionListingPromise.then(function(value){
	        			scope.collection = value;
	        			scope.collectionConfig = angular.fromJson(scope.collection.collectionConfig);
	        		});
	        	};
	        	scope.getCollection();
	        }
	    };
	}
}
export{
	SWList
}