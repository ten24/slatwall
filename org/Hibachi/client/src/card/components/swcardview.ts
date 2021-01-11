/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardViewController {
    public cardTitle:string;
    public cardBody:string;
    public cardSize:string='md';
	//@ngInject
    constructor(private $log) {}

} 

class SWCardView implements ng.IDirective {
    public controller:any=SWCardViewController;
    public controllerAs:string = 'SwCardViewController';
   
    public scope = {};
    public bindToController = {
        cardTitle: "@?",
        cardBody: "@?",
        cardSize: "@?" //sm, md, lg
    };
    
    public transclude:any = {
        cardIcon: '?swCardIcon',
        cardHeader: '?swCardHeader',
        cardBody: '?swCardBody',
        listItem: '?swCardListItem',
        progressBar: '?swCardProgressBar'
    }

    public template:string = require('./cardview.html');
    
    public static Factory(){
        return () => new this();
    }
}
export {SWCardViewController, SWCardView};