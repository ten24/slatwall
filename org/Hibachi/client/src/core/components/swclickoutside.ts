/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWClickOutside{
    restrict = 'A';
    scope = {
        swClickOutside: '&'
    };
    
    public static Factory(){
        return /** @ngInject; */ ($document,$timeout,utilityService ) => {
            return new this( $document,$timeout,utilityService );
        }
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
            if(e.target !== elem && elem && elem[0] && !this.utilityService.isDescendantElement(elem[0],e.target)){
                this.$timeout(()=>{
                    scope?.swClickOutside?.();
                });
            }
        });
        
        scope.$on('$destroy', () => {
           elem = null;
           scope = null;
        });
    }
    
    
}
    
export{
    SWClickOutside
}
