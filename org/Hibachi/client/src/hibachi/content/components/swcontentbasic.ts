/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

class SWContentBasic{
    public static Factory(){
        var directive = (
            $log,
            $routeParams,
            $slatwall,
            formService,
            contentPartialsPath
        )=> new SWContentBasic(
            $log,
            $routeParams,
            $slatwall,
            formService,
            contentPartialsPath
        );
        directive.$inject = [
            '$log',
            '$routeParams',
            '$slatwall',
            'formService',
            'contentPartialsPath'
        ];
        return directive;
    }
    constructor(
        $log,
        $routeParams,
        $slatwall,
        formService,
        contentPartialsPath
    ){
        return {
			restrict: 'EA',
			templateUrl:contentPartialsPath+"contentbasic.html",
			link: function(scope, element,attrs){
                if(!scope.content.$$isPersisted()){
                    if(angular.isDefined($routeParams.siteID)){
                        var sitePromise;
                        var options = {
                            id:$routeParams.siteID
                        };
                        sitePromise = $slatwall.getSite(options);
                        sitePromise.promise.then(function(){
                            var site = sitePromise.value;
                            scope.content.$$setSite(site);
                        });
                    }else{
                        var site = $slatwall.newSite();   
                        scope.content.$$setSite(site); 
                    }
                    
                    
                   var parentContent;
                    if(angular.isDefined($routeParams.parentContentID)){
                        var parentContentPromise;
                        var options = {
                            id:$routeParams.parentContentID
                        };
                        parentContentPromise = $slatwall.getContent(options);
                        parentContentPromise.promise.then(function(){
                            var parentContent = parentContentPromise.value;
                            scope.content.$$setParentContent(parentContent);
                            $log.debug('contenttest');
                            $log.debug(scope.content);
                        });
                        
                    }else{
                         var parentContent = $slatwall.newContent();
                         scope.content.$$setParentContent(parentContent);
                    }
                   
                    var contentTemplateType = $slatwall.newType();
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

