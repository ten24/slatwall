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
    
    public template:string = require('./cardheader.html');
    
    public static Factory(){
        return () => new this();
    }
}
export {SWCardHeaderController, SWCardHeader};