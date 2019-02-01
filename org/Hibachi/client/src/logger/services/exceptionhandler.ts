/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/hibachiTypescript.d.ts" />
//depends on alert module
import {Alert} from "../../alert/model/alert";
import {AlertService} from "../../alert/service/alertservice";
/*<------------------------------------------------------------------------
    This is out main class where we actually handle the exception by
    instantiating the http config and passing it along with the
    exception and cause. Classes are more the Typescript methodology versus
    function notation - but this compiles down to the function we want.
    <------------------------------------------------------------------------*/
class ExceptionHandler {
    private static injector: ng.auto.IInjectorService;

    /** returning the ExceptionHandler bind here removes the circular dependancy
        that you would get from having exceptionHandler require $http <-- exceptionHandler --> $http
        */
    constructor(injector: ng.auto.IInjectorService) {
        //grab the injector we passed in
        ExceptionHandler.injector = injector;
        //return the bound static function.
        return <any>ExceptionHandler.handle.bind(ExceptionHandler);
    }

    private static handle(exception: string, cause: any) {
        var alertService:AlertService;
        if(exception){
            exception = exception.toString();
        }
        if(cause){
            cause = cause.toString();
        }
        console.error(exception);
        /** get $http and alertService from the injector */
        var http = this.injector.get<ng.IHttpService>('$http');
        alertService = this.injector.get<AlertService>('alertService');
        /**  use the angular serializer rather than jQuery $.param */
        var serializer: Function = this.injector.get<ng.IHttpService>('$httpParamSerializerJQLike')
        /* we use the IRequestConfig type here to get type protection on the object literal.
            alternativly, we could just cast to the correct type and drop the extra interface by
            using url: <string> "?slatAction=api:main.log" notation which does the same thing. */


        var requestConfig: ng.IRequestConfig = {
            url : "?'+hibachiConfig.action+'=api:main.log",
            method : "POST",
            data : serializer({exception: exception, cause: cause, apiRequest: true}),
            headers : {'Content-Type' : "application/x-www-form-urlencoded"}
        };

        /** notice I use the fat arrow for the anon function which preserves lexical scope. */
        http(requestConfig).error(
            data => {
                alertService.addAlert({ msg: exception, type: 'error' });
            }
        );
    }//<--end handle method
}//<--end class
//let angular know about our class. notive we pass in the $injector and instantiate the class in one go
//again using the fat arrow for scope.
export {
    ExceptionHandler
};















