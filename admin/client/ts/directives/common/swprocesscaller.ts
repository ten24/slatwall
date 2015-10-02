/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWProcessCallerController{
		public static $inject = ['$templateRequest','$compile','partialsPath','$scope','$element','$transclude','utilityService'];
        constructor(public $templateRequest:ng.ITemplateRequestService, public $compile:ng.ICompileService,public partialsPath,public $scope,public $element,public $transclude:ng.ITranscludeFunction,utilityService){
			this.$templateRequest = $templateRequest;
			this.$compile = $compile;
			this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.type = this.type || 'link';
            this.queryString = this.queryString || '';
            this.$scope = $scope;
            this.$element = $element;
            this.$transclude = this.$transclude;
			this.$templateRequest(this.partialsPath+"processcaller.html").then((html)=>{
				var template = angular.element(html);
				this.$element.parent().append(template);
				$compile(template)(this.$scope);
			});
        }
    }
	
	export class SWProcessCaller implements ng.IDirective{
		
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
			title:"@",
			class:"@",
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
		public static $inject = ['partialsPath','utilityService'];
		constructor(private partialsPath,private utilityService){
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		}
	}
    
	angular.module('slatwalladmin').directive('swProcessCaller',['partialsPath','utilityService',(partialsPath,utilityService) => new SWProcessCaller(partialsPath,utilityService)]);
}

