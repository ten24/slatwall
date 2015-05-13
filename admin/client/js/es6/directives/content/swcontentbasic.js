angular.module('slatwalladmin').directive('swContentBasic', [
    '$log',
    '$routeParams',
    '$slatwall',
    'formService',
    'contentPartialsPath',
    function ($log, $routeParams, $slatwall, formService, contentPartialsPath) {
        return {
            restrict: 'EA',
            templateUrl: contentPartialsPath + "contentbasic.html",
            link: function (scope, element, attrs) {
                console.log('routeParams');
                console.log($routeParams);
                if (!scope.content.$$isPersisted()) {
                    if (angular.isDefined($routeParams.siteID)) {
                        var sitePromise;
                        var options = {
                            id: $routeParams.siteID
                        };
                        sitePromise = $slatwall.getSite(options);
                        sitePromise.promise.then(function () {
                            var site = sitePromise.value;
                            scope.content.$$setSite(site);
                        });
                    }
                    else {
                        var site = $slatwall.newSite();
                        scope.content.$$setSite(site);
                    }
                    var parentContent;
                    if (angular.isDefined($routeParams.parentContentID)) {
                        var options = {
                            id: $routeParams.parentContentID
                        };
                        parentContent = $slatwall.getContent(options);
                    }
                    else {
                        parentContent = $slatwall.newContent();
                    }
                    scope.content.$$setParentContent(parentContent);
                    var contentTemplateType = $slatwall.newType();
                    scope.content.$$setContentTemplateType(contentTemplateType);
                }
                else {
                    scope.content.$$getSite();
                    scope.content.$$getParentContent();
                }
            }
        };
    }
]);

//# sourceMappingURL=../../directives/content/swcontentbasic.js.map