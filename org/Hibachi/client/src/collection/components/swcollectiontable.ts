/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCollectionTable{

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$http,
			$compile,
			$log,
			hibachiPathBuilder,
			collectionPartialsPath,
			paginationService,
			selectionService,
			$hibachi
		) => new SWCollectionTable(
			$http,
            $compile,
            $log,
            hibachiPathBuilder,
            collectionPartialsPath,
            paginationService,
            selectionService,
            $hibachi
		);
		directive.$inject = [
			'$http',
            '$compile',
            '$log',
            'hibachiPathBuilder',
            'collectionPartialsPath',
            'paginationService',
            'selectionService',
            '$hibachi'
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
        paginationService,
        selectionService,
        $hibachi
	){
		return {
			restrict: 'E',
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"collectiontable.html",
			scope:{
				collection:"=",
				collectionConfig:"=",
				isRadio:"=?",
                //angularLink:true || false
                angularLinks:"=?"
			},
			link: function(scope,element,attrs){

                if(angular.isUndefined(scope.angularLinks)){
                    scope.angularLinks = false;
                }
                scope.collectionObject = $hibachi['new'+scope.collection.collectionObject]();

                var escapeRegExp = function(str) {
                    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
                }

                scope.replaceAll = function(str, find, replace) {
                   return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
                }

				/*
				 * Handles setting the key on the data.
				 * */
				angular.forEach(scope.collectionConfig.columns,function(column){
					$log.debug("Config Key : " + column);
					column.key = column.propertyIdentifier.replace(/\./g, '_').replace(scope.collectionConfig.baseEntityAlias+'_','');
				});

                scope.addSelection = function(selectionid,selection){
                    selectionService.addSelection(selectionid,selection);
                }

			}
		};
	}

}
export{
	SWCollectionTable
}
