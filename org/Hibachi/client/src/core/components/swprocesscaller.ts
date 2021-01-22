/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

const processCallerTemplateString = require("./processcaller.html");

class SWProcessCallerController{

    public action:string;
    public title:string;
    public titleRbKey:string;
    public text:string; 
	public type:string;
	public queryString:string;
	public processContext:string;
	
	//@ngInject
	constructor( private rbkeyService, 
				 public $compile:ng.ICompileService,
				 public $scope,
				 public $element,
				 public $transclude : ng.ITranscludeFunction,
				 public $templateRequest : ng.ITemplateRequestService,
				 public utilityService
	){
		this.type = this.type || 'link';
		this.queryString = this.queryString || '';
		
		this.$templateRequest('processCallerTemplateString').then((html)=>{
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
	
    // @ngInject;
	constructor(private $templateCache: ng.ITemplateCacheService){}

	public static Factory(){
		return /** @ngInject; */ ($templateCache) => {
		    if( !$templateCache.get('processCallerTemplateString') ){
		        $templateCache.put('processCallerTemplateString', processCallerTemplateString);
		    }
		    return new this($templateCache);
		};
	}
}
 export{
	 SWProcessCaller
 }



