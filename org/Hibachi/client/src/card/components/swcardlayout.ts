/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardLayoutController {
    public cardClass;
	//@ngInject
    constructor(private $log) {
        console.log("This card class", this.cardClass);
    }

    public $onInit = function() {
    };

} 

class SWCardLayout implements ng.IDirective {
    public controller:any=SWCardLayoutController;
    public controllerAs:string = 'SwCardLayoutController';
   
    public scope = {};
    public bindToController = {
        cardClass: "@?"
    };
    public transclude:any = {
        cardView: '?swCardView',
    }
    
    public template:string = require('./cardlayout.html');
    
    public static Factory(){
        return () => new this();
    }
}
export {SWCardLayoutController, SWCardLayout};