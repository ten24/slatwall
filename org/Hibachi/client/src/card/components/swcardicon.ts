/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardIconController {
    public iconMultiplier:string = "1x";

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

class SWCardIcon implements ng.IDirective {
    public controller:any=SWCardIconController;
    public controllerAs:string = 'SwCardIconController';
    
    public scope = {};
    public bindToController:{[key: string]:string} = {
        iconName: "@?",
        iconMultiplier: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    
    public template:string = require('./cardicon.html');
    
    public static Factory(){
        return () => new this();
    }
}
export {SWCardIconController, SWCardIcon};