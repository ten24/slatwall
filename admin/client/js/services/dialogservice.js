'use strict';
angular.module('slatwalladmin').factory('dialogService', [
	'partialsPath',
	function(
		partialsPath
	){
		var _pageDialogs = [];
		
		var dialogService = {
			
			addPageDialog: function( name ){
				var newDialog = {
					'path' : partialsPath + name + '.html'
				};
				_pageDialogs.push( newDialog );
			},
			
			removePageDialog: function( index ){
				_pageDialogs.splice(index, 1);
			},
			
			getPageDialogs: function(){
				return _pageDialogs;
			}
		};
		
		return dialogService;
	}
]);