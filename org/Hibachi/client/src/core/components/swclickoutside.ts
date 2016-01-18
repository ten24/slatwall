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
                swClickOutside: '&',
                outsideIfNot: '@'
            },
            link: function ($scope, elem, attr) {
                var classList = (attr.outsideIfNot !== undefined) ? attr.outsideIfNot.replace(', ', ',').split(',') : [];
                if (attr.id !== undefined) classList.push(attr.id);

                $document.on('click', function (e) {
                    var i = 0,
                        element;

                    if (!e || !e.target) return;
                    
                    //check if our element already hiden
                    if(angular.element(elem).hasClass("ng-hide")){
                        return;
                    }

                    for (element = e.target; element; element = element.parentNode) {
                        var id = element.id;
                        var classNames = element.className;

                        if (id !== undefined) {
                            for (i = 0; i < classList.length; i++) {
                                if ((id !== undefined && id.indexOf(classList[i]) > -1) || classNames.indexOf(classList[i]) > -1) {
                                    return;
                                }
                            }
                        }
                    }
                $timeout( function(){
                    $scope.swClickOutside();
                });

                });
            }
        };
    }
}
export{
    SWClickOutside
}
