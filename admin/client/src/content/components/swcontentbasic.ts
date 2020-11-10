/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWContentBasic{
    public static Factory(){
        var directive = (
            $log,
            $routeParams,
            $hibachi,
            formService,
            contentPartialsPath,
            slatwallPathBuilder
        )=> new SWContentBasic(
            $log,
            $routeParams,
            $hibachi,
            formService,
            contentPartialsPath,
            slatwallPathBuilder
        );
        directive.$inject = [
            '$log',
            '$routeParams',
            '$hibachi',
            'formService',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
        $routeParams,
        $hibachi,
        formService,
        contentPartialsPath,
        slatwallPathBuilder
    ){
        return {
			restrict: 'EA',
			templateUrl:slatwallPathBuilder.buildPartialsPath(contentPartialsPath)+"contentbasic.html",
			link: function(scope, element,attrs){
                if(!scope.content.$$isPersisted()){
                    if(angular.isDefined($routeParams.siteID)){
                        var sitePromise;
                        var options = {
                            id:$routeParams.siteID
                        };
                        sitePromise = $hibachi.getSite(options);
                        sitePromise.promise.then(function(){
                            var site = sitePromise.value;
                            scope.content.$$setSite(site);
                        });
                    }else{
                        var site = $hibachi.newSite();
                        scope.content.$$setSite(site);
                    }


                   var parentContent;
                    if(angular.isDefined($routeParams.parentContentID)){
                        var parentContentPromise;
                        var options = {
                            id:$routeParams.parentContentID
                        };
                        parentContentPromise = $hibachi.getContent(options);
                        parentContentPromise.promise.then(function(){
                            var parentContent = parentContentPromise.value;
                            scope.content.$$setParentContent(parentContent);
                            $log.debug('contenttest');
                            $log.debug(scope.content);
                        });

                    }else{
                         var parentContent = $hibachi.newContent();
                         scope.content.$$setParentContent(parentContent);
                    }

                    var contentTemplateType = $hibachi.newType();
                    scope.content.$$setContentTemplateType(contentTemplateType);
                }else{
                    scope.content.$$getSite();
                    scope.content.$$getParentContent();
                    scope.content.$$getContentTemplateType();
                }
			}
		};
    }
}
export{
    SWContentBasic
}

