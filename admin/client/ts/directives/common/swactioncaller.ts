/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWActionCallerController{
        
        constructor(private utilityService:slatwalladmin.UtilityService, private $slatwall:ngSlatwall.SlatwallService){
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
			
			
			
			/*
			<cfif attributes.modal && not attributes.disabled && not attributes.modalFullWidth >
				<cfset attributes.class &= " modalload" />
			</cfif>
			
			<cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
				<cfset attributes.class &= " disabled" />
			</cfif>
			*/
			
			/*
			<cfif attributes.hibachiScope.authenticateAction(action=attributes.action) || (attributes.type eq "link" && attributes.iconOnly)>
				<cfif attributes.type eq "link">
					<cfoutput><a title="#attributes.title#" class="#attributes.class#" target="_self" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</a></cfoutput>
				<cfelseif attributes.type eq "list">
					<cfoutput><li><a title="#attributes.title#" class="#attributes.class#" target="_self" href="#attributes.hibachiScope.buildURL(action=attributes.action,querystring=attributes.querystring)#"<cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</a></li></cfoutput> 
				<cfelseif attributes.type eq "button">
					<cfoutput><button class="#attributes.class#" title="#attributes.title#"<cfif len(attributes.name)> name="#attributes.name#" value="#attributes.action#"</cfif><cfif attributes.modal && not attributes.disabled> data-toggle="modal" data-target="##adminModal"</cfif><cfif attributes.disabled> data-disabled="#attributes.disabledtext#"<cfelseif attributes.confirm> data-confirm="#attributes.confirmtext#"</cfif><cfif attributes.submit>type="submit"</cfif><cfif len(attributes.id)>id="#attributes.id#"</cfif>>#attributes.icon##attributes.text#</button></cfoutput>
				<cfelseif attributes.type eq "submit">
					<cfoutput>This action caller type has been discontinued</cfoutput>
				</cfif>
			</cfif>
			*/
        }
        
        public getAction = ():string =>{
            return this.action;    
        }
        
        public getActionItem = ():string =>{
            return this.utilityService.listLast(this.action,'.');
        }
        
        public getActionItemEntityName = ():string =>{
            var firstFourLetters = this.utilityService.left(this.getActionItem(),4);
            var firstSixLetters = this.utilityService.left(this.getActionItem(),6);
            var minus4letters = this.utilityService.right(this.getActionItem(),4);
            var minus6letters = this.utilityService.right(this.getActionItem(),6);
            
            var actionItemEntityName = "";
            if(firstFourLetters === 'list' && this.getActionItem().length > 4){
                actionItemEntityName = minus4letters;
            }else if(firstFourLetters === 'edit' && this.getActionItem().length > 4){
                actionItemEntityName = minus4letters;
            }else if(firstFourLetters === 'save' && this.getActionItem().length > 4){
                actionItemEntityName = minus4letters;
            }else if(firstSixLetters === 'create' && this.getActionItem().length > 6){
                actionItemEntityName = minus6letters; 
            }else if(firstSixLetters === 'detail' && this.getActionItem().length > 6){
                actionItemEntityName = minus6letters;
            }else if(firstSixLetters === 'delete' && this.getActionItem().length > 6){
                actionItemEntityName = minus6letters;
            }
            return actionItemEntityName;
        }
        
        public getTitle = ():string =>{
            //if title is undefined then use text
            if(angular.isUndefined(this.title) || !this.title.length){
                this.title = this.text;
            }    
            return this.title;
        }
		
		private getTextByRBKeyByAction = (actionItemType:string, plural:boolean=false):string =>{
			var navRBKey = this.$slatwall.getRBKey('admin.define.'+actionItemType+'_nav');
			if(plural){
				var entityRbKey = this.$slatwall('entity.'+this.getActionItemEntityName()+'_plural');
				var replaceKey = '${itemEntityNamePlural}';
			}else{
				var entityRbKey = this.$slatwall('entity.'+this.getActionItemEntityName());
				var replaceKey = '${itemEntityName}';
			}
			
			return this.utilityService.replaceAll(navRBKey,replaceKey, entityRBKey);
		}
		
		public getText = ():string =>{
			//if we don't have text then make it up based on rbkeys
			if(angular.isUndefined(this.text) || (angular.isDefined(this.text) && !this.text.length)){
				this.text = this.$slatwall.getRBKey(this.utilityService.replaceAll(getAction(),":",".")+'_nav');
				var minus8letters = this.utilityService.right(this.text,8);
				//if rbkey is still missing. then can we infer it
				if(minus8letters === '_missing'){
					var firstFourLetters = this.utilityService.left(this.getActionItem(),4);
					var firstSixLetters = this.utilityService.left(this.getActionItem(),6);
					var minus4letters = this.utilityService.right(this.getActionItem(),4);
					var minus6letters = this.utilityService.right(this.getActionItem(),6);
					
					if(firstFourLetters === 'list' && this.getActionItem().length > 4){
						this.text = this.getTextByRBKeyByAction('list' ,true);
					}else if(firstFourLetters === 'edit' && this.getActionItem().length > 4){
						var navRBKey = this.$slatwall.getRBKey('admin.define.edit_nav');
						var entityRbKey = this.$slatwall('entity.'+this.getActionItemEntityName());
						this.text = this.utilityService.replaceAll(navRBKey,'${itemEntityName}', entityRBKey);
					}else if(firstFourLetters === 'save' && this.getActionItem().length > 4){
						var navRBKey = this.$slatwall.getRBKey('admin.define.save_nav');
						var entityRbKey = this.$slatwall('entity.'+this.getActionItemEntityName());
						this.text = this.utilityService.replaceAll(navRBKey,'${itemEntityName}', entityRBKey);
					}else if(firstSixLetters === 'create' && this.getActionItem().length > 6){
						var navRBKey = this.$slatwall.getRBKey('admin.define.create_nav');
						var entityRbKey = this.$slatwall('entity.'+this.getActionItemEntityName());
						this.text = this.utilityService.replaceAll(navRBKey,'${itemEntityName}', entityRBKey);
					}else if(firstSixLetters === 'detail' && this.getActionItem().length > 6){
						actionItemEntityName = minus6letters;
					}else if(firstSixLetters === 'delete' && this.getActionItem().length > 6){
						actionItemEntityName = minus6letters;
					}
					return actionItemEntityName;
				}
				
				
			}
			return this.text
		}
    
        public getDisabled = ():boolean =>{
            //if item is disabled
            if(angular.isDefined(this.disabled) && this.disabled){
                return true;
            }else{
                return false;    
            }
        }
        
        public getDisabledText = ():string =>{
            if(this.getDisabled()){
                //and no disabled text specified
                if(angular.isUndefined(this.disabledtext) || !this.disabledtext.length ){
                    var disabledrbkey = this.utilityService.replaceAll(this.action,':','.')+'_disabled';
                    this.disabledtext = $slatwall.getRBKey(disabledrbkey);
                }
                //add disabled class
                this.class += " s-btn-disabled";
                this.confirm = false; 
                return this.disabledtext;
            }
            
            return "";  
        }
        
        public getConfirm = ():boolean =>{
            if(angular.isDefined(this.confirm) && this.confirm){
                return true;    
            }else{
                return false;    
            }
        }
        
        public getConfirmText = ():string =>{
            if(this.getConfirm() ){
                if(angular.isUndefined(this.confirmtext) && this.confirmtext.length){
                    var confirmrbkey = this.utilityService.replaceAll(this.action,':','.')+'_confirm';
                    this.confirmtext = $slatwall.getRBKey(confirmrbkey);
                    /*<cfif right(attributes.confirmtext, "8") eq "_missing">
                        <cfset attributes.confirmtext = replace(attributes.hibachiScope.rbKey("admin.define.delete_confirm"),'${itemEntityName}', attributes.hibachiScope.rbKey('entity.#actionItemEntityName#'), "all") />
                    </cfif>*/
                }
                this.class += " alert-confirm";
                return this.confirm;
            }
            return "";    
        }
    }
	
	export class SWActionCaller implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            action:"@",
			text:"@",
			type:"@",
			queryString:"@",
			title:"@",
			class:"@",
			icon:"@",
			iconOnly:"=",
			name:"@",
			confirm:"=",
			confirmtext:"@",
			disabled:"=",
			disabledtext:"@",
			modal:"=",
			modalFullWidth:"=",
			id:"@"
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

