'use strict';
angular.module('slatwalladmin')
//using $location to get url params, this will probably change to using routes eventually
.controller('workflow-triggers', 
[ '$scope',
'$log',
function($scope,
$log
){
	$log.debug('workflow triggers init');
	
}]);
