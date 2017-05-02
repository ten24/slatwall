/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardIconController {
    public iconMultiplier:string = "1x";

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

class SWCardIcon implements ng.IComponentOptions {
    public controller:any=SWCardIconController;
    public controllerAs:string = 'SwCardIconController';
    public bindings:{[key: string]:string} = {
        iconName: "@?",
        iconMultiplier: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    public template:string = `
    <div class="col-xs-1 col-sm-1 col-md-2 col-lg-2 s-icon" ng-transclude>
        <i ng-class="{'fa fa-shopping-cart fa-{{SwCardIconController.iconMultiplier}}':SwCardIconController.iconName == 'shopping-cart'}"></i>
        <i ng-class="{'fa fa-user fa-{{SwCardIconController.iconMultiplier}}':SwCardIconController.iconName == 'user'}"></i>
        <i ng-class="{'fa fa-calendar fa-{{SwCardIconController.iconMultiplier}}':SwCardIconController.iconName == 'calendar'}"></i>
        <i ng-class="{'fa fa-building fa-{{SwCardIconController.iconMultiplier}}':SwCardIconController.iconName == 'building'}"></i>
    </div>
            `;
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardIcon();
    }
}
export {SWCardIconController, SWCardIcon};