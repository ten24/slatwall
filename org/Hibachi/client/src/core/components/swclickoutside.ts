/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWClickOutside{
    restrict = 'A';
    scope = {
        swClickOutside: '&'
    };
    
    public static Factory(){
        var directive = (
            $document,$timeout
        )=>new SWClickOutside(
            $document,$timeout
        );
        directive.$inject =[
            '$document','$timeout'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public $document, public $timeout
    ){
        
    }
    
    public link:ng.IDirectiveLinkFn = ($scope:any, elem:any, attr:any) => {       
        this.$document.on('click', function (e) {
            if (!e || !e.target) return;
            
            //check if our element already hiden
            if(angular.element(elem).hasClass("ng-hide")){
                return;
            }
            if(e.target !== elem && ! this.isDescendant(elem,e.target)){
                this.$timeout(()=>{
                    $scope.swClickOutside();
                });
            }
        });
    }
    
    private isDescendant = (parent, child) => {
        var node = child.parentNode;
        while (node != null) {
            if (node == parent) {
                return true;
            }
            node = node.parentNode;
        }
        return false;
    }
}
    
export{
    SWClickOutside
}
