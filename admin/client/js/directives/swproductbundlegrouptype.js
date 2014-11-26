'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroupType', [
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
				$scope.productBundleGroupType = {};
				$scope.productBundleGroupTypes.setAdding = function(isAdding){
					$scope.productBundleGroupTypes.$$adding = isAdding;

					var productBundleGroupType = $slatwall.newType();
					//productBundleGroup.productBundleGroupType.$$add
					productBundleGroupType.data.parentType = {};
					productBundleGroupType.data.parentType.data = {};
					productBundleGroupType.data.parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.data.typeName=$scope.productBundleGroup.data.productBundleGroupType.data.typeName;
					productBundleGroupType.data.typeDescription = '';
					productBundleGroupType.data.typeNameCode='';
					$scope.productBundleGroup.data.productBundleGroupType = productBundleGroupType;
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
							//$scope.productBundleGroup.productBundleGroupType = value.data;
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
					           ' "propertyIdentifier":"_type.parentType.systemCode",'+
					           ' "comparisonOperator":"=",'+
					           ' "value":"productBundleGroupType",'+
					           ' "ormtype":"string",'+
					           ' "conditionDisplay":"Equals"'+
					         '},'+
					         '{'+
					         	'"logicalOperator":"AND",'+
					        	' "propertyIdentifier":"_type.typeName",'+
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
	}
]);
	
