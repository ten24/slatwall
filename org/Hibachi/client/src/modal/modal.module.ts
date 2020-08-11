declare var angular: any;
declare var ng: any;

interface IModal {
    scope       : ng.IScope;
    close       : ng.IPromise<any> ;
    closed      : ng.IPromise<any>;
    element     : ng.IAugmentedJQuery;
    controller  : any ;
}

interface IShowModalOptions {
    component       ?: string;
    
    controller      ?: string;
    controllerAs    ?: string;
    
    template        ?: string;
    templateUrl     ?: string;
    
    bodyClass       ?: string;
    appendElement   ?: string | ng.IAugmentedJQuery;
    
    scope           ?: ng.IScope;
    preClose        ?: ( modal: IModal, result ?: any, delay ?: number) => void ;
    
    bindings        ?: any;
    
    locationChangeSuccess ?: boolean | number;

    inputs?; // internal
}

class ConfigOptions {
    public closeDelay = 0;
    //TODO: add more options here like, body-class
}

class ModalServiceProvider implements ng.IServiceProvider {

    private _config: ConfigOptions;
    
    constructor(){
        this._config = new ConfigOptions();
    }
    
    public configureOptions(overrides: ConfigOptions) {
        this._config =  {...this._config, ...overrides}; //merge with overriding 
    }
    
    /** @ngInject */
    public $get( $animate, $q, $http, $timeout, $compile, $document,  $rootScope, $controller, $templateRequest ) {
       
        return new ModalService(
            $animate, 
            $q, 
            $http, 
            $timeout, 
            $compile, 
            $document, 
            $rootScope, 
            $controller, 
            $templateRequest,
            this._config        
        );
    };
}

class ModalService {
    
    //  Track open modals.
    private openModals = [];

    constructor( 
        private $animate, 
        private $q                  : ng.IQService, 
        private $http               : ng.IHttpService, 
        private $timeout            : ng.ITimeoutService,
        private $compile            : ng.ICompileService, 
        private $document           : ng.IDocumentService,
        private $rootScope          : ng.IRootScopeService, 
        private $controller         : ng.IControllerService, 
        private $templateRequest    : ng.ITemplateRequestService, 
        private configOptions       : ConfigOptions
    ){ }
    
    //  Returns a promise which gets the template, either
    //  from the template parameter or via a request to the
    //  template url parameter.
    private getTemplate =  (template: string, templateUrl: string) : ng.IPromise<string>  => {
        var deferred = this.$q.defer<string>();
        
        if (template) {
            deferred.resolve(template);
        } 
        else if (templateUrl) {
            this.$templateRequest(templateUrl, true)
                .then( template => deferred.resolve(template) )
                .catch( e => deferred.reject(e) );
        } 
        else {
            deferred.reject("No template or templateUrl has been specified.");
        }
        return deferred.promise;
    };


    /** 
     * Adds an element to the DOM as the last child of its container
     * like append, but uses $animate to handle animations. Returns a
     * promise that is resolved once all animation is complete.
     * 
    */
    private appendChild = (parent, child ) => {
        
        var children = parent.children();
        
        if (children.length > 0) {
            return this.$animate.enter( child, parent, children [children.length - 1] );
        }
        return this.$animate.enter(child, parent);
    };

    /**
     * Close all modals, providing the given result to the close promise.
    */
    private closeModals =  ( result:any, delay:number) => {
        delay = delay || this.configOptions.closeDelay;
        
        while (this.openModals.length) {
            this.openModals[0].close(result, delay);
            this.openModals.splice(0, 1);
        }
    };

    /*
     *  Creates a controller with scope bindings
    */
    private buildComponentController = (options) => {
        return ['$scope', 'close', ($scope, close) => {
            $scope.close = close;
            $scope.bindings = options.bindings;
        }];
    };

    /*
     *  Creates a component template
     *
     *  Input:
     *
     *    {
     *       component: 'myComponent',
     *       bindings: {
     *         name: 'Foo',
     *         phoneNumber: '123-456-7890'
     *       }
     *    }
     *
     *  Output:
     *
     *    '<my-component close="close" name="bindings.name" phone-number="bindings.phoneNumber"></my-component>'
    */
    private buildComponentTemplate = (options) => {
      
        let kebabCase = (camelCase) => {
            return camelCase.replace(/([a-z0-9])([A-Z])/g, (_m, c1, c2) => { 
                return [c1, c2].join('-').toLowerCase(); 
            });
        };
        
        let makeBundingAttributes = (bindings) => {
            return Object.keys( bindings || {}).map( key =>  `${kebabCase(key)}="bindings.${key}"` ).join(' ');
        }
        
        return `<${kebabCase(options.component)} close="close" ${ makeBundingAttributes(options.bindings) } ></${kebabCase(options.component)}>`;
    };


    private setupComponentOptions = (options) => {
        options.controller = this.buildComponentController(options);
        options.template = this.buildComponentTemplate(options);
    };



    public showModal =  (options: IShowModalOptions) => {
       
        if (options.component) {
          this.setupComponentOptions(options);
        }
    
        //  Get the body of the document, we'll add the modal to this.
        // @ts-ignore
        const body = angular.element(this.$document[0].body);
    
        //  Create a deferred we'll resolve when the modal is ready.
        let deferred = this.$q.defer();
    
        //  Validate the input parameters.
        const controllerName = options.controller;
        if (!controllerName) {
            deferred.reject("No controller has been specified.");
            return deferred.promise;
        }
    
        //  Get the actual html of the template.
        this.getTemplate( options.template, options.templateUrl)
            .then( (template) => {
    
                //  The main modal object we will build.
                let modal = {} as IModal;
                //  Create a new scope for the modal.
                let modalScope = (options.scope || this.$rootScope).$new();
                
                if(options.bindings) {
                    modalScope.bindings = options.bindings;
                }
                
                let rootScopeOnClose = null;
                let locationChangeSuccess = options.locationChangeSuccess;
    
                //  Allow locationChangeSuccess event registration to be configurable.
                //  True (default) = event registered with defaultCloseDelay
                //  # (greater than 0) = event registered with delay
                //  False = disabled
                if (locationChangeSuccess === false) {
                    rootScopeOnClose = angular.noop;
                }
                else if ( angular.isNumber(locationChangeSuccess) && locationChangeSuccess >= 0) {
                    this.$timeout( () => {
                        rootScopeOnClose = this.$rootScope.$on('$locationChangeSuccess', inputs.close);
                    }, locationChangeSuccess as number);
                }
                else {
                    this.$timeout( () => {
                        rootScopeOnClose = this.$rootScope.$on('$locationChangeSuccess', inputs.close);
                    }, this.configOptions.closeDelay);
                }
    
    
                //  Create the inputs object to the controller - this will include
                //  the scope, as well as all inputs provided.
                //  We will also create a deferred that is resolved with a provided
                //  close function. The controller can then call 'close(result)'.
                //  The controller can also provide a delay for closing - this is
                //  helpful if there are closing animations which must finish first.
                let closeDeferred = this.$q.defer();
                let closedDeferred = this.$q.defer();
                let hasAlreadyBeenClosed = false;
    
                let inputs = {
                    
                    $scope: modalScope,
                    $element: null,
                    
                    close:  (result: any, delay: number) =>{
                        
                        if (hasAlreadyBeenClosed) {
                            return;
                        }
                        hasAlreadyBeenClosed = true;
                        
                        delay = delay || this.configOptions.closeDelay;
                        //  If we have a pre-close function, call it.
                        if( typeof options.preClose === 'function' ){
                            options.preClose(modal, result, delay);
                        }
                        if( delay === undefined || delay === null ){
                            delay = 0;
                        }
                        
                        this.$timeout( () => cleanUpClose(result) , delay);
                    }
                };
    
                //  If we have provided any inputs, pass them to the controller.
                if (options.inputs) angular.extend(inputs, options.inputs);
    
                //  Compile then link the template element, building the actual element.
                //  Set the $element on the inputs so that it can be injected if required.
                let linkFn       = this.$compile(template);
                let modalElement = linkFn(modalScope);
                inputs.$element  = modalElement;
    
                //  Create the controller, explicitly specifying the scope to use.
                let controllerObjBefore = modalScope[options.controllerAs];
                
                // https://github.com/angular/angular.js/blob/v1.6.10/src/ng/controller.js#L102
                // @ts-ignore 
                let modalController = this.$controller(options.controller, inputs, true, options.controllerAs);
    
                if (options.controllerAs && controllerObjBefore) {
                    angular.extend(modalController, controllerObjBefore);
                }
                
                modalScope.close = inputs.close;
    
                //  Then, append the modal to the dom.
                var appendTarget = body; // append to body when no custom append element is specified
                if (angular.isString(options.appendElement)) {
                    // query the document for the first element that matches the selector
                   // and create an angular element out of it.
                    appendTarget = angular.element( this.$document[0].querySelector(options.appendElement as string) );
    
                } 
                else if (options.appendElement) {
                    // append to custom append element
                    appendTarget = options.appendElement as ng.IAugmentedJQuery;
                }
    
                this.appendChild(appendTarget, modalElement);
    
                // Finally, append any custom classes to the body
                if (options.bodyClass) {
                    body[0].classList.add(options.bodyClass);
                }
    
                //  Populate the modal object...
                modal.controller = modalController;
                modal.scope = modalScope;
                modal.element = modalElement;
                modal.close = closeDeferred.promise;
                modal.closed = closedDeferred.promise;
    
                // $onInit is part of the component lifecycle introduced in AngularJS 1.6.x
                // Because it may not be defined on all controllers,
                // we must check for it before attempting to invoke it.
                // https://docs.angularjs.org/guide/component#component-based-application-architecture
                if (angular.isFunction(modal.controller.$onInit)) {
                    modal.controller.$onInit();
                }
    
                //  ...which is passed to the caller via the promise.
                deferred.resolve(modal);
    
                // Clear previous input focus to avoid open multiple modals on enter
                // @ts-ignore
                document.activeElement.blur();
    
                //  We can track this modal in our open modals.
                this.openModals.push( { modal: modal, close: inputs.close } );
    
                let cleanUpClose = (result) => {
    
                    //  Resolve the 'close' promise.
                    closeDeferred.resolve(result);
    
                    //  Remove the custom class from the body
                    if (options.bodyClass) { body[0].classList.remove(options.bodyClass); }
    
                    //  Let angular remove the element and wait for animations to finish.
                    this.$animate.leave(modalElement).then( () => {
                        // prevent error if modal is already destroyed
                        if (!modalElement) {
                            return;
                        }

                        //  Resolve the 'closed' promise.
                        closedDeferred.resolve(result);

                        //  We can now clean up the scope
                        modalScope.$destroy();

                        //  Remove the modal from the set of open modals.
                        for (var i = 0; i < this.openModals.length; i++) {
                            if (this.openModals[i].modal === modal) {
                                this.openModals.splice(i, 1);
                                break;
                            }
                        }

                        //  Unless we null out all of these objects we seem to suffer
                        //  from memory leaks, if anyone can explain why then I'd
                        //  be very interested to know.
                        inputs.close = null;
                        deferred = null;
                        closeDeferred = null;
                        modal = null;
                        inputs = null;
                        modalElement = null;
                        modalScope = null;
                    });
                    // remove event watcher
                    rootScopeOnClose && rootScopeOnClose();
                }
            })
            .then(null, function (error) { // 'catch' doesn't work in IE8.
                deferred.reject(error);
            })
            .catch(deferred.reject);
    
        return deferred.promise;
    };
}


let angularModalModule = angular.module('angular.modal.module',[])
	.provider("ModalService", ModalServiceProvider);
	
export {
    angularModalModule,
    IModal,
    ConfigOptions,
    ModalService,
    IShowModalOptions,
    ModalServiceProvider,
};
