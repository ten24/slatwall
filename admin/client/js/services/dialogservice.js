'use strict';
angular.module('slatwalladmin').factory('dialogService', [
	'$rootScope',
	'partialsPath',
	function(
		$rootScope,
		partialsPath
	){
		var _pageDialogs = [];
		var _clickOutsideDialogs = {};
	
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
			},
			

			
			closeDialogClickedOutside: function( event ) {
				for(var key in _clickOutsideDialogs) {
					if(!event.target.parentElement.offsetParent.classList.contains( key )){						
						_clickOutsideDialogs[ key ]();
						delete _clickOutsideDialogs[ key ];
					}
				}
			},
			
			addDialogToCloseOnClickOutside: function( domID, callbackFunction ) {
				_clickOutsideDialogs[ domID ] = callbackFunction;
			},
			
			removeDialogToCloseOnClickOutside: function( domID ) {
				delete _clickOutsideDialogs[domID];
 			}
		};
		
		return dialogService;
	}
]);