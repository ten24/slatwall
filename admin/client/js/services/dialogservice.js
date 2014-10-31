angular.module('slatwalladmin.services').factory('dialogService', [
'partialsPath',
function(
partialsPath
){
	var _pageDialogs = [];
	
	return factory = {
		
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
}]);