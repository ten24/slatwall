/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWProcessCallerController{
	public utilityService;
    
    public action:string;
    public title:string;
    public titleRbKey:string;
    public text:string; 
	public type:string;
	public queryString:string;
	public processContext:string;
	//@ngInject
	constructor( private rbkeyService, 
				 public $templateRequest:ng.ITemplateRequestService, 
				 public $compile:ng.ICompileService,
				 public corePartialsPath,
				 public $scope,
				 public $element,
				 public $transclude:ng.ITranscludeFunction,utilityService,
			     hibachiPathBuilder
	){
		this.type = this.type || 'link';
		this.queryString = this.queryString || '';
	
		this.$templateRequest(hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+"processcaller.html").then((html)=>{
			var template = angular.element(html);
			this.$element.parent().append(template);
			$compile(template)(this.$scope);
		});
		
        if(angular.isDefined(this.titleRbKey)){
            this.title = this.rbkeyService.getRBKey(this.titleRbKey);
        }
        
        if(angular.isUndefined(this.title) && angular.isDefined(this.processContext)){
        	var entityName = this.action.split('.')[1].replace('process','');
        	this.title = this.rbkeyService.getRBKey('entity.' + entityName + '.process.' + this.processContext);
        }
        
        if(angular.isUndefined(this.text)){
            this.text = this.title;
        }
	}
}

class SWProcessCaller implements ng.IDirective{

	public restrict:string = 'E';
	public scope = {};
	public bindToController={
		action:"@",
		entity:"@",
		processContext:"@",
		hideDisabled:"=",
		type:"@",
		queryString:"@",
		text:"@",
		title:"@?",
        titleRbKey:"@?",
		'class':"@",
		icon:"=",
		iconOnly:"=",
		submit:"=",
		confirm:"=",
		disabled:"=",
		disabledText:"@",
		modal:"="
	};
	public controller=SWProcessCallerController
	public controllerAs="swProcessCaller";
	public static $inject = ['corePartialsPath','utilityService'];
	constructor(private corePartialsPath,private utilityService){
		this.corePartialsPath = corePartialsPath;
		this.utilityService = utilityService;
	}

	public static Factory(){
		var directive = (
			corePartialsPath,utilityService
		)=> new SWProcessCaller(
			corePartialsPath,utilityService
		);
		directive.$inject = [
			'corePartialsPath','utilityService'
		];
		return directive;
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
	}
}
 export{
	 SWProcessCaller
 }



