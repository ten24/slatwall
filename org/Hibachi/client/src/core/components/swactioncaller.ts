/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWActionCallerController{
    public type:string;
    public confirm:any;
    public action:string;
    public actionItem:string;
    public title:string;
    public titleRbKey:string;
    public class:string;
    public confirmtext:string;
    public disabledtext:string;
    public text:string;
    public disabled:boolean;
    public actionItemEntityName:string;
    public hibachiPathBuilder:any;

    public actionUrl:string;
    public queryString:string;
    public isAngularRoute:boolean;
    public formController:any;
    public form:ng.IFormController;
    //@ngInject
    constructor(
        private $scope,
        private $element,
        private $templateRequest:ng.ITemplateRequestService,
        private $compile:ng.ICompileService,
        public $timeout,
        private corePartialsPath,
        private utilityService,
        private $hibachi,
        private rbkeyService,
        hibachiPathBuilder
    ){
        this.$scope = $scope;
        this.$element = $element;
        this.$timeout = $timeout;
        this.$templateRequest = $templateRequest;
        this.$compile = $compile;
        this.rbkeyService = rbkeyService;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        this.hibachiPathBuilder = hibachiPathBuilder;

        this.$templateRequest(this.hibachiPathBuilder.buildPartialsPath(corePartialsPath)+"actioncaller.html").then((html)=>{
            var template = angular.element(html);
            this.$element.parent().append(template);
            $compile(template)($scope);
            //need to perform init after promise completes
            //this.init();
        });
    }


    public $onInit = ():void =>{

        //Check if is NOT a ngRouter
        if(angular.isUndefined(this.isAngularRoute)){
            this.isAngularRoute = this.utilityService.isAngularRoute();
        }
        if(!this.isAngularRoute){
            this.actionUrl= this.$hibachi.buildUrl(this.action,this.queryString);
        }else{
            this.actionUrl = '#!/entity/'+this.action+'/'+this.queryString.split('=')[1];
        }

//			this.class = this.utilityService.replaceAll(this.utilityService.replaceAll(this.getAction(),':',''),'.','') + ' ' + this.class;
        this.type = this.type || 'link';
        if(angular.isDefined(this.titleRbKey)){
            this.title = this.rbkeyService.getRBKey(this.titleRbKey);
        }
        if(angular.isUndefined(this.text)){
            this.text = this.title;
        }

            if (this.type == "button"){
                //handle submit.
                /** in order to attach the correct controller to local vm, we need a watch to bind */
                var unbindWatcher = this.$scope.$watch(() => { return this.formController; }, (newValue, oldValue) => {
                    if (newValue !== undefined){
                        this.formController = newValue;

                    }

                    unbindWatcher();
                });

            }
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


    }

    public submit = () => {
        this.$timeout(()=>{
            if(this.form.$valid){
                this.formController.submit(this.action);
            }
            this.form.$submitted = true;
        });
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
        var navRBKey = this.rbkeyService.getRBKey('admin.define.'+actionItemType+'_nav');

        var entityRBKey = '';
        var replaceKey = '';
        if(plural){
            entityRBKey = this.rbkeyService.getRBKey('entity.'+this.actionItemEntityName+'_plural');
            replaceKey = '${itemEntityNamePlural}';
        }else{
            entityRBKey = this.rbkeyService.getRBKey('entity.'+this.actionItemEntityName);
            replaceKey = '${itemEntityName}';
        }

        return this.utilityService.replaceAll(navRBKey,replaceKey, entityRBKey);
    }

    public getText = ():string =>{
        //if we don't have text then make it up based on rbkeys
        if(angular.isUndefined(this.text) || (angular.isDefined(this.text) && !this.text.length)){
            this.text = this.rbkeyService.getRBKey(this.utilityService.replaceAll(this.getAction(),":",".")+'_nav');
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
                this.text = this.rbkeyService.getRBKey(this.utilityService.replaceAll(this.getAction(),":","."));
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
                this.disabledtext = this.rbkeyService.getRBKey(disabledrbkey);
            }
            //add disabled class
            this.class += " btn-disabled";
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
                this.confirmtext = this.rbkeyService.getRBKey(confirmrbkey);
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

class SWActionCaller implements ng.IDirective{
    public restrict:string = 'EA';
    public scope:any={};
    public bindToController:any={
        action:"@",
        text:"@",
        type:"@",
        queryString:"@",
        title:"@?",
        titleRbKey:"@?",
        'class':"@",
        icon:"@",
        iconOnly:"=",
        name:"@",
        confirm:"=",
        confirmtext:"@",
        disabled:"=",
        disabledtext:"@",
        modal:"=",
        modalFullWidth:"=",
        id:"@",
        isAngularRoute:"=?"
    };
    public require={formController:"^?swForm",form:"^?form"};
    public controller=SWActionCallerController;
    public controllerAs="swActionCaller";
    public templateUrl;
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
            partialsPath,
            utiltiyService,
            $hibachi
        ) => new SWActionCaller(
            partialsPath,
            utiltiyService,
            $hibachi
        );
        directive.$inject = [
            'partialsPath',
            'utilityService',
            '$hibachi'
        ];
        return directive;
    }

    constructor(
        public partialsPath,
        public utiltiyService,
        public $hibachi
        ){
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        if (angular.isDefined(scope.swActionCaller.formController)){
             scope.formController = scope.swActionCaller.formController;
        }
    }
}
export{
    SWActionCaller,
    SWActionCallerController
}

