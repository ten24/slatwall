/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDisplayItemAggregateSimple{
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            $hibachi,
            collectionPartialsPath,
            metadataService,
            hibachiPathBuilder
        )=> new SWDisplayItemAggregateSimple(
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
            templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"displayitemaggregatesimple.html",
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
                        scope.propertiesList[selectedProperty.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(selectedProperty.propertyIdentifier);
                        metadataService.formatPropertiesList(scope.propertiesList[selectedProperty.propertyIdentifier],selectedProperty.propertyIdentifier);    
                        
                        scope.showDisplayItem = true;
                    }
                });
            }
        }
    }
}
export{
    SWDisplayItemAggregateSimple
}

