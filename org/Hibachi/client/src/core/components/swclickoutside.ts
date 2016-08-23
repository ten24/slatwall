/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWClickOutside{
    restrict = 'A';
    scope = {
        swClickOutside: '&'
    };
    
    public static Factory(){
        var directive = (
            $document,$timeout,utilityService
        )=>new SWClickOutside(
            $document,$timeout,utilityService
        );
        directive.$inject = [
            '$document', '$timeout', 'utilityService'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public $document, 
        public $timeout, 
        public utilityService
    ){
        this.$document = $document;
        this.$timeout = $timeout;
        this.utilityService = utilityService;
    }
    
    public link:ng.IDirectiveLinkFn = (scope:any, elem:any, attr:any) => {     
        this.$document.on('click', (e)=> {
            if (!e || !e.target) return;
            
            //check if our element already hidden
            if(angular.element(elem).hasClass("ng-hide")){
                return;
            }
            if(e.target !== elem && ! this.utilityService.isDescendantElement(elem,e.target)){
                this.$timeout(()=>{
                    scope.swClickOutside();
                });
            }
        });
    }
    
    
}
    
export{
    SWClickOutside
}
