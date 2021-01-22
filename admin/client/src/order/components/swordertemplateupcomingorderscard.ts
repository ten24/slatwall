/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateUpcomingOrdersCardController{

	public orderTemplate:any;

	public frequencyTerm:any;

    public scheduledOrderDates:string;
    public startDate:Date; 
    public startDateFormatted:string;
    public title:string; 
    
    public includeModal=true;

	constructor(public $timeout,
				public $hibachi,
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){
		this.observerService.attach(this.updateSchedule, 'OrderTemplateUpdateScheduleSuccess');
		this.observerService.attach(this.updateSchedule, 'OrderTemplateUpdateFrequencySuccess');
		
		if(this.title == null){
			this.title = this.rbkeyService.rbKey('entity.orderTemplate.scheduledOrderDates');
		}
		
        if( this.startDate == null && 
        	this.scheduledOrderDates != null && 
        	this.scheduledOrderDates.length
        ){
        	var firstDate = this.scheduledOrderDates.split(',')[0];
        	this.setStartDate(Date.parse(firstDate));
        	
        }
        
        if(this.orderTemplate['orderTemplateStatusType_systemCode'] === 'otstCancelled'){
			this.includeModal = false;
		}
	}
	
	public setStartDate(date){
		this.startDate = date;
		this.startDateFormatted = (this.startDate.getMonth() + 1) + '/' +  
								  this.startDate.getDate() + '/' +  
								  this.startDate.getFullYear();
	}
	
	public updateSchedule = (data) =>{
		
		if( data == null ) return;
		
		if( data.frequencyTerm != null){
			this.frequencyTerm = null;
			
			this.$timeout(()=>{
				this.frequencyTerm = data.frequencyTerm;
			});
		}
		
		if( data.scheduleOrderNextPlaceDateTime != null ){
			this.startDate = null;
		
			this.$timeout(()=>{
				this.setStartDate(Date.parse(data.scheduleOrderNextPlaceDateTime));
			});
		}
	}

}

class SWOrderTemplateUpcomingOrdersCard implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		orderTemplate:'<?',
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

