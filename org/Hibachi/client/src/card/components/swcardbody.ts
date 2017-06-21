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
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardbody.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var component:ng.IDirectiveFactory=(cardPartialsPath,hibachiPathBuilder)=>new SWCardBody(cardPartialsPath, hibachiPathBuilder);
        component.$inject = ['cardPartialsPath','hibachiPathBuilder']
        return component;
    }
}
export {SWCardBodyController, SWCardBody};