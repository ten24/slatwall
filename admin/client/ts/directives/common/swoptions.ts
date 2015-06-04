angular.module('slatwalladmin')
.directive('swOptions', [
'$log',
'$slatwall',
'partialsPath',
	function(
	$log,
    $slatwall,
	partialsPath
	){
		return {
			restrict: 'AE',
			scope:{
				objectName:'@'
			},
			templateUrl:partialsPath+"options.html",
			link: function(scope, element,attrs,formController){
                scope.getOptions = function(){
                    scope.object = $slatwall.newEntity(scope.objectName);
                    var columnsConfig = [
                        {
                            "propertyIdentifier":scope.objectName.charAt(0).toLowerCase()+scope.objectName.slice(1)+'Name'    
                        },
                        {
                            "propertyIdentifier":scope.object.$$getIDName()   
                        }
                    ]
                   $slatwall.getEntity(scope.objectName,{allRecords:true, columnsConfig:angular.toJson(columnsConfig)})
                   .then(function(value){
                        scope.options = value.records;
                        console.log('optionsPromise');
                        console.log(scope.object);
                        console.log(scope.options);
                    });
                }
                
                scope.getOptions();
			}
		};
	}
]);
	
