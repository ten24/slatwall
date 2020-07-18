/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardBodyController {
    
	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

/**
 * This is a wrapper class for the card components that allow you to define the columns.
 */
class SWCardBody implements ng.IDirective {
    public controller:any=SWCardBodyController;
    public controllerAs:string = 'SwCardBodyController';
   
    public scope = {};
    public bindToController:{[key: string]:string} = {};
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    
    public template:string = require('./cardbody.html');
    public static Factory(){
        return () => new this();
    }
}
export {SWCardBodyController, SWCardBody};