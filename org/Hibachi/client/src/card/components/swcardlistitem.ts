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

    public template:string = require('./cardlistitem.html');
    
    public static Factory(){
        return () => new this();
    }

}
export {SWCardListItemController, SWCardListItem};