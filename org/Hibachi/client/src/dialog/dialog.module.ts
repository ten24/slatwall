

//services
import { DialogService } from "./services/dialogservice";
//controllers
import { PageDialogController } from "./controllers/pagedialog";
import * as angular from "angular";

var dialogmodule = angular.module('hibachi.dialog', []).config(() => {
})
	//services
	.service('dialogService', DialogService)
	//controllers
	.controller('pageDialog', PageDialogController)
	//filters
	//constants
	.constant('dialogPartials', 'dialog/components/')
	;
export {
	dialogmodule
}