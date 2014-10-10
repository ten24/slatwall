'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroupType', 
[
	'$http',
	'$log',
	'$slatwall',
	'alertService',
	'formService',
	'productBundlePartialsPath',
	'productBundleService',
function(
	$http,
	$log,
	$slatwall,
	alertService,
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
				var processObjectPromise = $slatwall.getProcessObject(
					'Type',
					null,
					'AddProductBundleGroupType',
					'type.type,systemCode,typeDescription,parentType.TypeID'
				);
				
				processObjectPromise.then(function(value){
					$log.debug('getProcessObject');
					$scope.processObject = value.data;
					$log.debug($scope.processObject);
					console.log($scope.form);
					formService.setForm($scope.form.addProductBundleGroupType);
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
				});
				
			};
			
			
			
			$scope.saveProductBundleGroupType = function(){
				var addProductBundleGroupTypeForm = formService.getForm('form.addProductBundleGroupType');
				//only save the form if it passes validation
				addProductBundleGroupTypeForm.$submitted = true;
				if(addProductBundleGroupTypeForm.$valid === true){
					var params = {
						"type":addProductBundleGroupTypeForm["type.type"].$modelValue,
						"parentType.typeID":addProductBundleGroupTypeForm["parentType.TypeID"].$modelValue,
						"typeDescription":addProductBundleGroupTypeForm['typeDescription'].$modelValue,
						"systemCode":addProductBundleGroupTypeForm['systemCode'].$modelValue,
						"propertyIdentifiers":"typeID,type"
					};
					$log.debug(params);
					var saveProductBundleTypePromise = $slatwall.saveEntity('Type', null, params,'Save');
					saveProductBundleTypePromise.then(function(value){
						$log.debug('saving Product Bundle Group Type');
						var messages = value.MESSAGES;
						var alerts = alertService.formatMessagesToAlerts(messages);
						alertService.addAlerts(alerts);
						$scope.productBundleGroupTypes.$$adding = false;
						$scope.showAddProductBundleGroupTypeBtn = false;
						$scope.productBundleGroup.productBundleGroupType = value.DATA
						formService.resetForm(addProductBundleGroupTypeForm);
						
					},function(reason){
						var messages = reason.MESSAGES;
						var alerts = alertService.formatMessagesToAlerts(messages);
						alertService.addAlerts(alerts);
					});
					//if valid and we have a close index then close
					
				}
				
				//var productBundleGroupType = productBundleService.newProductBundleGroupType($scope.productBundleGroup.productBundleGroupType);
				//console.log(productBundleGroupType);
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
				        	' "propertyIdentifier":"Type.type",'+
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
					return $scope.productBundleGroupTypes.value;
				},function(reason){
					//display error message if getter fails
					var messages = reason.MESSAGES;
					var alerts = alertService.formatMessagesToAlerts(messages);
					alertService.addAlerts(alerts);
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
	
