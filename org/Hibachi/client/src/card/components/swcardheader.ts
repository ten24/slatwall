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
        style: '@?'
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    public template:string = `
                <div class="s-title" style="{{(SwCardHeaderController.style||'border-bottom:2px solid #eee')}}" ng-transclude></div>`;
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardHeader();
    }
}
export {SWCardHeaderController, SWCardHeader};