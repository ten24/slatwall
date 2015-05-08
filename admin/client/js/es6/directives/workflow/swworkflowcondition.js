angular.module('slatwalladmin').directive('swWorkflowCondition', [
    '$log',
    '$location',
    '$slatwall',
    'formService',
    'metadataService',
    'workflowPartialsPath',
    function ($log, $location, $slatwall, formService, metadataService, workflowPartialsPath) {
        return {
            restrict: 'E',
            scope: {
                workflowCondition: "=",
                workflowConditionIndex: "=",
                workflow: "=",
                filterPropertiesList: "="
            },
            templateUrl: workflowPartialsPath + "workflowcondition.html",
            link: function (scope, element, attrs) {
                $log.debug('workflowCondition init');
                $log.debug(scope);
                scope.selectBreadCrumb = function (breadCrumbIndex) {
                    //splice out array items above index
                    var removeCount = scope.filterItem.breadCrumbs.length - 1 - breadCrumbIndex;
                    scope.filterItem.breadCrumbs.splice(breadCrumbIndex + 1, removeCount);
                    scope.selectedFilterPropertyChanged(null);
                };
                scope.selectedFilterPropertyChanged = function (selectedFilterProperty) {
                    $log.debug('selectedFilterProperty');
                    $log.debug(selectedFilterProperty);
                    scope.selectedFilterProperty = selectedFilterProperty;
                };
                if (angular.isUndefined(scope.workflowCondition.breadCrumbs)) {
                    scope.workflowCondition.breadCrumbs = [];
                    if (scope.workflowCondition.propertyIdentifier === "") {
                        scope.workflowCondition.breadCrumbs = [
                            {
                                entityAlias: scope.workflow.data.workflowObject,
                                cfc: scope.workflow.data.workflowObject,
                                propertyIdentifier: scope.workflow.data.workflowObject
                            }
                        ];
                    }
                    else {
                        var entityAliasArrayFromString = scope.workflowCondition.propertyIdentifier.split('.');
                        entityAliasArrayFromString.pop();
                        for (var i in entityAliasArrayFromString) {
                            var breadCrumb = {
                                entityAlias: entityAliasArrayFromString[i],
                                cfc: entityAliasArrayFromString[i],
                                propertyIdentifier: entityAliasArrayFromString[i]
                            };
                            scope.workflowCondition.breadCrumbs.push(breadCrumb);
                        }
                    }
                }
                else {
                    angular.forEach(scope.workflowCondition.breadCrumbs, function (breadCrumb, key) {
                        if (angular.isUndefined(scope.filterPropertiesList[breadCrumb.propertyIdentifier])) {
                            var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(breadCrumb.cfc);
                            filterPropertiesPromise.then(function (value) {
                                metadataService.setPropertiesList(value, breadCrumb.propertyIdentifier);
                                scope.filterPropertiesList[breadCrumb.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(breadCrumb.propertyIdentifier);
                                metadataService.formatPropertiesList(scope.filterPropertiesList[breadCrumb.propertyIdentifier], breadCrumb.propertyIdentifier);
                                var entityAliasArrayFromString = scope.workflowCondition.propertyIdentifier.split('.');
                                entityAliasArrayFromString.pop();
                                entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
                                if (angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])) {
                                    for (var i in scope.filterPropertiesList[entityAliasArrayFromString].data) {
                                        var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
                                        if (filterProperty.propertyIdentifier === scope.workflowCondition.propertyIdentifier) {
                                            //selectItem from drop down
                                            scope.selectedFilterProperty = filterProperty;
                                            //decorate with value and comparison Operator so we can use it in the Condition section
                                            scope.selectedFilterProperty.value = scope.workflowCondition.value;
                                            scope.selectedFilterProperty.comparisonOperator = scope.workflowCondition.comparisonOperator;
                                        }
                                    }
                                }
                            });
                        }
                        else {
                            var entityAliasArrayFromString = scope.workflowCondition.propertyIdentifier.split('.');
                            entityAliasArrayFromString.pop();
                            entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
                            if (angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])) {
                                for (var i in scope.filterPropertiesList[entityAliasArrayFromString].data) {
                                    var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
                                    if (filterProperty.propertyIdentifier === scope.workflowCondition.propertyIdentifier) {
                                        //selectItem from drop down
                                        scope.selectedFilterProperty = filterProperty;
                                        //decorate with value and comparison Operator so we can use it in the Condition section
                                        scope.selectedFilterProperty.value = scope.workflowCondition.value;
                                        scope.selectedFilterProperty.comparisonOperator = scope.workflowCondition.comparisonOperator;
                                    }
                                }
                            }
                        }
                    });
                }
            }
        };
    }
]);

//# sourceMappingURL=../../directives/workflow/swworkflowcondition.js.map