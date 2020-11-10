/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardListItemController {
    public strong:string = 'false';
    public style:string = 'padding-top:5px;padding-bottom:5px';

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {};

} 

class SWCardListItem implements ng.IDirective {
    public controller:any=SWCardListItemController;
    public controllerAs:string = 'SwCardListItemController';
    public scope = {};
    public bindToController = {
       title: "@?",
       value: "@?",
       strong: "@?",
       style: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardlistitem.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        console.log("Getting new list item");
        var component:ng.IDirectiveFactory=(cardPartialsPath,hibachiPathBuilder)=>new SWCardListItem(cardPartialsPath, hibachiPathBuilder);
        component.$inject = ['cardPartialsPath','hibachiPathBuilder']
        return component;
    }

}
export {SWCardListItemController, SWCardListItem};