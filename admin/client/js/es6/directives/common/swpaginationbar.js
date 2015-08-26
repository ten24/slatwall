/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWPaginationBar {
        constructor($log, $timeout) {
            this.$log = $log;
            this.restrict = 'E';
            this.scope = {
                paginator: "=",
                collection: "=",
                getCollection: "&"
            };
            this.$inject = ['$log', '$timeout', 'partialsPath', 'paginationService'];
        }
    }
    slatwalladmin.SWPaginationBar = SWPaginationBar;
    angular.module('slatwalladmin').directive('swPaginationBar', SWPaginationBar);
})(slatwalladmin || (slatwalladmin = {}));
// angular.module('slatwalladmin')
// .directive('swPaginationBar', [
// 	'$log',
// 	'$timeout',
// 	'partialsPath', 
// 	'paginationService',
// 	function(
// 		$log,
// 		$timeout,
// 		partialsPath,
// 		paginationService
// 	){
// 		return {
// 			restrict:'E',
// 			templateUrl: partialsPath+'paginationbar.html',
// 			scope: {
// 				paginator:"=",
// 				collection:"=",
// 				getCollection:"&"
// 			},
// 			link:function(scope,element,attrs){
// 				$log.debug('pagination init');
// 	        	scope.setCurrentPage = function(currentPageNumber){
// 	        		$log.debug('setCurrentPage');
// 	        		scope.paginator.setCurrentPage(currentPageNumber);
//         			scope.getCollection();
// 	        	};
//                 scope.pageShowOptionChanged = function(selectionPageShowOption){
//                     scope.paginator.pageShowOptionChanged(selectionPageShowOption);
//                     scope.getCollection();    
//                 }
// 	        	scope.$watch('collection',function(newValue,oldValue){
// 	        		$log.debug('collection changed');
// 	        		$log.debug(newValue);
// 	        		if(angular.isDefined(newValue)){
// 	        			scope.paginator.setPageRecordsInfo(newValue.recordsCount,newValue.pageRecordsStart,newValue.pageRecordsEnd,newValue.totalPages);
// 	        			scope.paginator.totalPagesArray = [];
// 	            		for(var i = 0; i < scope.paginator.getTotalPages(); i++){
// 	            			scope.paginator.totalPagesArray.push(i+1);
// 	            		}
// 	        		}
// 	        	});
// 			}
// 		};
// 	}
// ]);

//# sourceMappingURL=../../directives/common/swpaginationbar.js.map