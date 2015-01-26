angular.module('slatwalladmin')
.directive('swFormFieldSearchSelect', [
'$log',
'$slatwall',
'formService',
'partialsPath',
	function(
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
				scope.selectionOptions = {};
				scope.selectionOptions.value = [];
				scope.selectionOptions.$$adding = false;
				scope.selectedOption = {};
				scope.showAddBtn = false;
				
				var propertyMetaData = scope.propertyDisplay.object.$$getMetaData(scope.propertyDisplay.property);
				console.log('metaData');
				console.log(propertyMetaData);
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
//						
//						for(var i in scope.productBundleGroupTypes.value){
//							if(scope.productBundleGroupTypes.value[i].typeCode === scope.productBundleGroup.data.productBundleGroupType.data.typeCode){
//								scope.showAddProductBundleGroupTypeBtn = false;
//							}
//						}
//						angular.forEach(scope.selectionOptions.value,function(selectionOption,key){
//							
//						});
							
						
						
						return scope.selectionOptions.value;
					});
				};
				console.log(propertyMetaData.nameCapitalCase);
				var propertyPromise = scope.propertyDisplay.object['$$get'+propertyMetaData.nameCapitalCase]();
				propertyPromise.then(function(data){
					
				});
				console.log(scope.propertyDisplay.object);
				scope.selectItem = function ($item, $model, $label) {
				    scope.$item = $item;
				    scope.$model = $model;
				    scope.$label = $label;
				    console.log('item');
				    console.log($item);
				    console.log(scope.propertyDisplay.object.data[scope.propertyDisplay.property]);
				    console.log(scope.propertyDisplay.object);
				    var inflatedObject = $slatwall.newEntity(propertyMetaData.cfc);
				    angular.extend(inflatedObject.data,$item);
				    scope.propertyDisplay.object['$$set'+propertyMetaData.nameCapitalCase](inflatedObject);
				};
				
	        }
		};
	}
]);
	
