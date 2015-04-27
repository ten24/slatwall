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
                        var childContentColumnsConfig = [{
                                propertyIdentifier: '_content.contentID',
                                isVisible: false,
                                isSearchable: false
                            }, {
                                propertyIdentifier: '_content.title',
                                isVisible: true,
                                isSearchable: true
                            }, {
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
                                parentContentRecord.children = value;
                                angular.forEach(parentContentRecord.children,function(child){
                                    var newScope = {
                                        pageRecord:child  
                                    };
                                    //element.append($compile('<tr sw-content-node data-content-data="pageRecord"></tr>')(newScope));
                                });
                                //element.replaceWith($compile(element.html())(scope));
                                
                            });
                        }

                    }
                }

            }]);