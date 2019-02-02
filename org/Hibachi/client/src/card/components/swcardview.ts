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
    public scope = {};
    public controllerAs:string = 'SwCardViewController';
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

    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardview.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
		var directive:ng.IDirectiveFactory = (
			cardPartialsPath, hibachiPathBuilder
		)=> new SWCardView(
            cardPartialsPath, hibachiPathBuilder
		);
		directive.$inject = ["cardPartialsPath",'hibachiPathBuilder'];
		return directive;
	}
}
export {SWCardViewController, SWCardView};