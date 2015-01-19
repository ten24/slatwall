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
				
				var propertyCFC = scope.propertyDisplay.object.metaData[scope.propertyDisplay.property].cfc;
				var propertyName = 
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
				
				scope.selectItem = function ($item, $model, $label) {
				    scope.$item = $item;
				    scope.$model = $model;
				    scope.$label = $label;
				 
//					angular.extend(scope.productBundleGroup.data.productBundleGroupType.data,$item);
//					var parentType = $slatwall.newType();
//					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
//					scope.productBundleGroup.data.productBundleGroupType.$$setParentType(parentType);
//				    
//				    scope.showAddProductBundleGroupTypeBtn = false;
				};
	        }
		};
	}
]);
	
