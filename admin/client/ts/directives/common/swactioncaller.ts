/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWActionCallerController{
        constructor(private utilityService:slatwalladmin.UtilityService,private $slatwall:ngSlatwall.SlatwallService){
			if(angular.isDefined(this.icon)){
				this.icon = '<i class="glyphicon glyphicon-'+this.icon+'"></i>';
			}
			
			var firstFourLetters = this.utilityService.left(actionItem,4);
			var firstSixLetters = this.utilityService.left(actionItem,6);
			var actionItem = this.utilityService.listLast(this.action,'.');
			var minus4letters = this.utilityService.right(actionItem,4);
			var minus6letters = this.utilityService.right(actionItem,6);
			
			var actionItemEntityName = "";
			if(firstFourLetters === 'list' && actionItem.length gt 4){
				actionItemEntityName = minus4letters;
			}else if(firstFourLetters === 'edit' && actionItem.length gt 4){
				actionItemEntityName = minus4letters;
			}else if(firstFourLetters === 'save' && actionItem.length gt 4){
				actionItemEntityName = minus4letters;
			}else if(firstSixLetters === 'create' && actionItem.length gt 6){
				actionItemEntityName = minus6letters;
			}else if(firstSixLetters === 'detail' && actionItem.length gt 6){
				actionItemEntityName = minus6letters;
			}else if(firstSixLetters === 'delete' && actionItem.length gt 6){
				actionItemEntityName = minus6letters;
			}
			//if text is blank or undefined
			if(angular.isUndefined(this.text) || (angular.isDefined(this.text) && this.text.length && angular.isUndefined(this.icon))){
				//get rbkey for type
				/*
				<cfset attributes.text = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#_nav") />
				
				<cfif right(attributes.text, 8) eq "_missing" >
					
					<cfif left(actionItem, 4) eq "list" and len(actionItem) gt 4>
						<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.list_nav'), "${itemEntityNamePlural}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#_plural'), "all") />
					<cfelseif left(actionItem, 4) eq "edit" and len(actionItem) gt 4>
						<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.edit_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
					<cfelseif left(actionItem, 4) eq "save" and len(actionItem) gt 4>
						<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.save_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
					<cfelseif left(actionItem, 6) eq "create" and len(actionItem) gt 6>
						<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.create_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
					<cfelseif left(actionItem, 6) eq "detail" and len(actionItem) gt 6>
						<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.detail_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
					<cfelseif left(actionItem, 6) eq "delete" and len(actionItem) gt 6>
						<cfset attributes.text = replace(attributes.hibachiScope.rbKey('admin.define.delete_nav'), "${itemEntityName}", attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
					</cfif>
				
				</cfif>
				
				<cfif right(attributes.text, 8) eq "_missing" >
					<cfset attributes.text = attributes.hibachiScope.rbKey("#Replace(attributes.action, ":", ".", "all")#") />
				</cfif>*/
			}
			//if title is undefined then use text
			if(angular.isUndefined(this.title) || !this.title.length){
				this.title = this.text;
			}
			//if item is disabled
			if(angular.isDefined(this.disabled) && this.disabled){
				//and no disabled text specified
				if(angular.isUndefined(this.disabledtext) || !this.disabledtext.length ){
					var disabledrbkey = this.utilityService.replaceAll(this.action,':','.')+'_disabled';
					this.disabledtext = $slatwall.getRBKey(disabledrbkey);
				}
			}
			
        }
    }
	
	export class SWActionCaller implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            action:"@",
			text:"=",
			type:"=",
			queryString:"=",
			title:"=",
			class:"=",
			icon:"=",
			iconOnly:"=",
			name:"=",
			confirm:"=",
			confirmtext:"=",
			disabled:"=",
			disabledtext:"=",
			modal:"=",
			modalFullWidth:"=",
			id:"="
        };
        public controller=SWActionCallerController
        public controllerAs="swActionCaller";
		public templateUrl;
		
		constructor(private partialsPath:slatwalladmin.partialsPath,private utiltiyService:slatwalladmin.UtilityService,private $slatwall:ngSlatwall.SlatwallService){
			this.templateUrl = partialsPath+'actioncaller.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swActionCaller',['partialsPath','utilityService','$slatwall',(partialsPath,utilityService,$slatwall) => new SWActionCaller(partialsPath,utilityService,$slatwall)]);
}

