/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
class SWClickOutside{
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
        $document,$timeout
    ){
        return {
            restrict: 'A',
            scope: {
                swClickOutside: '&'
            },
            link: function ($scope, elem, attr) {
                function isDescendant(parent, child) {
                     var node = child.parentNode;
                     while (node != null) {
                         if (node == parent) {
                             return true;
                         }
                         node = node.parentNode;
                     }
                     return false;
                }
                
                $document.on('click', function (e) {
                    if (!e || !e.target) return;
                    
                    //check if our element already hiden
                    if(angular.element(elem).hasClass("ng-hide")){
                        return;
                    }
                    if(e.target !== elem && !isDescendant(elem,e.target)){
                        $timeout( function(){
                            $scope.swClickOutside();
                        });
                    }
                });
            }
        };
    }
}
export{
    SWClickOutside
}
