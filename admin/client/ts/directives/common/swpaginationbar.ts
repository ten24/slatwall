angular.module('slatwalladmin')
.directive('swPaginationBar', [
	'$log',
	'$timeout',
	'partialsPath', 
	'paginationService',
	function(
		$log,
		$timeout,
		partialsPath,
		paginationService
	){
		return {
			restrict:'A',
			templateUrl: partialsPath+'paginationbar.html',
			scope: {
				pageShow:"=",
				currentPage:"=",
				pageStart:"&",
				pageEnd:"&",
                pageShowOptions:"=?",
				recordsCount:"&",
				collection:"=",
				autoScroll:"=",
				getCollection:"&",
				paginationId:"="
			},
			link:function(scope,element,attrs){
				$log.debug('pagination init');
				scope.totalPagesArray = [];
				scope.hasPrevious = paginationService.hasPrevious;
				scope.hasNext = paginationService.hasNext;
				scope.totalPages = paginationService.getTotalPages;
				
                if(angular.isUndefined(scope.pageShowOptions)){
                    scope.pageShowOptions = paginationService.getPageShowOptions(scope.paginationId);

                }
				
				scope.pageShowOptions.selectedPageShowOption = scope.pageShowOptions[0];
	          	
	          	scope.pageShowOptionChanged = function(pageShowOption){
	          		$log.debug('pageShowOptionChanged');
	          		$log.debug(pageShowOption);
	      			paginationService.setPageShow(scope.paginationId, pageShowOption.value);
	        		scope.pageShow = paginationService.getPageShow(scope.paginationId);
	        		scope.currentPage = 1;
					scope.setCurrentPage(1);
	        	};
	        	
	        	/*var unbindPageOptionsWatchListener = scope.$watch('pageOptions',function(newValue,oldValue){
	    			 $("select").selectBoxIt();
	        		 unbindPageOptionsWatchListener();
	        	});*/
	        	
	        	scope.setCurrentPage = function(currentPageNumber){
	        		$log.debug('setCurrentPage');
                   
	        		paginationService.setCurrentPage(scope.paginationId, currentPageNumber);
	        		scope.currentPage = paginationService.getCurrentPage(scope.paginationId);
	        			        	 $log.debug(paginationService.getCurrentPage(scope.paginationId));
	        		$timeout(function(){
	        			
	        			
	        			scope.getCollection();
	        		});
	        		
	        	};
	        	
	        	var setPageRecordsInfo = function(recordsCount,pageStart,pageEnd,totalPages){
	    			paginationService.setRecordsCount(scope.paginationId, recordsCount);
	    			if(paginationService.getRecordsCount(scope.paginationId) === 0 ){
	    				paginationService.setPageStart(scope.paginationId, 0);
	    			} else{
	    				paginationService.setPageStart(scope.paginationId, pageStart);
	    			}
	    			paginationService.setPageEnd(scope.paginationId, pageEnd);
	    			paginationService.setTotalPages(scope.paginationId, totalPages);
	    		};
	        	
	        	scope.$watch('collection',function(newValue,oldValue){
	        		$log.debug('collection changed');
	        		$log.debug(newValue);
	        		if(angular.isDefined(newValue)){
	        			setPageRecordsInfo(newValue.recordsCount,newValue.pageRecordsStart,newValue.pageRecordsEnd,newValue.totalPages);
	        			
	            		scope.currentPage= paginationService.getCurrentPage(scope.paginationId);
	            		scope.pageShow = paginationService.getPageShow(scope.paginationId);
	            		//scope.totalPages()
						scope.totalPagesArray = [];
	            		for(var i = 0; i < scope.totalPages(scope.paginationId); i++){
	            			scope.totalPagesArray.push(i+1);
	            		}
						paginationService.getPageShow(scope.paginationId);
						//scope.pageStart(scope.paginationId);
						paginationService.getPageEnd(scope.paginationId);
						//scope.pageEnd(scope.paginationId);
						paginationService.getRecordsCount(scope.paginationId);
						//scope.recordsCount(scope.paginationId);
	            		scope.hasPrevious();
	            		scope.hasNext();
	        		}
	        	});
	        	
	        	scope.showPreviousJump = function(){
	        		if(angular.isDefined(scope.currentPage) && scope.currentPage > 3){
	        			scope.totalPagesArray = [];
	            		for(var i = 0; i < scope.totalPages(scope.paginationId); i++){
	            			if(scope.currentPage < 7 && scope.currentPage > 3 ){
	            				if(i !== 0){
	            					scope.totalPagesArray.push(i+1);
	            				}
	            			} else {
	            				scope.totalPagesArray.push(i+1);
	            			}
	            		}
	        			return true;
	        		}else{
	        			return false;
	        		}
	        	};
	        	
	        	scope.showNextJump = function(){
	        		return !!(scope.currentPage < paginationService.getTotalPages(scope.paginationId) - 3
								&& paginationService.getTotalPages(scope.paginationId) > 6);
	        	};
	        	
	        	scope.previousJump = function(){
	        		paginationService.setCurrentPage(scope.paginationId, scope.currentPage - 3);
	        		scope.currentPage -= 3;
	        	};
	        	
	        	scope.nextJump = function(){
	        		paginationService.setCurrentPage(scope.paginationId, scope.currentPage + 3);
	        		scope.currentPage += 3;
	        	};
	        	
	        	scope.showPageNumber = function(number){
	        		/*if(scope.currentPage >= scope.totalPages() - 3){
	        			if(number > scope.totalPages() - 6){
	        				return true;
	        			}
	        		}*/
	        		
	        		if(scope.currentPage >= scope.totalPages(scope.paginationId) - 3){
	        			if(number > scope.totalPages(scope.paginationId) - 6){
	        				return true;
	        			}
	        		}
	        		
	        		if(scope.currentPage <= 3){
	        			if(number < 6){
	        				return true;
	        			}
	        		}else{
	        			var bottomRange = scope.currentPage - 2;
	        			var topRange = scope.currentPage + 2;
	        			if(number > bottomRange && number < topRange ){
	        				return true;
	        			}
	        		}
	        		return false;
	        	};
	        	
	        	scope.previousPage = function(){
	        		paginationService.previousPage(scope.paginationId);
	        		scope.currentPage = paginationService.getCurrentPage(scope.paginationId);
	        	};
	        	
	        	scope.nextPage = function(){
	        		paginationService.nextPage(scope.paginationId);
	        		scope.currentPage = paginationService.getCurrentPage(scope.paginationId);
	        	};
			}
		};
	}
]);
	
