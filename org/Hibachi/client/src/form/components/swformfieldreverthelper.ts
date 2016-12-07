/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldRevertHelperController {

    public parentDirectiveControllerAs:string;
    public parentDirectiveBindProperty:string;
    public valueToRevertTo:any;

    // @ngInject
    constructor(private $hibachi
        ){
    }
}

interface SWScope extends ng.IScope{
    swFormFieldRevertHelper:any
}

class SWFormFieldRevertHelper implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public require = "ngModel";
    public scope = {};

    public bindToController = {
        parentDirectiveControllerAs:"@",
        parentDirectiveBindProperty:"=",
        valueToRevertToProperty:"="
    };
    public controller=SWFormFieldRevertHelper;
    public controllerAs="swFormFieldRevertHelper";

    // @ngInject
    constructor(){

    }

    public link:ng.IDirectiveLinkFn = ($scope:SWScope, element: ng.IAugmentedJQuery, attrs:any, modelCtrl: ng.INgModelController) =>{

         var parentScope = $scope.$parent;
         var parentDirectiveScope = parentScope[$scope.swFormFieldRevertHelper.parentDirectiveControllerAs];

         modelCtrl.$parsers.unshift((inputValue) =>{
            var modelValue = modelCtrl.$modelValue;

            //figure out if the model value has changed
            //was it a revert?
            if(modelValue !== inputValue
                && angular.isDefined(parentDirectiveScope)
                && angular.isDefined(parentDirectiveScope.singleEditedObject.data[parentDirectiveScope.property])
                && angular.isDefined(parentDirectiveScope.revertSet)
                && !parentDirectiveScope.revertSet
            ){
                parentDirectiveScope.valueToRevertTo = modelValue;
                parentDirectiveScope.singleEditedObject.data[parentDirectiveScope.property] = inputValue;
                parentDirectiveScope.edited = true;
                parentDirectiveScope.saved = false;
                parentDirectiveScope.revertSet = true;
            } else {
                modelValue = inputValue;
                parentDirectiveScope.singleEditedObject.data[parentDirectiveScope.property] = inputValue;
            }

            return modelValue;
        });


    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = ()=> new SWFormFieldRevertHelper();
        directive.$inject = [];
        return directive;
    }
}
export{
    SWFormFieldRevertHelper,
    SWFormFieldRevertHelperController
}