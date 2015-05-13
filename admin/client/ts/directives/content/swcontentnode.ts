'use strict';

angular.module('slatwalladmin')
    .directive('swContentNode', [
            '$log',
            '$compile',
            '$slatwall',
            'partialsPath',
            function(
                $log,
                $compile,
                $slatwall,
                partialsPath
            ) {
                return {
                    restrict: 'A',
                    scope:{
                        contentData:'='
                    },
                    templateUrl: partialsPath + 'content/contentnode.html',
                    link: function(scope, element, attr) {
                        if(angular.isDefined(scope.$parent)){
                            if(angular.isDefined(scope.$parent.child)){
                                scope.contentData = scope.$parent.child; 
                                if(angular.isUndefined(scope.depth) && angular.isUndefined(scope.$parent.depth)){
                                    scope.depth = 1;
                                }else{
                                    scope.depth = scope.$parent.depth + 1;
                                }
                            }
                        }
                        
                        var childContentColumnsConfig = [{
                                propertyIdentifier: '_content.contentID',
                                isVisible: false,
                                isSearchable: false
                            }, 
                            {
                                propertyIdentifier: '_content.title',
                                isVisible: true,
                                isSearchable: true
                            },
                            {
                                propertyIdentifier: '_content.site.siteName',
                                isVisible: true,
                                isSearchable: true
                            }, {
                                propertyIdentifier: '_content.contentTemplateFile',
                                persistent: false,
                                setting: true,
                                isVisible: true
                            },
                            //need to get template via settings
                            {
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
                            }
                        ];
                       

                        scope.getChildContent = function(parentContentRecord) {
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
                                allRecords: true
                            });
                            collectionListingPromise.then(function(value) {
                                parentContentRecord.children = value.records;
                                angular.forEach(parentContentRecord.children,function(child){
                                    scope.child = child;
                                    element.parent().append($compile('<tr class="childNode" style="margin-left:15px" sw-content-node ></tr>')(scope));
                                });
                            });
                        }

                    }
                }

            }]);