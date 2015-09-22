/**
 * Handles user selections of Product Group Types.
 */
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
			controller: ['$scope','$element','$attrs',function($scope, $element, $attrs ){
				$log.debug('productBundleGrouptype');
				$log.debug($scope.productBundleGroup);
				$scope.productBundleGroupTypes = {};
				$scope.$$id="productBundleGroupType";
				$scope.productBundleGroupTypes.value = [];
				$scope.productBundleGroupTypes.$$adding = false;
				$scope.productBundleGroupType = {};
				if(angular.isUndefined($scope.productBundleGroup.data.productBundleGroupType)){
					var productBundleGroupType = $slatwall.newType();
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					$scope.productBundleGroup.$$setProductBundleGroupType(productBundleGroupType);
				}

				/**
				 * Sets the state to adding and sets the initial data.
				 */
				$scope.productBundleGroupTypes.setAdding = function(isAdding){
					$scope.productBundleGroupTypes.$$adding = isAdding;
					var productBundleGroupType = $slatwall.newType();
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					productBundleGroupType.data.typeName=$scope.productBundleGroup.data.productBundleGroupType.data.typeName;
					productBundleGroupType.data.typeDescription = '';
					productBundleGroupType.data.typeNameCode='';
					angular.extend($scope.productBundleGroup.data.productBundleGroupType,productBundleGroupType);
				};
				
				$scope.showAddProductBundleGroupTypeBtn = false;
				/**
				 * Handles looking up the keyword and populating the dropdown as a user types.
				 */
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
						}else{
							$scope.showAddProductBundleGroupTypeBtn = false;
						}

						return $scope.productBundleGroupTypes.value;
					});
				};
				
				/**
				 * Handles user selection of the dropdown.
				 */
				$scope.selectProductBundleGroupType = function ($item, $model, $label) {
					console.log("Selecting");
				    $scope.$item = $item;
				    $scope.$model = $model;
				    $scope.$label = $label;
				    
					angular.extend($scope.productBundleGroup.data.productBundleGroupType.data,$item);
					var parentType = $slatwall.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					$scope.productBundleGroup.data.productBundleGroupType.$$setParentType(parentType);
				    $scope.showAddProductBundleGroupTypeBtn = false;
				    	};
				
				/**
				 * Closes the add screen
				 */
				$scope.closeAddScreen = function(){
					$scope.productBundleGroupTypes.$$adding = false;
					$scope.showAddProductBundleGroupTypeBtn = false;
				};
				
				/**
				 * Clears the type name
				 */
				$scope.clearTypeName = function(){
					if (angular.isDefined($scope.productBundleGroup.data.productBundleGroupType)){
					$scope.productBundleGroup.data.productBundleGroupType.data.typeName = '';
					}
				};
				
				/**
				 * Saves product bundle group type
				 */
				$scope.saveProductBundleGroupType = function(){
						//Gets the promise from save
						var promise = $scope.productBundleGroup.data.productBundleGroupType.$$save();
						promise.then(function(response){
							//Calls close function
							if (promise.valid){
							$scope.closeAddScreen();
							}
						});
					
				};
				
				//Sets up clickOutside Directive call back arguments
				$scope.clickOutsideArgs = {
					callBackActions : [$scope.closeAddScreen,$scope.clearTypeName]
				};
				/**
				 * Works with swclickoutside directive to close dialog
				 */
				$scope.closeThis = function (clickOutsideArgs) {
					//Check against the object state
					if(!$scope.productBundleGroup.data.productBundleGroupType.$$isPersisted()){
						//Perform all callback actions
				        for(var callBackAction in clickOutsideArgs.callBackActions){
				        	clickOutsideArgs.callBackActions[callBackAction]();
				        }
					}
				};
			}]
		};
	}
]);
	
