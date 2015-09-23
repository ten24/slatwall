/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWActionCallerController{
        public static $inject = ['$scope','$element','$templateRequest','$compile','partialsPath','utilityService','$slatwall'];
        constructor(private $scope,private $element,private $templateRequest:ng.ITemplateRequestService, private $compile:ng.ICompileService,private partialsPath, private utilityService:slatwalladmin.UtilityService, private $slatwall:ngSlatwall.SlatwallService){
            console.log('actioncaller');
            this.$scope = $scope;
            this.$element = $element;
			this.$templateRequest = $templateRequest;
            this.$compile = $compile;
            this.partialsPath = partialsPath;
            this.$slatwall = $slatwall;
			this.utilityService = utilityService;
            this.$templateRequest(this.partialsPath+"actioncaller.html").then((html)=>{
				var template = angular.element(html);
				console.log(html);
				console.log(template);
				console.log(this.$element);
				this.$element.parent().append(template);
				$compile(template)($scope);
                //need to perform init after promise completes
                this.init(); 
			});
        }
		
		public init = ():void =>{
//			this.class = this.utilityService.replaceAll(this.utilityService.replaceAll(this.getAction(),':',''),'.','') + ' ' + this.class;
//			this.type = this.type || 'link';
//			this.actionItem = this.getActionItem();
//			this.actionItemEntityName = this.getActionItemEntityName();
//			this.text = this.getText();
//			if(this.getDisabled()){
//				this.getDisabledText();
//			}else if(this.getConfirm()){
//				this.getConfirmText();
//			}
//			
//			if(this.modalFullWidth && !this.getDisabled()){
//				this.class = this.class + " modalload-fullwidth";
//			}
//			
//			if(this.modal && !this.getDisabled() && !this.modalFullWidth){
//				this.class = this.class + " modalload";
//			}
			
			/*need authentication lookup by api to disable
			<cfif not attributes.hibachiScope.authenticateAction(action=attributes.action)>
				<cfset attributes.class &= " disabled" />
			</cfif>
			*/
            console.log(this);
		}
        
        public getAction = ():string =>{
			
            return this.action || '';    
        }
        
        public getActionItem = ():string =>{
            return this.utilityService.listLast(this.getAction(),'.');
        }
        
        public getActionItemEntityName = ():string =>{
            var firstFourLetters = this.utilityService.left(this.actionItem,4);
            var firstSixLetters = this.utilityService.left(this.actionItem,6);
            var minus4letters = this.utilityService.right(this.actionItem,4);
            var minus6letters = this.utilityService.right(this.actionItem,6);
            
            var actionItemEntityName = "";
            if(firstFourLetters === 'list' && this.actionItem.length > 4){
                actionItemEntityName = minus4letters;
            }else if(firstFourLetters === 'edit' && this.actionItem.length > 4){
                actionItemEntityName = minus4letters;
            }else if(firstFourLetters === 'save' && this.actionItem.length > 4){
                actionItemEntityName = minus4letters;
            }else if(firstSixLetters === 'create' && this.actionItem.length > 6){
                actionItemEntityName = minus6letters; 
            }else if(firstSixLetters === 'detail' && this.actionItem.length > 6){
                actionItemEntityName = minus6letters;
            }else if(firstSixLetters === 'delete' && this.actionItem.length > 6){
                actionItemEntityName = minus6letters;
            }
            return actionItemEntityName;
        }
        
        public getTitle = ():string =>{
            //if title is undefined then use text
            if(angular.isUndefined(this.title) || !this.title.length){
                this.title = this.getText();
            }    
            return this.title;
        }
		
		private getTextByRBKeyByAction = (actionItemType:string, plural:boolean=false):string =>{
			var navRBKey = this.$slatwall.getRBKey('admin.define.'+actionItemType+'_nav');
			
			var entityRBKey = '';
			var replaceKey = '';
			if(plural){
				entityRBKey = this.$slatwall.getRBKey('entity.'+this.actionItemEntityName+'_plural');
				replaceKey = '${itemEntityNamePlural}';
			}else{
				entityRBKey = this.$slatwall.getRBKey('entity.'+this.actionItemEntityName);
				replaceKey = '${itemEntityName}';
			}
			
			return this.utilityService.replaceAll(navRBKey,replaceKey, entityRBKey);
		}
		
		public getText = ():string =>{
			//if we don't have text then make it up based on rbkeys
			if(angular.isUndefined(this.text) || (angular.isDefined(this.text) && !this.text.length)){
				this.text = this.$slatwall.getRBKey(this.utilityService.replaceAll(this.getAction(),":",".")+'_nav');
				var minus8letters = this.utilityService.right(this.text,8);
				//if rbkey is still missing. then can we infer it
				if(minus8letters === '_missing'){
					var firstFourLetters = this.utilityService.left(this.actionItem,4);
					var firstSixLetters = this.utilityService.left(this.actionItem,6);
					var minus4letters = this.utilityService.right(this.actionItem,4);
					var minus6letters = this.utilityService.right(this.actionItem,6);
					
					if(firstFourLetters === 'list' && this.actionItem.length > 4){
						this.text = this.getTextByRBKeyByAction('list' ,true);
					}else if(firstFourLetters === 'edit' && this.actionItem.length > 4){
						this.text = this.getTextByRBKeyByAction('edit' ,false);
					}else if(firstFourLetters === 'save' && this.actionItem.length > 4){
						this.text = this.getTextByRBKeyByAction('save' ,false);
					}else if(firstSixLetters === 'create' && this.actionItem.length > 6){
						this.text = this.getTextByRBKeyByAction('create' ,false);
					}else if(firstSixLetters === 'detail' && this.actionItem.length > 6){
						this.text = this.getTextByRBKeyByAction('detail' ,false);
					}else if(firstSixLetters === 'delete' && this.actionItem.length > 6){
						this.text = this.getTextByRBKeyByAction('delete' ,false);
					}
				}
				
				if(this.utilityService.right(this.text,8)){
					this.text = this.$slatwall.getRBKey(this.utilityService.replaceAll(this.getAction(),":","."));
				}
				
			}
			if(!this.title || (this.title && !this.title.length)){
				this.title = this.text;
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
		public restrict:string = 'EA';
        public scope={}; 
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
        public controller=SWActionCallerController;
        public controllerAs="swActionCaller";
		public templateUrl;
        
		constructor(private partialsPath:slatwalladmin.partialsPath,private utiltiyService:slatwalladmin.UtilityService,private $slatwall:ngSlatwall.SlatwallService){
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
		}
	}
    
	angular.module('slatwalladmin').directive('swActionCaller',[() => new SWActionCaller()]);
}

