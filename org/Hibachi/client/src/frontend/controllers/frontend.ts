/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class FrontendController{
        
        constructor(
                private $scope,
                private $element, private $log:ng.ILogService,
                private $hibachi,
                private collectionConfigService,
                private selectionService){
                
        }

}
export{FrontendController}