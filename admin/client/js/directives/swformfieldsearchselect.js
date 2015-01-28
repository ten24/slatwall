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
				scope.selectionOptions = {};
				scope.selectionOptions.value = [];
				scope.selectionOptions.$$adding = false;
				scope.selectedOption = {};
				scope.showAddBtn = false;
				var propertyMetaData = scope.propertyDisplay.object.$$getMetaData(scope.propertyDisplay.property);
//				check for a template
//				rules are tiered: check if an override is specified at scope.template, check if the cfc name .html exists, use
//				var templatePath = partialsPath + 'formfields/searchselecttemplates/';
//				if(angular.isUndefined(scope.propertyDisplay.template)){
//					$http.get(templatePath+propertyMetaData.cfcProperCase+'.html',function(data){
//						scope.propertyDisplay.template = templatePath+propertyMetaData.cfcProperCase+'.html';
//					},function(data){
//						scope.propertyDisplay.template = templatePath+'index.html';
//					});
//				}
				
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
	
