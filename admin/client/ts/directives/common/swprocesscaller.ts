/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWProcessCallerController{
		public static $inject = ['$templateRequest','$compile','partialsPath','$scope','$element','$transclude'];
        constructor(public $templateRequest:ng.ITemplateRequestService, public $compile:ng.ICompileService,public partialsPath,public $scope,public $element,public $transclude:ng.ITranscludeFunction){
			this.$templateRequest = $templateRequest;
			this.$compile = $compile;
			this.partialsPath = partialsPath;
			this.$scope = $scope;
			this.$element = $element;
			this.$transclude = this.$transclude;
            this.type = this.type || 'link';
			this.$templateRequest(this.partialsPath+"processcaller.html").then((html)=>{
				var template = angular.element(html);
				console.log(html);
				console.log(template);
				console.log(this.$element);
				this.$element.parent().append(template);
				$compile(template)($scope);
			});
			// this.$transclude();
            // this.$transclude((transElem,transScope)=>{
			// 	$element.append(transElem);
            //     console.log('tranclude');
            //     console.log(transElem);
            //     console.log(transScope);
            // });

			console.log('init process caller controller');
            console.log(this);
			
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
			querystring:"@",
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
		
		constructor(){
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swProcessCaller',[() => new SWProcessCaller()]);
}

