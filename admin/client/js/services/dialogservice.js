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
				if(Object.keys(_clickOutsideDialogs).length){
					var needsToBeClosedCtr = Object.keys(_clickOutsideDialogs).length;
					for(var key in _clickOutsideDialogs) {
						//click event.target not in dialog
						if(!event.target.parentElement.offsetParent.classList.contains( key )){						
							needsToBeClosedCtr--;
						}
					}
					
					if(needsToBeClosedCtr === 0){
						for(var key in _clickOutsideDialogs) {
							_clickOutsideDialogs[ key ]();
							delete _clickOutsideDialogs[ key ];
						}
					}	
				}
				
			},
			
			addDialogToCloseOnClickOutside: function( classArray, callbackFunction ) {
				for(var i in classArray){
					_clickOutsideDialogs[ classArray[i] ] = callbackFunction;
				}
			}
			
		};
		
		return dialogService;
	}
]);