'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroupType', 
[
	'$http',
	'$log',
	'$slatwall',
	'formService',
	'productBundlePartialsPath',
	'productBundleService',
function(
	$http,
	$log,
	$slatwall,
	formService,
	productBundlePartialsPath,
	productBundleService
){
	return {
		restrict: 'A',
		templateUrl:productBundlePartialsPath+"productbundlegrouptype.html",
		scope:{
			productBundleGroup:"="
		},
		controller: function($scope, $element,$attrs){
			$log.debug('productBundleGrouptype');
			$log.debug($scope.productBundleGroup);
			$scope.productBundleGroupTypes = {};
			$scope.$$id="productBundleGroupType";
			$scope.productBundleGroupTypes.value = [];
			$scope.productBundleGroupTypes.$$adding = false;
			$scope.productBundleGroupTypes.setAdding = function(isAdding){
				$scope.productBundleGroupTypes.$$adding = isAdding;
				$scope.getPropertyDisplayData = function(){
					var propertyDisplayDataPromise = $slatwall.getPropertyDisplayData('Type',
							{propertyIdentifiersList:'typeCode,typeName,typeDescription,parentType.TypeID'}
					);
					propertyDisplayDataPromise.then(function(value){
						$scope.propertyDisplayData = value.data;
						$log.debug('getting property Display meta data');
						$log.debug($scope.propertyDisplayData);
						$scope.productBundleGroupType = {
							"parentType.typeID":'154dcdd2f3fd4b5ab5498e93470957b8',
							"typeCode":$scope.productBundleGroup.productBundleGroupType.type,
							"typeDescription":"",
							"typeName":""
						};
						formService.setForm($scope.form.addProductBundleGroupType);
						$log.debug('productBundleGroupType');
						$log.debug($scope.productBundleGroupType);
					});
				}();
				
				
				
				/*var options = {
					context:'AddProductBundleGroupType',
					propertyIdentifiersList:'type.typeCode,systemCode,typeDescription,parentType.TypeID'
				};
				var processObjectPromise = $slatwall.getProcessObject(
					'Type',
					options
				);
				
				processObjectPromise.then(function(value){
					$log.debug('getProcessObject');
					$scope.processObject = value.data;
					$log.debug($scope.processObject);
					
				});*/
				
			};
			
			$scope.saveProductBundleGroupType = function(){
				var addProductBundleGroupTypeForm = formService.getForm('form.addProductBundleGroupType');
				//only save the form if it passes validation
				addProductBundleGroupTypeForm.$submitted = true;
				if(addProductBundleGroupTypeForm.$valid === true){
					
					var params = {
						'typeID':"",
						"typeName":addProductBundleGroupTypeForm["typeName"].$modelValue,
						"parentType.typeID":$scope.productBundleGroupType["parentType.typeID"],
						"typeDescription":addProductBundleGroupTypeForm['typeDescription'].$modelValue,
						"typeCode":addProductBundleGroupTypeForm['typeCode'].$modelValue,
						"propertyIdentifiersList":"typeID,typeName,typeCode,typeDescription"
					};
					$log.debug(params);
					var saveProductBundleTypePromise = $slatwall.saveEntity('Type', null, params,'Save');
					saveProductBundleTypePromise.then(function(value){
						$log.debug('saving Product Bundle Group Type');
						$scope.productBundleGroupTypes.$$adding = false;
						$scope.showAddProductBundleGroupTypeBtn = false;
						$scope.productBundleGroup.productBundleGroupType = value.data;
						formService.resetForm(addProductBundleGroupTypeForm);
					});
				}
			};
			
			$scope.showAddProductBundleGroupTypeBtn = false;
			
			$scope.productBundleGroupTypes.getTypesByKeyword=function(keyword){
				$log.debug('getTypesByKeyword');
				var filterGroupsConfig = '['+  
				  ' {  '+
				      '"filterGroup":[  '+
				        ' {  '+
				           ' "propertyIdentifier":"Type.parentType.systemCode",'+
				           ' "comparisonOperator":"=",'+
				           ' "value":"productBundleGroupType",'+
				           ' "ormtype":"string",'+
				           ' "conditionDisplay":"Equals"'+
				         '},'+
				         '{'+
				         	'"logicalOperator":"AND",'+
				        	' "propertyIdentifier":"Type.typeCode",'+
				        	' "comparisonOperator":"like",'+
				        	 ' "ormtype":"string",'+
				        	' "value":"%'+keyword+'%"'+
				       '  }'+
				     ' ]'+
				  ' }'+
				']';
				return $slatwall.getEntity('type', {filterGroupsConfig:filterGroupsConfig.trim()})
				.then(function(value){
					$log.debug('typesByKeyword');
					$log.debug(value);
					$scope.productBundleGroupTypes.value = value.pageRecords;
					var myLength = keyword.length;
					
					if (myLength > 0) {
						$scope.showAddProductBundleGroupTypeBtn = true;
						//$('.s-add-bundle-type').show();
					}else{
						$scope.showAddProductBundleGroupTypeBtn = false;
						//$('.s-add-bundle-type').hide();
					}
					
					for(var i in $scope.productBundleGroupTypes.value){
						if($scope.productBundleGroupTypes.value[i].typeCode === $scope.productBundleGroup.productBundleGroupType.typeCode){
							$scope.showAddProductBundleGroupTypeBtn = false;
						}
					}
					return $scope.productBundleGroupTypes.value;
				});
			};
			
			$scope.selectProductBundleGroupType = function ($item, $model, $label) {
			    $scope.$item = $item;
			    $scope.$model = $model;
			    $scope.$label = $label;
			    $scope.productBundleGroup.productBundleGroupType = $item;
			    $scope.showAddProductBundleGroupTypeBtn = false;
			};
		}
	};
}]);
	
