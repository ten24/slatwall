angular.module('slatwalladmin')
.directive('swOptions', [
'$log',
'$slatwall',
'observerService',
'partialsPath',
	function(
	$log,
    $slatwall,
    observerService,
	partialsPath
	){
		return {
			restrict: 'AE',
			scope:{
				objectName:'@'
			},
			templateUrl:partialsPath+"options.html",
			link: function(scope, element,attrs){
                scope.swOptions = {};
                scope.swOptions.objectName=scope.objectName;
                //sets up drop down options via collections
                scope.getOptions = function(){
                    scope.swOptions.object = $slatwall['new'+scope.swOptions.objectName]();
                    var columnsConfig = [
                        {
                            "propertyIdentifier":scope.swOptions.objectName.charAt(0).toLowerCase()+scope.swOptions.objectName.slice(1)+'Name'    
                        },
                        {
                            "propertyIdentifier":scope.swOptions.object.$$getIDName()   
                        }
                    ]
                   $slatwall.getEntity(scope.swOptions.objectName,{allRecords:true, columnsConfig:angular.toJson(columnsConfig)})
                   .then(function(value){
                        scope.swOptions.options = value.records;
                    });
                }
                
                scope.getOptions();
                
                //use by ng-change to record changes
                scope.swOptions.selectOption = function(selectedOption){
                    scope.swOptions.selectedOption = selectedOption;
                    observerService.notify('optionsChanged',selectedOption);
                }
			}
		};
	}
]);
	
