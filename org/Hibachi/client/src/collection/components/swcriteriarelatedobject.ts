/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaRelatedObject{
    public static Factory(){
        var directive = (
            $log,
            $hibachi,
            $filter,
            collectionPartialsPath,
            collectionService,
            metadataService,
            hibachiPathBuilder,
            rbkeyService
        ) => new SWCriteriaRelatedObject(
            $log,
            $hibachi,
            $filter,
            collectionPartialsPath,
            collectionService,
            metadataService,
            hibachiPathBuilder,
            rbkeyService
        );
        directive.$inject = [
            '$log',
            '$hibachi',
            '$filter',
            'collectionPartialsPath',
            'collectionService',
            'metadataService',
            'hibachiPathBuilder',
            'rbkeyService'
        ];
        return directive;
    }
    constructor(
        $log,
        $hibachi,
        $filter,
        collectionPartialsPath,
        collectionService,
        metadataService,
        hibachiPathBuilder,
        rbkeyService
    ){
        return {
            restrict: 'E',
            templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criteriarelatedobject.html',
            link: function(scope, element, attrs){
                var getRelatedObjectOptions = function(){
                    var relatedObjectOptions = {
                        drillEntity:null,
                        hasEntity:{
                            display:"Defined",
                            comparisonOperator:"is not",
                            value:"null"
                        },
                        notHasEntity:{
                            display:"Not Defined",
                            comparisonOperator:"is",
                            value:"null"
                        },
                        aggregate : {
                            aggregate : ""
                        }
                    };
                    return relatedObjectOptions;
                };

                scope.aggegate ={};
                scope.aggegate.selectedAggregate = '';

                scope.aggregateOptions = [ 'Average', 'Count', 'Sum'];

                scope.selectAggregate = function (aggregate) {
                    scope.selectedFilterProperty.selectedCriteriaType.aggregate = aggregate;
                };
                scope.relatedObjectOptions = getRelatedObjectOptions();
                scope.conditionOptions = getRelatedObjectOptions();
                $log.debug('many-to-one');
                $log.debug(scope.selectedFilterProperty);
                $log.debug(scope.filterPropertiesList);

                scope.$watch('selectedFilterProperty',function(selectedFilterProperty){
                    if(angular.isUndefined(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier])){
                        var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(selectedFilterProperty.cfc);
                        filterPropertiesPromise.then(function(value){
                            scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier] = value;
                            metadataService.formatPropertiesList(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier],scope.selectedFilterProperty.propertyIdentifier);

                        }, function(reason){

                        });
                    }

                    scope.selectedCriteriaChanged = function(selectedCriteria, selectedAggregate?){
                        var breadCrumb = {
                            entityAlias:scope.selectedFilterProperty.name,
                            cfc:scope.selectedFilterProperty.cfc,
                            propertyIdentifier:scope.selectedFilterProperty.propertyIdentifier,
                            rbKey:rbkeyService.getRBKey('entity.'+scope.selectedFilterProperty.cfc.replace('_',''))
                        };
                        $log.debug('breadcrumb');
                        $log.debug(breadCrumb);
                        $log.debug(scope.filterItem.breadCrumbs);
                        scope.filterItem.breadCrumbs.push(breadCrumb);

                        if(selectedAggregate){
                            scope.selectedFilterProperty.selectedCriteriaType.ormtype = 'integer';
                            scope.selectedFilterProperty.selectedCriteriaType.aggregate = selectedAggregate;
                        }
                        //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
                        scope.selectedFilterPropertyChanged({selectedFilterProperty:scope.selectedFilterProperty.selectedCriteriaType});
                        //update criteria to display the condition of the new critera we have selected
                        $log.debug(scope.selectedFilterProperty);

                    };
                });
            }
        };
    }
}
export{
    SWCriteriaRelatedObject
}