/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * SWValidationEqProperty: Validates true if the user value == another field's value.
 * @usage <input type='text' swvalidationgte='nameOfAnotherInput' /> will validate false if the user enters
 * value other than 5.
 */

import {ValidationService} from "../services/validationservice";
import {ObserverService} from "../../core/services/observerservice";


class SWValidationEqPropertyController{
    //@ngInject
    public swvalidationeqproperty:any;

    constructor(private $rootScope, private validationService,private $scope){
    }
    
    $onChanges = (changes)=>{
        if(this.$scope.ngModel && this.$scope.ngModel.$validators && changes.swvalidationeqproperty){
            this.$scope.ngModel.$validators.swvalidationeqproperty = (modelValue, viewValue)=>{
                let confirmValue;
                if(changes.swvalidationeqproperty){
                    confirmValue = changes.swvalidationeqproperty.currentValue;
                }
                return confirmValue === modelValue;

            };
        }
        if(this.$scope.ngModel){
            this.$scope.ngModel.$validate();
        }
    }
    
}

class SWValidationEqProperty{
    public static Factory() {
        var directive = (
            $rootScope,
            validationService,
            observerService
        ) => new SWValidationEqProperty(
            $rootScope,
            validationService,
            observerService
        );
        
        directive.$inject = ['$rootScope','validationService','observerService'];
        return directive;
    }
    
    //@ngInject
    constructor(
        $rootScope,
        validationService:ValidationService,
        observerService:ObserverService
    ){
        return {
            controller:SWValidationEqPropertyController,
            controllerAs:"swValidationEqProperty",
            restrict: "A",
            require:"^ngModel",
            scope:{},
            bindToController: {
                swvalidationeqproperty: "<"
            },
            link: function(scope, element, attributes, ngModel) {
                scope.ngModel = ngModel;
            }
        };
    }
}
export{
    SWValidationEqProperty
}