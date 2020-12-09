/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardHeaderController {
    
	//@ngInject
    constructor(private $log) {
    }

    public $onInit = function() {
        
    };

} 

class SWCardHeader implements ng.IDirective {
    public controller:any=SWCardHeaderController;
    public controllerAs:string = 'SwCardHeaderController';
    public scope = {};
    public bindToController:{[key: string]:string} = {
        addBorder: '@?'
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardheader.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var component:ng.IDirectiveFactory=(cardPartialsPath,hibachiPathBuilder)=>new SWCardHeader(cardPartialsPath, hibachiPathBuilder);
        component.$inject = ['cardPartialsPath','hibachiPathBuilder']
        return component;
    }
}
export {SWCardHeaderController, SWCardHeader};