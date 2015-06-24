'use strict';
angular.module('slatwalladmin').directive('swContentNode', [
    '$log',
    '$compile',
    '$slatwall',
    'partialsPath',
    function ($log, $compile, $slatwall, partialsPath) {
        return {
            restrict: 'A',
            scope: {
                contentData: '=',
                loadChildren: "="
            },
            templateUrl: partialsPath + 'content/contentnode.html',
            link: function (scope, element, attr) {
                if (angular.isUndefined(scope.depth)) {
                    scope.depth = 0;
                }
                if (angular.isDefined(scope.$parent.depth)) {
                    scope.depth = scope.$parent.depth + 1;
                }
                var childContentColumnsConfig = [{
                    propertyIdentifier: '_content.contentID',
                    isVisible: false,
                    isSearchable: false
                }, {
                    propertyIdentifier: '_content.title',
                    isVisible: true,
                    isSearchable: true
                }, {
                    propertyIdentifier: '_content.site.siteID',
                    isVisible: false,
                    isSearchable: false
                }, {
                    propertyIdentifier: '_content.site.siteName',
                    isVisible: true,
                    isSearchable: true
                }, {
                    propertyIdentifier: '_content.contentTemplateFile',
                    persistent: false,
                    setting: true,
                    isVisible: true
                }, {
                    propertyIdentifier: '_content.allowPurchaseFlag',
                    isVisible: true,
                    isSearchable: true
                }, {
                    propertyIdentifier: '_content.productListingPageFlag',
                    isVisible: true,
                    isSearchable: true
                }, {
                    propertyIdentifier: '_content.activeFlag',
                    isVisible: true,
                    isSearchable: true
                }];
                var childContentOrderBy = [
                    {
                        "propertyIdentifier": "_content.sortOrder",
                        "direction": "DESC"
                    }
                ];
                scope.getChildContent = function (parentContentRecord) {
                    if (angular.isUndefined(scope.childOpen) || scope.childOpen === false) {
                        scope.childOpen = true;
                        var childContentfilterGroupsConfig = [{
                            "filterGroup": [{
                                "propertyIdentifier": "_content.parentContent.contentID",
                                "comparisonOperator": "=",
                                "value": parentContentRecord.contentID
                            }]
                        }];
                        var collectionListingPromise = $slatwall.getEntity('Content', {
                            columnsConfig: angular.toJson(childContentColumnsConfig),
                            filterGroupsConfig: angular.toJson(childContentfilterGroupsConfig),
                            orderByConfig: angular.toJson(childContentOrderBy),
                            allRecords: true
                        });
                        collectionListingPromise.then(function (value) {
                            parentContentRecord.children = value.records;
                            var index = 0;
                            angular.forEach(parentContentRecord.children, function (child) {
                                scope['child' + index] = child;
                                element.after($compile('<tr class="childNode" style="margin-left:{{depth*15||0}}px"  sw-content-node data-content-data="child' + index + '"></tr>')(scope));
                                index++;
                            });
                        });
                    }
                };
                if (angular.isDefined(scope.loadChildren) && scope.loadChildren === true) {
                    scope.getChildContent(scope.contentData);
                }
            }
        };
    }
]);

//# sourceMappingURL=../../directives/content/swcontentnode.js.map