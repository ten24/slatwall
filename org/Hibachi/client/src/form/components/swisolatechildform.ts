/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWIsolateChildFormController {
    // @ngInject
    constructor(

    ){
    }
}

class SWIsolateChildForm implements ng.IDirective {

    public restrict      = "A";
    public require       = '?form';
    public controller    = SWIsolateChildFormController;
    public controllerAs  = "swIsolateChildForm";
    public scope         = {};

   /**
    * Binds all of our variables to the controller so we can access using this
    */
    public bindToController = {

    };

    /**
    * Sets the context of this form
    */
    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any) =>
    {
      if (!formController) {
        return;
      }

      var parentForm = formController.$$parentForm;
      if (!parentForm) {
        return;
      }

      parentForm.$removeControl(formController);
    }

    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var directive = (
            coreFormPartialsPath,
            hibachiPathBuilder
        ) => new SWIsolateChildForm(
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = ['coreFormPartialsPath','hibachiPathBuilder'];
        return directive;
    }
    // @ngInject
    constructor( public coreFormPartialsPath, public hibachiPathBuilder) {

    }
}
export{
    SWIsolateChildForm
}