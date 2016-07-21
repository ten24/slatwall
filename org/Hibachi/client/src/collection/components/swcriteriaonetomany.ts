/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWCriteriaOneToMany{
    public static Factory(){
        var directive = (
            $log,
            $hibachi,
            $filter,
            collectionPartialsPath,
            collectionService,
            metadataService,
            dialogService,
            observerService,
			hibachiPathBuilder,
            rbkeyService
        )=> new SWCriteriaOneToMany(
            $log,
            $hibachi,
            $filter,
            collectionPartialsPath,
            collectionService,
            metadataService,
            dialogService,
            observerService,
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
            'dialogService',
            'observerService',
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
        dialogService,
        observerService,
        hibachiPathBuilder,
            rbkeyService
    ){
        return {
            restrict: 'E',
            templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criteriaonetomany.html',
            link: function(scope, element, attrs){
                scope.data ={};
                scope.collectionOptionsOpen = false;

                scope.toggleCollectionOptions = function(flag){
                    scope.collectionOptionsOpen = (!angular.isUndefined(flag)) ? flag : !scope.collectionOptionsOpen;
                };


                scope.selectCollection = function(collection){
                    scope.toggleCollectionOptions();
                    scope.selectedFilterProperty.selectedCollection = collection;
                    scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[2];
                };

                scope.cleanSelection = function(){
                    scope.toggleCollectionOptions(false);
                    scope.data.collectionName = "";
                    scope.selectedFilterProperty.selectedCollection = null;
                };

                var getOneToManyOptions = function(type){
                    if(angular.isUndefined(type)){
                        type = 'filter'
                    }
                    var oneToManyOptions = [];
                    if(type == 'filter'){
                        oneToManyOptions = [
                            {
                                display:"All Exist In Collection",
                                comparisonOperator:"All"
                            },
                            {
                                display:"None Exist In Collection",
                                comparisonOperator:"None"
                            },
                            {
                                display:"Some Exist In Collection",
                                comparisonOperator:"One"
                            }
                            /*,
                             {
                             display:"Empty",
                             comparisonOperator:"is",
                             value:"null"
                             },
                             {
                             display:"Not Empty",
                             comparisonOperator:"is not",
                             value:"null"
                             }*/
                        ];
                    }else if(type === 'condition'){
                        oneToManyOptions = [

                        ];
                    }


                    return oneToManyOptions;
                };

                $log.debug('onetomany');
                $log.debug(scope.selectedFilterProperty);

                scope.oneToManyOptions = getOneToManyOptions(scope.comparisonType);
                var existingCollectionsPromise = $hibachi.getExistingCollectionsByBaseEntity(scope.selectedFilterProperty.cfc);
                existingCollectionsPromise.then(function(value){
                    scope.collectionOptions = value.data;
                    if(angular.isDefined(scope.filterItem.collectionID)){
                        for(var i in scope.collectionOptions){
                            if(scope.collectionOptions[i].collectionID === scope.filterItem.collectionID){
                                scope.selectedFilterProperty.selectedCollection = scope.collectionOptions[i];
                            }
                        }
                        for(var i in scope.oneToManyOptions){
                            if(scope.oneToManyOptions[i].comparisonOperator === scope.filterItem.criteria){
                                scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[i];
                            }
                        }
                    }
                });

                function populateUI(collection) {
                    scope.collectionOptions.push(collection);
                    scope.selectedFilterProperty.selectedCollection = collection;
                    scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[2];
                }
                observerService.attach(populateUI,'addCollection','addCollection');

                scope.selectedCriteriaChanged = function(selectedCriteria){
                    $log.debug(selectedCriteria);
                    //update breadcrumbs as array of filterpropertylist keys
                    $log.debug(scope.selectedFilterProperty);

                    var breadCrumb = {
                        entityAlias:scope.selectedFilterProperty.name,
                        cfc:scope.selectedFilterProperty.cfc,
                        propertyIdentifier:scope.selectedFilterProperty.propertyIdentifier,
                        rbKey:rbkeyService.getRBKey('entity.'+scope.selectedFilterProperty.cfc.replace('_','')),
                        filterProperty:scope.selectedFilterProperty
                    };
                    scope.filterItem.breadCrumbs.push(breadCrumb);
                    $log.debug('criteriaChanged');
                    //$log.debug(selectedFilterPropertyChanged);
                    $log.debug(scope.selectedFilterProperty);
                    //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
                    scope.selectedFilterPropertyChanged({selectedFilterProperty:scope.selectedFilterProperty.selectedCriteriaType});
                    //update criteria to display the condition of the new critera we have selected

                };

                scope.addNewCollection = function(){
                    dialogService.addPageDialog('org/Hibachi/client/src/collection/components/criteriacreatecollection', {
                        entityName: scope.selectedFilterProperty.cfc,
                        collectionName: scope.data.collectionName,
                        parentEntity: scope.collectionConfig.baseEntityName
                    });
                    scope.cleanSelection();
                };

                scope.viewSelectedCollection = function(){
                    scope.toggleCollectionOptions();
                    dialogService.addPageDialog('org/Hibachi/client/src/collection/components/criteriacreatecollection', {
                        entityName: 'collection',
                        entityId: scope.selectedFilterProperty.selectedCollection.collectionID,
                        parentEntity: scope.collectionConfig.baseEntityName
                    });
                };
            }
        };
    }
}
export{
    SWCriteriaOneToMany
}
