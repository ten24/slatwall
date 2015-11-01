/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {//this is hibachi.directive / frontEnd

    export class swPropertyDisplay implements ng.IDirective {
		public static $inject = ['$log', 'partialsPath', '$filter'];
        
		constructor(public $log, public partialsPath, public $filter){
			this.$log = $log;
			this.partialsPath = partialsPath;
			this.$filter = $filter;
            return this.GetInstance();
        }

        public GetInstance(): any {
            return {
			require:'^form',
			restrict: 'AE',
			scope:{
				object:"=",
				property:"@",
				editable:"=",
				editing:"=",
				isHidden:"=",
				title:"=",
				hint:"@",
				optionsArguments:"=",
				eagerLoadOptions:"=",
				isDirty:"=",
				onChange:"=",
				fieldType:"@",
				noValidate:"="
					
			},
			templateUrl: this.partialsPath+"propertydisplay.html",
			link : (scope, elem: JQuery, attrs: ng.IAttributes, formController) =>{
				
				//if the item is new, then all fields at the object level are dirty
				this.$log.debug('editingproper');
				this.$log.debug(scope.property);
				this.$log.debug(scope.title);

                if(!angular.isDefined(scope.object)){
                    scope.object = formController.$$swFormInfo.object;
                }

				/**
				 * Configuration for property display object.
				 */
				scope.propertyDisplay = {
					object:scope.object,
					property:scope.property,
					errors:{},
					editing:scope.editing,
					editable:scope.editable,
					isHidden:scope.isHidden,
					fieldType:scope.fieldType || scope.object.metaData.$$getPropertyFieldType(scope.property),
					title: scope.title,
					hint:scope.hint || scope.object.metaData.$$getPropertyHint(scope.property),
					optionsArguments:scope.optionsArguments || {},
					eagerLoadOptions:scope.eagerLoadOptions || true,
					isDirty:scope.isDirty,
					onChange:scope.onChange,
					noValidate:scope.noValidate
				};
				if(angular.isUndefined(scope.propertyDisplay.noValidate)){
					scope.propertyDisplay.noValidate = false;
				}
				if(angular.isUndefined(scope.propertyDisplay.editable)){
					scope.propertyDisplay.editable = true;
				}
				if(angular.isUndefined(scope.editing)){
					scope.propertyDisplay.editing = false;
				}
				
				if(angular.isUndefined(scope.propertyDisplay.isHidden)){
					scope.propertyDisplay.isHidden = false;
				}

				scope.applyFilter = function(model, filter) {
					try{
                       return this.$filter(filter)(model)
                    }catch (e){
                        return model;
                    }
				};
				scope.$id = 'propertyDisplay:'+scope.property;
				/* register form that the propertyDisplay belongs to*/
				scope.propertyDisplay.form = formController;
				this.$log.debug(scope.propertyDisplay);
				this.$log.debug('propertyDisplay');
				this.$log.debug(scope.propertyDisplay);
			}
		};
        }
    }
	angular.module('slatwalladmin').directive('swPropertyDisplay',['$log', 'partialsPath', '$filter',($log, partialsPath, $filter) => new swPropertyDisplay($log, partialsPath, $filter)]);
}
	
