



import { alertmodule } from "../alert/alert.module";
import { ExceptionHandler } from "./services/exceptionhandler";
import * as angular from "angular";

var loggermodule = angular.module('logger', [alertmodule.name])
	.run([function () {
	}])
//.factory('$exceptionHandler', ['$injector', ($injector) => new ExceptionHandler($injector)]);;

export {
	loggermodule
}