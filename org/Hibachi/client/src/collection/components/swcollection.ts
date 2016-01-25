/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCollection{
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
			$http,
			$compile,
			$log,
			hibachiPathBuilder,
			collectionPartialsPath,
			collectionService
			) => new SWCollection(

				$http,
				$compile,
				$log,
				hibachiPathBuilder,
				collectionPartialsPath,
				collectionService
			);
        directive.$inject = [

            '$http',
			'$compile',
			'$log',
			'hibachiPathBuilder',
			'collectionPartialsPath',
			'collectionService'
        ];
        return directive;
    }
	//@ngInject
	constructor(
			$http,
			$compile,
			$log,
			hibachiPathBuilder,
			collectionPartialsPath,
			collectionService){
		return {
			restrict: 'A',
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"collection.html",
			link: function(scope,$element,$attrs){

				scope.tabsUniqueID = Math.floor(Math.random()*999);
				scope.toggleCogOpen = $attrs.toggleoption;
				//Toggles open/close of filters and display options
				scope.toggleFiltersAndOptions = function(){
					if(scope.toggleCogOpen === false){
						scope.toggleCogOpen = true;
					} else {
						scope.toggleCogOpen = false;
					}
				};

			}
		};
	}
}
export{
	SWCollection
}
