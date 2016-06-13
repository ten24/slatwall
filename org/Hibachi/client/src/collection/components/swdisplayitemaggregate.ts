/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDisplayItemAggregate{
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $hibachi,
            collectionPartialsPath,
            metadataService,
            hibachiPathBuilder
        )=> new SWDisplayItemAggregate(
            $hibachi,
            collectionPartialsPath,
            metadataService,
            hibachiPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'collectionPartialsPath',
            'metadataService',
            'hibachiPathBuilder'
        ];
        return directive
    }

    //@ngInject
    constructor(
        $hibachi,
        collectionPartialsPath,
        metadataService,
        hibachiPathBuilder
    ){
        return{
            require:'^swDisplayOptions',
            restrict: 'A',
            scope:{
                selectedProperty:"=",
                propertiesList:"=",
                breadCrumbs:"=",
                selectedPropertyChanged:"&"

            },
            templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"displayitemaggregate.html",
            link: function(scope, element,attrs,displayOptionsController){
                scope.showDisplayItem = false;
                scope.aggegate ={};
                scope.aggegate.selectedAggregate = '';

                scope.aggregateOptions = [
                    {id:'average', value:'Average'},
                    {id:'count', value:'Count'},
                    {id:'sum', value:'Sum'}
                ];

                scope.selectAggregate = function (aggregate) {
                    if(aggregate == 'count'){
                        scope.selectedProperty.aggregate = aggregate;
                        scope.selectedPropertyChanged({selectedProperty:scope.selectedProperty});
                    }else{
                        scope.aggegate.currentObject = scope.selectedProperty.cfc;
                    }
                };

                scope.selectedDisplayOptionChanged = function(selectedDisplayOption){
                    selectedDisplayOption.aggregate = scope.aggegate.selectedAggregate;
                    selectedDisplayOption.aggregateObject = scope.aggegate.currentObject;
                    scope.selectedPropertyChanged({selectedProperty:selectedDisplayOption});
                };


                scope.$watch('selectedProperty', function(selectedProperty) {
                    if(angular.isDefined(selectedProperty)){
                        if(angular.isUndefined(scope.propertiesList[selectedProperty.propertyIdentifier])){
                            var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(selectedProperty.cfc);
                            filterPropertiesPromise.then(function(value){
                                metadataService.setPropertiesList(value,selectedProperty.propertyIdentifier);
                                scope.propertiesList[selectedProperty.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(selectedProperty.propertyIdentifier);
                                metadataService.formatPropertiesList(scope.propertiesList[selectedProperty.propertyIdentifier],selectedProperty.propertyIdentifier);
                            }, function(reason){

                            });
                        }
                        scope.showDisplayItem = true;
                    }
                });
            }
        }
    }
}
export{
    SWDisplayItemAggregate
}

