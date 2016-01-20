/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOptions{
    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $log,
            $hibachi,
            observerService,
            corePartialsPath,
            pathBuilderConfig
        )=> new SWOptions(
            $log,
            $hibachi,
            observerService,
            corePartialsPath,
            pathBuilderConfig
        );
        directive.$inject = [
            '$log',
            '$hibachi',
            'observerService',
            'corePartialsPath',
            'pathBuilderConfig'
        ];
        return directive;
    }
    constructor(
        $log,
        $hibachi,
        observerService,
        corePartialsPath,
        pathBuilderConfig
    ){

        return {
			restrict: 'AE',
			scope:{
				objectName:'@'
			},
			templateUrl:pathBuilderConfig.buildPartialsPath(corePartialsPath)+"options.html",
			link: function(scope, element,attrs){
                scope.swOptions = {};
                scope.swOptions.objectName=scope.objectName;
                //sets up drop down options via collections
                scope.getOptions = function(){
                    scope.swOptions.object = $hibachi['new'+scope.swOptions.objectName]();
                    var columnsConfig = [
                        {
                            "propertyIdentifier":scope.swOptions.objectName.charAt(0).toLowerCase()+scope.swOptions.objectName.slice(1)+'Name'
                        },
                        {
                            "propertyIdentifier":scope.swOptions.object.$$getIDName()
                        }
                    ]
                   $hibachi.getEntity(scope.swOptions.objectName,{allRecords:true, columnsConfig:angular.toJson(columnsConfig)})
                   .then(function(value){
                        scope.swOptions.options = value.records;
                        observerService.notify('optionsLoaded');
                    });
                }

                scope.getOptions();

                var selectFirstOption = function(){
                    scope.swOptions.selectOption(scope.swOptions.options[0]);
                };

                observerService.attach(selectFirstOption,'selectFirstOption','selectFirstOption');

                //use by ng-change to record changes
                scope.swOptions.selectOption = function(selectedOption){
                    scope.swOptions.selectedOption = selectedOption;
                    observerService.notify('optionsChanged',selectedOption);
                }
			}
		};
    }
}
export{
    SWOptions
}

