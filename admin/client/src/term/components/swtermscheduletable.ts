/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTermScheduleTableController{

    public term:any;
    public scheduledDates = [];
    public startDate:Date; 

	constructor(public termService){
	    this.scheduledDates = termService.getTermScheduledDates(this.term, this.startDate);
	}

}

class SWTermScheduleTable implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
        term:"<?",
        scheduledDates:"<?",
        startDate:"<?"
	};
	public controller=SWTermScheduleTableController;
	public controllerAs="swTermScheduleTable";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    termPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWTermScheduleTable(
			termPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'termPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private termPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(termPartialsPath) + "/termscheduletable.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWTermScheduleTable
};

