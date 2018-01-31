/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCollectionTable{

	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$log,
			hibachiPathBuilder,
			collectionPartialsPath,
			selectionService,
			$hibachi,
            $filter,
            $injector
		) => new SWCollectionTable(
            $log,
            hibachiPathBuilder,
            collectionPartialsPath,
            selectionService,
            $hibachi,
            $filter,
            $injector
		);
		directive.$inject = [
            '$log',
            'hibachiPathBuilder',
            'collectionPartialsPath',
            'selectionService',
            '$hibachi',
            '$filter',
            '$injector'
		];
		return directive;
	}
	//@ngInject
	constructor(
        $log,
        hibachiPathBuilder,
        collectionPartialsPath,
        selectionService,
        $hibachi,
        $filter,
        $injector
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

				if(scope.collection.collectionObject){
                    scope.collectionObject = $hibachi['new'+scope.collection.collectionObject]();
				}else if(scope.collectionConfig.baseEntityName){
					scope.collectionObject = scope.collectionConfig.baseEntityName;
				}

                var escapeRegExp = function(str) {
                    return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
                };

                scope.replaceAll = function(str, find, replace) {
                   return str.replace(new RegExp(escapeRegExp(find), 'g'), replace);
                };

				/*
				 * Handles setting the key on the data.
				 * */
				angular.forEach(scope.collectionConfig.columns,function(column:any){
					$log.debug("Config Key : " + column);
					column.key = column.propertyIdentifier.replace(/\./g, '_').replace(scope.collectionConfig.baseEntityAlias+'_','');
				});

                scope.addSelection = function(selectionid,selection){
                    selectionService.addSelection(selectionid,selection);
                };

                scope.getCellValue = function(pageRecord,column){
                    var value = '';
                    if(angular.isDefined(column.aggregate)){
                        value =  pageRecord[column.aggregate.aggregateAlias];
                    }else if(column.propertyIdentifier.replace(scope.collectionConfig.baseEntityAlias,'').charAt(0) == '.'){
                        value = pageRecord[column.propertyIdentifier.replace(scope.collectionConfig.baseEntityAlias+'.','')];
                    }else{
                        value =  pageRecord[column.propertyIdentifier.replace(scope.collectionConfig.baseEntityAlias+'_','').replace(/\./g,'_')];
                    }
                    var type = 'none';
                    if(angular.isDefined(column.type) && column.type != 'none'){
                        type = column.type;
                    }
                    if(type == 'none' && angular.isDefined(column.ormtype) && column.ormtype != 'none'){
                        type = column.ormtype;
                    }
                    if(type != 'none' && $injector.has(type + 'Filter')){
                        return $filter(type)(value);
                    }else{
                        return value;
                    }
                };

			}
		};
	}

}
export{
	SWCollectionTable
}
