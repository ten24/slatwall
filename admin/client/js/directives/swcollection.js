'use strict';
angular.module('slatwalladmin')
.directive('swCollection', [
	'$http',
	'$compile',
	'$log',
	function(
		$http,
		$compile,
		$log
	){
		return {
			restrict: 'A',
			//require:"",
			//templateUrl:collectionPartialsPath+"columnitem.html",
			link: function(scope){
				scope.toggleCogOpen = false;
					
				//Toggles open/close of filters and display options
				scope.toggleFiltersAndOptions = function(){
					if(scope.toggleCogOpen === false){
						scope.toggleCogOpen = true;
					} else {
						scope.toggleCogOpen = false;
					}
				}

			}
		};
	}
]);
	