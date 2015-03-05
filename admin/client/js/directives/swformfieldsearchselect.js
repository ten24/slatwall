angular.module('slatwalladmin')
.directive('swFormFieldSearchSelect', [
'$http',
'$log',
'$slatwall',
'formService',
'partialsPath',
	function(
	$http,
	$log,
	$slatwall,
	formService,
	partialsPath
	){
		return{
			templateUrl:partialsPath+'formfields/search-select.html',
			require:"^form",
			restrict: 'E',
			scope:{
				propertyDisplay:"="
			},
			link:function(scope,element,attr,formController){
				
				//set up selectionOptions
				scope.selectionOptions = {
					value:[],
					$$adding:false
				};
				//match in matches track by
				//function to set state of adding new item 
				scope.setAdding = function(isAdding){
					scope.isAdding = isAdding;
					scope.showAddBtn = false;
				}
				
				scope.selectedOption = {};
				scope.showAddBtn = false;
				var propertyMetaData = scope.propertyDisplay.object.$$getMetaData(scope.propertyDisplay.property);
				//create basic 
				var object = $slatwall.newEntity(propertyMetaData.cfc);
				//set up query function for finding related object
				scope.cfcProperCase = propertyMetaData.cfcProperCase;
				scope.selectionOptions.getOptionsByKeyword=function(keyword){
					var filterGroupsConfig = '['+  
					  ' {  '+
					      '"filterGroup":[  '+
					         '{'+
					        	' "propertyIdentifier":"_'+scope.cfcProperCase.toLowerCase()+'.'+scope.cfcProperCase+'Name",'+
					        	' "comparisonOperator":"like",'+
					        	 ' "ormtype":"string",'+
					        	' "value":"%'+keyword+'%"'+
					       '  }'+
					     ' ]'+
					  ' }'+
					']';
					return $slatwall.getEntity(propertyMetaData.cfc, {filterGroupsConfig:filterGroupsConfig.trim()})
					.then(function(value){
						$log.debug('typesByKeyword');
						$log.debug(value);
						scope.selectionOptions.value = value.pageRecords;
						
						var myLength = keyword.length;
						
						if (myLength > 0) {
							scope.showAddBtn = true;
						}else{
							scope.showAddBtn = false;
						}
						return scope.selectionOptions.value;
					});
				};
				var propertyPromise = scope.propertyDisplay.object['$$get'+propertyMetaData.nameCapitalCase]();
				propertyPromise.then(function(data){
					
				});
				
				//set up behavior when selecting an item
				scope.selectItem = function ($item, $model, $label) {
					
				    scope.$item = $item;
				    scope.$model = $model;
				    scope.$label = $label;
				    
				    //angular.extend(inflatedObject.data,$item);
				    object.$$init($item);
				    $log.debug('select item');
				    $log.debug(object);
				    scope.propertyDisplay.object['$$set'+propertyMetaData.nameCapitalCase](object);
				};
				
	        }
		};
	}
]);
	
