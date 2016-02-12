/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWPropertyDisplay{
    public static Factory(){
        var directive = (
            $log,
            $filter,
            coreFormPartialsPath,
            hibachiPathBuilder
        )=>new SWPropertyDisplay(
            $log,
            $filter,
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            '$log',
            '$filter',
            'coreFormPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
        $filter,
        coreFormPartialsPath,
        hibachiPathBuilder
    ){
        return {
            require:'^form',
            restrict: 'AE',
            scope:{
                object:"=",
                options:"=?",
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
            templateUrl:hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+"propertydisplay.html",
            link: function(scope, element,attrs,formController){
                //if the item is new, then all fields at the object level are dirty
                $log.debug('editingproper');
                $log.debug(scope.property);
                $log.debug(scope.title);

                if(!angular.isDefined(scope.object)){
                    scope.object = formController.$$swFormInfo.object;
                }

                /**
                 * Configuration for property display object.
                 */
                scope.propertyDisplay = {
                    object:scope.object,
                    options:scope.options,
                    property:scope.property,
                    errors:{},
                    editing:scope.editing || false,
                    editable:scope.editable || true,
                    isHidden:scope.isHidden || false,
                    fieldType:scope.fieldType || scope.object.metaData.$$getPropertyFieldType(scope.property),
                    title: scope.title,
                    hint:scope.hint || scope.object.metaData.$$getPropertyHint(scope.property),
                    optionsArguments:scope.optionsArguments || {},
                    eagerLoadOptions:scope.eagerLoadOptions || true,
                    isDirty:scope.isDirty,
                    onChange:scope.onChange,
                    noValidate:scope.noValidate || false,
                    form: formController
                };

                scope.applyFilter = function(model, filter) {
                    try{
                        return $filter(filter)(model)
                    }catch (e){
                        return model;
                    }
                };

                scope.$id = 'propertyDisplay:'+scope.property;
                $log.debug(scope.propertyDisplay);


                $log.debug('propertyDisplay');
                $log.debug(scope.propertyDisplay);
            }
        };
    }
}
export{
    SWPropertyDisplay
}