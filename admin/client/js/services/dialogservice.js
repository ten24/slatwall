angular.module('slatwalladmin.services').factory('dialogService', [
function(
){
	
	/*
	var _pageDialogs = [
		{
			'type' : 'create',
			'path' : 'admin/client/partials/createproductbundle.html'
		}
	];
	*/
	
	var _pageDialogs = [];
	
	return factory = {
		addCreatePageDialog: function( name ){
			_pageDialogs.push( {
				'type' : 'create',
				'path' : 'admin/client/partials/' + name + '.html'
			} );
		},
		getPageDialogs: function(){
			return _pageDialogs;
		}
	};
}]);