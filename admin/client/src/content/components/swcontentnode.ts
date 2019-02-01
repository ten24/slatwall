/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWContentNode{
    public static Factory(){
        var directive = (
            $log,
            $compile,
            $hibachi,
            contentPartialsPath,
            slatwallPathBuilder
        )=> new SWContentNode(
            $log,
            $compile,
            $hibachi,
            contentPartialsPath,
            slatwallPathBuilder
        );
        directive.$inject = [
            '$log',
            '$compile',
            '$hibachi',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
        $compile,
        $hibachi,
        contentPartialsPath,
        slatwallPathBuilder
    ){
        return {
            restrict: 'A',
            scope:{
                contentData:'=',
                loadChildren:"="
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + 'contentnode.html',
            link: function(scope, element, attr) {
                if(angular.isUndefined(scope.depth)){
                    scope.depth = 0;
                }

                if(angular.isDefined(scope.$parent.depth)){
                    scope.depth = scope.$parent.depth+1;
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
                        propertyIdentifier: '_content.urlTitlePath',
                        isVisible: true,
                        isSearchable: true
                    },
                    {
                        propertyIdentifier: '_content.site.siteID',
                        isVisible: false,
                        isSearchable: false
                    },
                    {
                        propertyIdentifier: '_content.site.siteName',
                        isVisible: true,
                        isSearchable: true
                    },
                    {
                        propertyIdentifier: '_content.site.domainNames',
                        isVisible: true,
                        isSearchable: true
                    },
//                            {
//                                propertyIdentifier: '_content.contentTemplateFile',
//                                persistent: false,
//                                setting: true,
//                                isVisible: true
//                            },
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

                var childContentOrderBy = [
                    {
                        "propertyIdentifier":"_content.sortOrder",
                        "direction":"DESC"
                    }
                ];

                scope.toggleChildContent = function(parentContentRecord){
                    if(angular.isUndefined(scope.childOpen) || scope.childOpen === false){
                        scope.childOpen = true;
                        if(!scope.childrenLoaded){
                            scope.getChildContent(parentContentRecord);
                        }
                    }else{
                        scope.childOpen = false;
                    }

                }

                scope.getChildContent = function(parentContentRecord) {
                        var childContentfilterGroupsConfig = [{
                        "filterGroup": [{
                            "propertyIdentifier": "_content.parentContent.contentID",
                            "comparisonOperator": "=",
                            "value": parentContentRecord.contentID
                        }]
                    }];

                    var collectionListingPromise = $hibachi.getEntity('Content', {
                        columnsConfig: angular.toJson(childContentColumnsConfig),
                        filterGroupsConfig: angular.toJson(childContentfilterGroupsConfig),
                        orderByConfig: angular.toJson(childContentOrderBy),
                        allRecords: true
                    });
                    collectionListingPromise.then(function(value) {
                        parentContentRecord.children = value.records;
                        var index = 0;
                        angular.forEach(parentContentRecord.children,function(child){
                            child.site_domainNames = child.site_domainNames.split(",")[0];
                            scope['child'+index] = child;
                            element.after($compile('<tr class="childNode" style="margin-left:{{depth*15||0}}px" ng-if="childOpen"  sw-content-node data-content-data="child'+index+'"></tr>')(scope));
                            index++;
                        });
                        scope.childrenLoaded = true;
                    });
                }

                scope.childrenLoaded = false;
                //if the children have never been loaded and we are not in search mode based on the title received
                if(angular.isDefined(scope.loadChildren) && scope.loadChildren === true && !(scope.contentData.titlePath && scope.contentData.titlePath.trim().length)){
                    scope.toggleChildContent(scope.contentData);
                }
            }
        }
    }
}
export{
    SWContentNode
}

