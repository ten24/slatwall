/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardBodyController {
    
	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

class SWCardBody implements ng.IComponentOptions {
    public controller:any=SWCardBodyController;
    public controllerAs:string = 'SwCardBodyController';
    public bindings:{[key: string]:string} = {};
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    public template:string = `
                    <div class="s-body" ng-transclude></div>
            `;
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardBody();
    }
}
export {SWCardBodyController, SWCardBody};