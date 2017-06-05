/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardHeaderController {
    
	//@ngInject
    constructor(private $log) {
    }

    public $onInit = function() {
        
    };

} 

class SWCardHeader implements ng.IComponentOptions {
    public controller:any=SWCardHeaderController;
    public controllerAs:string = 'SwCardHeaderController';
    public bindings:{[key: string]:string} = {
        addBorder: '@?'
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    public template:string = `
                <span ng-if="SwCardHeaderController.addBorder == 'true'">
                    <div class="s-title" style="border-bottom:2px solid #eee" ng-transclude></div>
                </span>
                <span ng-if="SwCardHeaderController.addBorder == 'false'">
                    <div class="s-title" style="border-bottom: none" ng-transclude></div>
                </span>
                `;
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardHeader();
    }
}
export {SWCardHeaderController, SWCardHeader};