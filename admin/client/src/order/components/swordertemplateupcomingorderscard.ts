/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateUpcomingOrdersCardController{

	public frequencyTerm:any;

    public scheduledOrderDates:string;
    public startDate:Date; 
    public title:string; 

	constructor(public $hibachi,
				public observerService,
				public rbkeyService
	){
		if(this.title == null){
			this.title = this.rbkeyService.rbKey('entity.orderTemplate.scheduledOrderDates');
		}
		
        if( this.startDate == null && 
        	this.scheduledOrderDates != null && 
        	this.scheduledOrderDates.length
        ){
        	var firstDate = this.scheduledOrderDates.split(',')[0];
        	this.startDate = Date.parse(firstDate);
        }
	}

}

class SWOrderTemplateUpcomingOrdersCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        scheduledOrderDates:'@',
        frequencyTerm:'<?',
        title:"@?"
	};
	public controller=SWOrderTemplateUpcomingOrdersCardController;
	public controllerAs="swOrderTemplateUpcomingOrdersCard";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateUpcomingOrdersCard(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateupcomingorderscard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateUpcomingOrdersCard
};

