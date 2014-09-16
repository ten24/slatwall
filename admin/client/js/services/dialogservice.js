angular.module('slatwalladmin.services').factory('dialogService', [
function(
){
	var _pageDialogs = [];
	
	return factory = {
		
		addPageDialog: function( name ){
			var newDialog = {
				'path' : 'admin/client/partials/' + name + '.html'
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