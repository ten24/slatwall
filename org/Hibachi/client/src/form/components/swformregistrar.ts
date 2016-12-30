/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWFormRegistrar implements ng.IDirective {
	public static Factory(){
		var directive = (
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		)=> new SWFormRegistrar(
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject =[
			'formService',
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	//@ngInject
	constructor(
		formService,
		coreFormPartialsPath,
		hibachiPathBuilder
	){
		return {
			restrict: 'E',
			require:["^form","^swForm"],
            scope: {
                object:"=?",
                context:"@?",
                name:"@?",
                isDirty:"=?"
            },
			link: function(scope, element, attrs, formController,transclude){
				/*add form info at the form level*/
                scope.$watch(()=>{return formController[0]},()=>{
                    formController[1].formCtrl = formController[0];
                })
				

				formController[0].$$swFormInfo={
					object:scope.object,
					context:scope.context || 'save',
					name:scope.name
				};

				var makeRandomID = function makeid(count)
				{
					var text = "";
					var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

					for( var i=0; i < count; i++ )
						text += possible.charAt(Math.floor(Math.random() * possible.length));

					return text;
				};
                if(scope.isDirty){
                    formController[0].autoDirty = true;
                }

				scope.form = formController[0];
				/*register form with service*/
				formController[0].name = scope.name;
                formController[0].$setDirty();

				formService.setForm(formController[0]);



				/*register form at object level*/
				if(!angular.isDefined(scope.object.forms)){
					scope.object.forms = {};
				}
				scope.object.forms[scope.name] = formController[0];

			}
		};
	}

}
export{
	SWFormRegistrar
}
// 	angular.module('slatwalladmin').directive('swFormRegistrar',[ 'formService', 'partialsPath', (formService, partialsPath) => new swFormRegistrar(formService, partialsPath)]);
// }
