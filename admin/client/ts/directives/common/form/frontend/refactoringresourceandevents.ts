/// <reference path='../../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../../client/typings/tsd.d.ts' />
/// <reference path='../../iterator.ts' />

module slatwalladmin {

    interface IActionHandler {
        getAction(): string;
        getParams(): Object;
        doAction(action: string, params: Object): IResponse;
    }

    class Errors {
        public static ACTION_NOT_FOUND = { text: "Action not found exception", id: 0 };
        public static INVALID_CONTENT_TYPE = { text: "Content-Type can't be empty exception", id: 1 };
    }

    interface IResourceHandler {
        contentType: Object;
        baseUrl: string;
        actionMethods: Array<string>;
        getContentType(): Object;
        getBaseUrl(): string;
        setBaseUrl(baseUrl: string);
        doAction(ActionHandler: IActionHandler, ResponseHandler: IResourceResponseHandler): void;
        actionExists(action: string): boolean;
        getActionMethods(): {};
        addActionMethod(action: string): void;
        addActionMethods(actionArray: Array<String>): void;
        actionExists(action: string): boolean;
    }

    interface IResourceResponseHandler {
        parseResponse(response: Object): Object;
        handleError(response: Object);
        handleSuccess(response: Object);
    }

    interface IResponse {
        hasErrors(): boolean;
        status: Object;
        data: Object;
    }

    export class ResourceHandler implements IResourceHandler {

        contentType = { 'Content-Type': <string> null };//<--usually application/x-www-form-urlencoded or application/json ...
        baseUrl = <string> "/index.cfm/api/scope/";     //<--default base public endpoint if using Slatwall public but could be /api/ for collections etc.

        actionMethods:Array<string> = null;

        getContentType = ():Object => {
            return this.contentType;
        }

        setContentType = (content: { "Content-Type": any }):ResourceHandler => {

            if (content == null || content == undefined) {
                this.throwError(Errors.INVALID_CONTENT_TYPE.text);
            }
            this.contentType = content;
            return this;
        }

        getBaseUrl = ():string => {
            return this.baseUrl;
        }

        setBaseUrl = (url):ResourceHandler => {
            this.baseUrl = url;
            return this;
        }

        doAction = (ActionHandler: IActionHandler, ResponseHandler: IResourceResponseHandler):void => {

            if (!this.actionExists(ActionHandler.getAction())) { this.throwError(Errors.ACTION_NOT_FOUND.text); }
            var response:IResponse = ActionHandler.doAction(ActionHandler.getAction(), ActionHandler.getParams());
            response.hasErrors() ? ResponseHandler.handleError(response.data) : ResponseHandler.handleSuccess(response.data);

        }

        getActionMethods = ():Array<string> => {
            return this.actionMethods;
        }

        actionExists = (action):boolean => {
            let actionIterator = this.getActionMethodsIterator();
            while (actionIterator.hasNext()) {
                if (actionIterator.next() == action) {
                    return true;
                }
            }
            return false;
        }

        getActionMethodsIterator = ():Iterator<any> => {
            return new Iterator(this.actionMethods);
        }

        addActionMethod = (action: string):ResourceHandler => {
            this.actionMethods.push(action);
            return this;
        }

        addActionMethods = (actionArray:Array<string>):ResourceHandler => {
            this.actionMethods = actionArray;
            return this;
        }
        throwError = (errorMsg: string):void => {
            throw (errorMsg);
        }
        constructor() { }
    }

    export class swTemplateController {

        constructor() {
            //Example using the ResourceHandler Class
            var accountResource = new ResourceHandler();
            accountResource.setBaseUrl("index.cfm/api/scope/").setContentType({ "Content-Type"  : "Application/Json"});
            var actionMethods = ['login','logout'];
            accountResource.addActionMethods(actionMethods);

            var actionHandler = {
                getAction : () => { return "login"; },
                getParams : () => { return {"userData" : {firstName: "Ian", lastName: "Hickey", emailAddress: "ian@mailinator.com"}} },
                doAction  : () => {
                    //Do something here to get a response.
                    console.log("Getting response");

                    //add the response into this response object
                    var response:IResponse = {
                        hasErrors: () => { return false; },
                        status: {statusCode : 404},
                        data: {messages : ['Message', 'Some Message']}
                    }
                    return response;
                 }
            };

            var actionResponseHandler = {
                parseResponse : () => { return {}; },
                handleError   : () => { console.log("Error Handled")},
                handleSuccess : () => { console.log("Success Handled")}
            };

            accountResource.doAction(actionHandler, actionResponseHandler);
            return this;
        }
    }

    export class swTemplate implements ng.IDirective {
        restrict = 'E';
        require = "^form";
        scope = {};
        transclude = true;
        bindToController = {
            object: "=?"
        };
        controller = swTemplateController;
        controllerAs = "swTemplate";
        templateUrl;
        $inject = ['partialsPath'];
        link = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes, formController: ng.IFormController) => {}
        formController: ng.IFormController;
        constructor(public partialsPath) {
            this.templateUrl = this.partialsPath + "swtest.html";
        }

    }
    angular.module('slatwalladmin').directive('swTemplate', ['partialsPath', (partialsPath) => new swTemplate(partialsPath)]);

}