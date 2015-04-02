'use strict';

angular.module('slatwalladmin')
.directive('swContentList', [
	'$log',
	'$slatwall',
	'partialsPath',
	function (
			$log,
			$slatwall,
			partialsPath
	) {
	    return {
	        restrict: 'E',
	        templateUrl:partialsPath+'content/contentlist.html',
	        link: function (scope, element, attr) {
	        	$log.debug('slatwallcontentList init');
	        	
	        	
	        	scope.getCollection = function(){
	        		
	        		var pageShow = 50;
	        		if(scope.pageShow !== 'Auto'){
	        			pageShow = scope.pageShow;
	        		}
	        		
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
]);