/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderTemplateTotalController{

	public orderTemplate;
    public total;

	constructor(public $hibachi,
				public observerService,
	            public orderTemplateService,
				public rbkeyService
	){
		this.observerService.attach(this.refreshTotal, 'OrderTemplateTotalUpdate')
	}

	public refreshTotal = (data) =>{
		this.total = data.total;
	}
}

class SWOrderTemplateTotal implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		orderTemplate:'<'
	};
	public controller=SWOrderTemplateTotalController;
	public controllerAs="swOrderTemplateTotal";

	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWOrderTemplateTotal(
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
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatefrequencycard.html";
		this.restrict = "EA";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

	}

}

export {
	SWOrderTemplateTotal
};

