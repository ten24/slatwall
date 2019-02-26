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
                scope.aggregate ={};
                scope.aggregate.selectedAggregate = '';

                scope.aggregateOptions = [
                    {id:'average', value:'Average'},
                    {id:'count', value:'Count'},
                    {id:'sum', value:'Sum'},
                    {id:'min', value:'Min'},
                    {id:'max', value:'Max'}
                ];

                scope.selectAggregate = function (aggregate) {
                    if(aggregate == 'count' || scope.selectedProperty.ormtype){
                        scope.selectedProperty.aggregate = aggregate;
                        scope.selectedPropertyChanged({selectedProperty:scope.selectedProperty});
                    }else{
                        scope.aggregate.currentObject = scope.selectedProperty.cfc;
                    }
                };
                

                scope.selectedDisplayOptionChanged = function(selectedDisplayOption){
                    var breadCrumb = {
							entityAlias:scope.selectedProperty.name,
							cfc:scope.selectedProperty.cfc,
							propertyIdentifier:scope.selectedProperty.propertyIdentifier
					};
					scope.breadCrumbs.push(breadCrumb);
					
                    selectedDisplayOption.aggregate = scope.aggregate.selectedAggregate;
                    selectedDisplayOption.aggregateObject = scope.aggregate.currentObject;
                    scope.selectedPropertyChanged({selectedProperty:selectedDisplayOption});
                    displayOptionsController.selectedPropertyChanged(selectedDisplayOption);
                };


                scope.$watch('selectedProperty', function(selectedProperty) {
                    if(angular.isDefined(selectedProperty) && !selectedProperty.ormtype){
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

