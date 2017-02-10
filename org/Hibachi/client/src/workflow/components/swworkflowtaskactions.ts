/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWWorkflowTaskActionsController {
    private workflowTask;
    private openActions;
    private getWorkflowTaskActions;
    private saveWorkflowTaskAction;
    private setHidden;
    private addWorkflowTaskAction;
    private selectWorkflowTaskAction;
    private filterPropertiesList;
    private workflowTaskActions;
    private deleteEntity;
    private removeWorkflowTaskAction;
    private searchProcess;
    private showProcessOptions;
    private processOptions;
    private getProcessOptions;
    private selectProcess;
    private selectEmailTemplate;
    private finished;
    private workflow;
    private emailTemplateSelected;
    private printTemplateSelected;
    private selectPrintTemplate;
    private emailTemplateCollectionConfig;
    private printTemplateCollectionConfig;
    //@ngInject
    constructor(
        public $scope,
        public $log,
        public $hibachi,
        public metadataService,
        public collectionService,
        public workflowPartialsPath,
        public hibachiPathBuilder,
        public collectionConfigService,
        public observerService
    ){

        this.$log.debug('Workflow Task Actions Init');
        this.$log.debug(this.workflowTask);
        this.openActions = false;

        this.observerService.attach((item) =>{
            if(angular.isDefined(this.emailTemplateCollectionConfig)){
                this.emailTemplateCollectionConfig.clearFilters();
                this.emailTemplateCollectionConfig.addFilter("emailTemplateObject",item.value);
            }
            if(angular.isDefined(this.printTemplateCollectionConfig)){
                this.printTemplateCollectionConfig.clearFilters();
                this.printTemplateCollectionConfig.addFilter("printTemplateObject",item.value);
            }
        },'WorkflowWorkflowObjectOnChange');


        /**
         * Returns the correct object based on the selected object type.
         */
        var getObjectByActionType = (workflowTaskAction) =>{
            if (workflowTaskAction.data.actionType === 'email') {
                workflowTaskAction.$$getEmailTemplate();

            } else if (workflowTaskAction.data.actionType === 'print') {
                workflowTaskAction.$$getPrintTemplate();
            }
        };
        /**
         * --------------------------------------------------------------------------------------------------------
         * Returns workflow task action, and saves them to the scope variable workflowtaskactions
         * --------------------------------------------------------------------------------------------------------
         */
        this.getWorkflowTaskActions = ()=> {
            /***
             Note:
             This conditional is checking whether or not we need to be retrieving to
             items all over again. If we already have them, we won't make another
             trip to the database.

             ***/
            if(angular.isUndefined(this.workflowTask.data.workflowTaskActions)){
                var workflowTaskPromise = this.workflowTask.$$getWorkflowTaskActions();
                workflowTaskPromise.then( ()=> {
                    this.workflowTaskActions = this.workflowTask.data.workflowTaskActions;
                    angular.forEach(this.workflowTaskActions,  (workflowTaskAction) =>{
                        getObjectByActionType(workflowTaskAction);
                    });
                    this.$log.debug(this.workflowTaskActions);
                });
            }else{
                this.workflowTaskActions = this.workflowTask.data.workflowTaskActions;
            }
            if (angular.isUndefined(this.workflowTask.data.workflowTaskActions)) {
                this.workflowTask.data.workflowTaskActions = [];
                this.workflowTaskActions = this.workflowTask.data.workflowTaskActions;
            }
        };
        this.getWorkflowTaskActions();//Call get


        /**
         * --------------------------------------------------------------------------------------------------------
         * Saves the workflow task actions by calling the objects $$save method.
         * @param taskAction
         * --------------------------------------------------------------------------------------------------------
         */
        this.saveWorkflowTaskAction =  (taskAction, context) =>{
            this.$log.debug("Context: " + context);
            this.$log.debug("saving task action and parent task");
            this.$log.debug(taskAction);
            var savePromise = this.workflowTaskActions.selectedTaskAction.$$save();
            savePromise.then( () => {
                var taSavePromise = taskAction.$$save;
                //Clear the form by adding a new task action if 'save and add another' otherwise, set save and set finished
                if (context == 'add'){
                    this.$log.debug("Save and New");
                    this.addWorkflowTaskAction(taskAction);
                    this.finished = false;
                }else if (context == "finish"){
                    this.finished = true;
                }
            },(err)=>{
                angular.element('a[href="/##j-basic-2"]').click();
                console.warn(err);
            });
        }//<--end save

        /**
         * Sets the editing state to show/hide the edit screen.
         */
        this.setHidden = (task) =>{
            if(!angular.isObject(task)){ task = {};}

            if(angular.isUndefined(task.hidden)){

                task.hidden=false;
            }else{
                this.$log.debug("setHidden()", "Setting Hide Value To " + !task.hidden);
                task.hidden = !task.hidden;
            }
        };

        /**
         * --------------------------------------------------------------------------------------------------------
         * Adds workflow action items by calling the workflowTask objects $$addWorkflowTaskAction() method
         * and sets the result to scope.
         * @param taskAction
         * --------------------------------------------------------------------------------------------------------
         */
        this.addWorkflowTaskAction = (taskAction) => {
            var workflowTaskAction = this.workflowTask.$$addWorkflowTaskAction();
            this.selectWorkflowTaskAction(workflowTaskAction);
            this.$log.debug(this.workflow);
        };

        /**
         * --------------------------------------------------------------------------------------------------------
         * Selects a new task action and populates the task action properties.
         * --------------------------------------------------------------------------------------------------------
         */
        this.selectWorkflowTaskAction = (workflowTaskAction) => {
            this.$log.debug("Selecting new task action for editing: ");
            this.$log.debug(workflowTaskAction);
            this.finished = false;
            this.workflowTaskActions.selectedTaskAction = undefined;
            var filterPropertiesPromise = this.$hibachi.getFilterPropertiesByBaseEntityName(this.workflowTask.data.workflow.data.workflowObject, true);
            filterPropertiesPromise.then( (value) =>{
                this.filterPropertiesList = {
                    baseEntityName: this.workflowTask.data.workflow.data.workflowObject,
                    baseEntityAlias: "_" + this.workflowTask.data.workflow.data.workflowObject
                };
                this.metadataService.setPropertiesList(value, this.workflowTask.data.workflow.data.workflowObject);
                this.filterPropertiesList[this.workflowTask.data.workflow.data.workflowObject] = this.metadataService.getPropertiesListByBaseEntityAlias(this.workflowTask.data.workflow.data.workflowObject);
                this.metadataService.formatPropertiesList(this.filterPropertiesList[this.workflowTask.data.workflow.data.workflowObject], this.workflowTask.data.workflow.data.workflowObject);
                this.workflowTaskActions.selectedTaskAction = workflowTaskAction;

                this.emailTemplateSelected =  (this.workflowTaskActions.selectedTaskAction.data.emailTemplate) ? this.workflowTaskActions.selectedTaskAction.data.emailTemplate.data.emailTemplateName : '';

                this.emailTemplateCollectionConfig = this.collectionConfigService.newCollectionConfig("EmailTemplate");
                this.emailTemplateCollectionConfig.setDisplayProperties("emailTemplateID,emailTemplateName");
                this.emailTemplateCollectionConfig.addFilter("emailTemplateObject",this.workflowTask.data.workflow.data.workflowObject);


                this.printTemplateSelected =  (this.workflowTaskActions.selectedTaskAction.data.printTemplate) ? this.workflowTaskActions.selectedTaskAction.data.printTemplate.data.printTemplateName : '';

                this.printTemplateCollectionConfig = this.collectionConfigService.newCollectionConfig("PrintTemplate");
                this.printTemplateCollectionConfig.setDisplayProperties("printTemplateID,printTemplateName");
                this.printTemplateCollectionConfig.addFilter("printTemplateObject",this.workflowTask.data.workflow.data.workflowObject);

            });
        };
        /**
         * Overrides the confirm directive method deleteEntity. This is needed for the modal popup.
         */
        this.deleteEntity = (entity) =>{
            this.removeWorkflowTaskAction(entity);
        };
        /**
         * --------------------------------------------------------------------------------------------------------
         * Removes a workflow task action by calling the selected tasks $$delete method
         * and reindexes the list.
         * --------------------------------------------------------------------------------------------------------
         */
        this.removeWorkflowTaskAction =  (workflowTaskAction) => {
            var deletePromise = workflowTaskAction.$$delete();
            deletePromise.then( () =>{
                if (workflowTaskAction === this.workflowTaskActions.selectedTaskAction) {
                    delete this.workflowTaskActions.selectedTaskAction;
                }
                this.$log.debug("removeWorkflowTaskAction");
                this.$log.debug(workflowTaskAction);
                this.workflowTaskActions.splice(workflowTaskAction.$$actionIndex, 1);
                for (var i in this.workflowTaskActions) {
                    this.workflowTaskActions[i].$$actionIndex = i;
                }
            });
        };

        this.searchProcess = {
            name:''
        };

        /**
         * Watches for changes in the proccess
         */
        this.showProcessOptions = false;
        this.processOptions = [];
        //this.$scope.$watch('swWorkflowTaskActions.searchProcess.name', (newValue, oldValue)=>{
        //    if(newValue !== oldValue){
        //        this.getProcessOptions(this.workflowTask.data.workflow.data.workflowObject);
        //    }
        //});

        /**
         * Retrieves the proccess options for a workflow trigger action.
         */
        this.getProcessOptions = (objectName) =>{
            if(!this.processOptions.length){
                var proccessOptionsPromise = this.$hibachi.getProcessOptions(objectName);

                proccessOptionsPromise.then((value)=>{
                    this.$log.debug('getProcessOptions');
                    this.processOptions = value.data;

                });
            }
            this.showProcessOptions = true;

        };

        /**
         * Changes the selected process option value.
         */
        this.selectProcess = (processOption)=>{
            this.workflowTaskActions.selectedTaskAction.data.processMethod = processOption.value;
            this.searchProcess.name = processOption.name;

            this.workflowTaskActions.selectedTaskAction.forms.selectedTaskAction.$setDirty();
            //this.searchProcess = processOption.name;
            this.showProcessOptions = false;

        };



        this.selectEmailTemplate =  (item) => {
            if(angular.isDefined(this.workflowTaskActions.selectedTaskAction.data.emailTemplate)){
                this.workflowTaskActions.selectedTaskAction.data.emailTemplate.data.emailTemplateID = item.emailTemplateID;
            }else{
                var templateEmail = this.$hibachi.newEmailTemplate();
                templateEmail.data.emailTemplateID = item.emailTemplateID;
                this.workflowTaskActions.selectedTaskAction.$$setEmailTemplate(templateEmail);
            }
        };

        this.selectPrintTemplate =  (item) => {
            if(angular.isDefined(this.workflowTaskActions.selectedTaskAction.data.printTemplate)){
                this.workflowTaskActions.selectedTaskAction.data.printTemplate.data.printTemplateID = item.printTemplateID;
            }else{
                var templatePrint = this.$hibachi.newPrintTemplate();
                templatePrint.data.printTemplateID = item.printTemplateID;
                this.workflowTaskActions.selectedTaskAction.$$setPrintTemplate(templatePrint);
            }
        };
    }
}

class SWWorkflowTaskActions  implements ng.IDirective{

    public static $inject = ['workflowPartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'AE';
    public scope = {};

    public bindToController = {
        workflowTask: "="
    };
    public controller=SWWorkflowTaskActionsController;
    public controllerAs="swWorkflowTaskActions";

    constructor(
        public workflowPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.workflowPartialsPath) + "workflowtaskactions.html";
    }
    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    };

    public static Factory(){
        var directive = (
             workflowPartialsPath,
             hibachiPathBuilder
        )=> new SWWorkflowTaskActions(
            workflowPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'workflowPartialsPath', 'hibachiPathBuilder'];

        return directive;
    }
}
export{
    SWWorkflowTaskActions
}