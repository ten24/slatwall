'use strict';
angular.module('slatwalladmin')
.factory('paginationService',[
	function(){
		var _pageRecords = [];
		var _pageShowOptions = [
			{display:10,value:10},
	  		{display:20,value:20},
	  		{display:50,value:50},
	  		{display:250,value:250},
	  		{display:"Auto",value:"Auto"}
	  	];
		var _pageShow = 10;
		var _currentPage = 1;
		var _pageStart = 0;
		var _pageEnd = 0;
		var _recordsCount = 0;
		var _totalPages = 0;
		
		var paginationService = {
			
			getTotalPages:function(){
				return _totalPages;
			},
			setTotalPages:function(totalPages){
				_totalPages = totalPages;
			},
			getPageStart:function(){
				return _pageStart;
			},
			setPageStart:function(pageStart){
				_pageStart = pageStart;
			},
			getPageEnd:function(){
				return _pageEnd;
			},
			setPageEnd:function(pageEnd){
				_pageEnd = pageEnd;
			},
			getRecordsCount:function(){
				return _recordsCount;
			},
			setRecordsCount:function(recordsCount){
				_recordsCount = recordsCount;
			},
			getPageShowOptions:function(){
				return _pageShowOptions;
			},
			setPageShowOptions:function(pageShowOptions){
				_pageShowOptions = pageShowOptions;
			},
			getPageShow:function(){
				return _pageShow;
			},
			setPageShow:function(pageShow){
				_pageShow = pageShow;
			},
			getCurrentPage:function(){
				return _currentPage;
			},
			setCurrentPage:function(currentPage){
				_currentPage = currentPage;
			},
			previousPage:function(){
				if(!this.hasPrevious()){
					_currentPage = this.getCurrentPage() - 1;
				}
			},
			nextPage:function(){
				if(!this.hasNext()){
					_currentPage = this.getCurrentPage() + 1;
				}
			},
			hasPrevious:function(){
				if(paginationService.getPageStart() <= 1){
					return true;
				}else{
					return false;
				}
			},
			hasNext:function(){
				if(paginationService.getPageEnd() === paginationService.getRecordsCount()){
					return true;
				}else{
					return false;
				}
			}
		};
		
		return paginationService;
	}
]);
