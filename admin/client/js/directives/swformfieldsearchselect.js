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
				
				var propertyMetaData = scope.propertyDisplay.object.metaData[scope.propertyDisplay.property];
				var propertyCFC = propertyMetaData.cfc;
				scope.selectionOptions.getOptionsByKeyword=function(keyword){
					var filterGroupsConfig = '['+  
					  ' {  '+
					      '"filterGroup":[  '+
					         '{'+
					        	' "propertyIdentifier":"_'+propertyCFC.toLowerCase()+'.'+scope.propertyDisplay.property+'Name",'+
					        	' "comparisonOperator":"like",'+
					        	 ' "ormtype":"string",'+
					        	' "value":"%'+keyword+'%"'+
					       '  }'+
					     ' ]'+
					  ' }'+
					']';
					return $slatwall.getEntity(propertyCFC, {filterGroupsConfig:filterGroupsConfig.trim()})
					.then(function(value){
						$log.debug('typesByKeyword');
						$log.debug(value);
						scope.selectionOptions.value = value.pageRecords;
						var myLength = keyword.length;
						
						if (myLength > 0) {
							//scope.showAddProductBundleGroupTypeBtn = true;
							//$('.s-add-bundle-type').show();
						}else{
							//scope.showAddProductBundleGroupTypeBtn = false;
							//$('.s-add-bundle-type').hide();
						}
						
//						for(var i in scope.selectionOptions.value){
//							if(scope.selectionOptions.value[i].typeCode === scope.productBundleGroup.data.productBundleGroupType.data.typeCode){
//								scope.showAddProductBundleGroupTypeBtn = false;
//							}
//						}
						return scope.selectionOptions.value;
					});
				};
				var propertyPromise = scope.propertyDisplay.object['$$get'+propertyCFC]();
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
				    var propertyCFC = scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].cfc;
				    var inflatedObject = $slatwall.newEntity(propertyCFC);
				    angular.extend(inflatedObject.data,$item);
				    scope.propertyDisplay.object['$$set'+propertyCFC](inflatedObject);
				};
				
	        }
		};
	}
]);
	
