/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardProgressBarController {
    public valueMin:number = 0;
    public valueMax:number = 100;
    public valueNow:number = 0;

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {};

} 

class SWCardProgressBar implements ng.IDirective {
    public controller:any=SWCardProgressBarController;
    public controllerAs:string = 'SwCardProgressBarController';
    
    public scope = {};
    public bindToController:{[key: string]:string} = {
        valueMin: "@?",
        valueMax: "@?",
        valueNow: "@?"
    };
    
    public transclude:boolean = true;
    public require:string = "^SWCardView";

    public template:string = require('./cardprogressbar.html');
    
    public static Factory(){
        return () => new this();
    }
}
export {SWCardProgressBarController, SWCardProgressBar};