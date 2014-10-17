'use strict';
angular.module('slatwalladmin', ['slatwalladmin.services','ui.bootstrap', 'ngAnimate', function($locationProvider){
	$locationProvider.html5Mode(true);
}]).config(["$provide",'$logProvider','$filterProvider', function ($provide, $logProvider,$filterProvider) {
	
	var _partialsPath = $.slatwall.getConfig().baseURL + '/admin/client/js/directives/partials/';
	
	$provide.constant("partialsPath", _partialsPath);
	$provide.constant("productBundlePartialsPath", _partialsPath+'productbundle/');
	$provide.constant("collectionPartialsPath", _partialsPath+'collection/');
	$provide.constant("workflowPartialsPath", _partialsPath+'workflow/');
	
	// TODO: configure log provider on/off based on server side rules? 
	var debugEnabled = true;
	$logProvider.debugEnabled(debugEnabled);
	
	$filterProvider.register('likeFilter',function(){
		return function(text){
			
			if(angular.isDefined(text)){
				return text.replace(new RegExp('%', 'g'), '');
			}
		};
	});
	
	$filterProvider.register('AliasDisplayName',function(){
		return function(text){
			
			if(angular.isDefined(text)){
				text = text.replace('_', '');
				text = text.charAt(0).toUpperCase() + text.slice(1);
				return text;
			}
		};
	});
	
	$filterProvider.register('truncate',function(){
		return function (input, chars, breakOnWord) {
            if (isNaN(chars)) return input;
            if (chars <= 0) return '';
            if (input && input.length > chars) {
                input = input.substring(0, chars);

                if (!breakOnWord) {
                    var lastspace = input.lastIndexOf(' ');
                    //get last space
                    if (lastspace !== -1) {
                        input = input.substr(0, lastspace);
                    }
                }else{
                    while(input.charAt(input.length-1) === ' '){
                        input = input.substr(0, input.length -1);
                    }
                }
                return input + '...';
            }
            return input;
        };
	});
	
}]).run(['$rootScope','dialogService', function($rootScope, dialogService) {
    $rootScope.openPageDialog = function( partial ) {
    	dialogService.addPageDialog( partial );
    };
    
    $rootScope.closePageDialog = function( index ) {
		dialogService.removePageDialog( index );
    };
}]);


angular.module('slatwall',['slatwalladmin']);
