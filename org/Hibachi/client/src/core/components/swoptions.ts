/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOptions{
    
    public template = require("./options.html");
    public restrict = 'AE';
	
	public scope = {
		objectName: '@'
	};

    // @ngInject;
    constructor(
        private $log, 
        private $hibachi, 
        private observerService
    ){}
    
	public static Factory(){
		return /** @ngInject; */ ( $log, $hibachi, observerService) => new this($log, $hibachi, observerService);
	}
	
    
    public link:ng.IDirectiveLinkFn = (scope, element,attrs) => {
       
        scope.swOptions = {};
        scope.swOptions.objectName = scope.objectName;
        //sets up drop down options via collections
        scope.getOptions = () => {
            scope.swOptions.object = this.$hibachi['new'+scope.swOptions.objectName]();
            
            var columnsConfig = [
                {
                    "propertyIdentifier":scope.swOptions.objectName.charAt(0).toLowerCase()+scope.swOptions.objectName.slice(1)+'Name'
                },
                {
                    "propertyIdentifier":scope.swOptions.object.$$getIDName()
                }
            ]
            
           this.$hibachi.getEntity(scope.swOptions.objectName,{
               allRecords: true,
               columnsConfig: angular.toJson(columnsConfig)
           })
           .then( (value) => {
                scope.swOptions.options = value.records;
                this.observerService.notify('optionsLoaded');
            });
        }
    
        scope.getOptions();
    
        var selectOption = (option) => {
            if(option){
                scope.swOptions.selectOption(option);
            }else{
                scope.swOptions.selectOption(scope.swOptions.options[0]);
            }
        };
    
        this.observerService.attach(selectOption,'selectOption','selectOption');
    
        //use by ng-change to record changes
        scope.swOptions.selectOption = (selectedOption) => {
            scope.swOptions.selectedOption = selectedOption;
            this.observerService.notify('optionsChanged',selectedOption);
        }
    }
}
export{
    SWOptions
}

