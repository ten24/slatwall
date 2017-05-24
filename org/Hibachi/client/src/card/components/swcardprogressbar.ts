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

class SWCardProgressBar implements ng.IComponentOptions {
    public controller:any=SWCardProgressBarController;
    public controllerAs:string = 'SwCardProgressBarController';
    public bindings:{[key: string]:string} = {
        valueMin: "@?",
        valueMax: "@?",
        valueNow: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    public template:string = `
        <div class="row s-line-item" ng-transclude>
            <div class="col-xs-12">
                <div class="progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="{{SwCardProgressBarController.valueNow}}" aria-valuemin="{{SwCardProgressBarController.valueMin}}" aria-valuemax="{{SwCardProgressBarController.valueMax}}" style="width:{{SwCardProgressBarController.valueMax|'0'}}%;">
                        {{SwCardProgressBarController.valueNow|number :0}}% 
                    </div>
                </div>
            </div>
        </div>
            `;
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardProgressBar();
    }
}
export {SWCardProgressBarController, SWCardProgressBar};