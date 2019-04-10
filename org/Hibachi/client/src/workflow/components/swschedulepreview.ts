class SWSchedulePreviewController {
      //@ngInject
        constructor(){}
}

class SWSchedulePreview implements ng.IDirective{

    public static $inject = ['workflowPartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'AE';
    public scope = {};

    public bindToController = {
        schedule: "="
    };
    public controller=SWSchedulePreviewController;
    public controllerAs="swSchedulePreview";

      //@ngInject
        constructor(
        public workflowPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.workflowPartialsPath) + "schedulepreview.html";
    }

    public static Factory(){
        var directive = (
            workflowPartialsPath,
            hibachiPathBuilder
        )=> new SWSchedulePreview(
            workflowPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'workflowPartialsPath', 'hibachiPathBuilder'];

        return directive;
    }
}
export{
    SWSchedulePreview
}