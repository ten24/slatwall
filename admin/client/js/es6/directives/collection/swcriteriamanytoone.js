'use strict';
angular.module('slatwalladmin').directive('swCriteriaManyToOne', [
    '$log',
    '$slatwall',
    '$filter',
    'collectionPartialsPath',
    'collectionService',
    'metadataService',
    function ($log, $slatwall, $filter, collectionPartialsPath, collectionService, metadataService) {
        return {
            restrict: 'E',
            templateUrl: collectionPartialsPath + 'criteriamanytoone.html',
            link: function (scope, element, attrs) {
                var getManyToOneOptions = function () {
                    var manyToOneOptions = {
                        drillEntity: {},
                        hasEntity: {
                            display: "Defined",
                            comparisonOperator: "is not",
                            value: "null"
                        },
                        notHasEntity: {
                            display: "Not Defined",
                            comparisonOperator: "is",
                            value: "null"
                        }
                    };
                    return manyToOneOptions;
                };
                scope.manyToOneOptions = getManyToOneOptions();
                scope.conditionOptions = getManyToOneOptions();
                $log.debug('many-to-one');
                $log.debug(scope.selectedFilterProperty);
                $log.debug(scope.filterPropertiesList);
                scope.$watch('selectedFilterProperty', function (selectedFilterProperty) {
                    if (angular.isUndefined(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier])) {
                        var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(selectedFilterProperty.cfc);
                        filterPropertiesPromise.then(function (value) {
                            scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier] = value;
                            metadataService.formatPropertiesList(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier], scope.selectedFilterProperty.propertyIdentifier);
                        }, function (reason) {
                        });
                    }
                    scope.selectedCriteriaChanged = function (selectedCriteria) {
                        $log.debug(selectedCriteria);
                        $log.debug('changed');
                        //update breadcrumbs as array of filterpropertylist keys
                        $log.debug(scope.selectedFilterProperty);
                        var breadCrumb = {
                            entityAlias: scope.selectedFilterProperty.name,
                            cfc: scope.selectedFilterProperty.cfc,
                            propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier,
                            rbKey: $slatwall.getRBKey('entity.' + scope.selectedFilterProperty.cfc.replace('_', ''))
                        };
                        $log.debug('breadcrumb');
                        $log.debug(breadCrumb);
                        $log.debug(scope.filterItem.breadCrumbs);
                        scope.filterItem.breadCrumbs.push(breadCrumb);
                        //populate editfilterinfo with the current level of the filter property we are inspecting by pointing to the new scope key
                        scope.selectedFilterPropertyChanged({ selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType });
                        //update criteria to display the condition of the new critera we have selected
                        $log.debug(scope.selectedFilterProperty);
                    };
                });
            }
        };
    }
]);

//# sourceMappingURL=../../directives/collection/swcriteriamanytoone.js.map