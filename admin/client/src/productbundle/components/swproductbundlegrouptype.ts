/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWProductBundleGroupType{
	public static Factory(){
        var directive = (
            $http,
			$log,
			$hibachi,
			formService,
            collectionConfigService,
			productBundlePartialsPath,
			productBundleService,
			slatwallPathBuilder
        )=> new SWProductBundleGroupType(
            $http,
			$log,
			$hibachi,
			formService,
            collectionConfigService,
			productBundlePartialsPath,
			productBundleService,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$http',
			'$log',
			'$hibachi',
			'formService',
            'collectionConfigService',
			'productBundlePartialsPath',
			'productBundleService',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        $http,
		$log,
		$hibachi,
		formService,
        collectionConfigService,
		productBundlePartialsPath,
		productBundleService,
			slatwallPathBuilder
    ){
        return {
			restrict: 'A',
			templateUrl:slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath)+"productbundlegrouptype.html",
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
                $scope.productBundleGroupTypeSaving = false;
				$scope.productBundleGroupType = {};

				if(angular.isUndefined($scope.productBundleGroup.data.productBundleGroupType)){
					var productBundleGroupType = $hibachi.newType();
					var parentType = $hibachi.newType();
					parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
					productBundleGroupType.$$setParentType(parentType);
					$scope.productBundleGroup.$$setProductBundleGroupType(productBundleGroupType);
				}

				/**
				 * Sets the state to adding and sets the initial data.
				 */
				$scope.productBundleGroupTypes.setAdding = function(){
                    $scope.productBundleGroupTypes.$$adding = !$scope.productBundleGroupTypes.$$adding;
                    if(!$scope.productBundleGroupTypes.$$adding){
                        var productBundleGroupType = $hibachi.newType();
                        var parentType = $hibachi.newType();
                        parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
                        productBundleGroupType.$$setParentType(parentType);
                        $scope.productBundleGroup.data.productBundleGroupType.data.typeName = "";
                        productBundleGroupType.data.typeName=$scope.productBundleGroup.data.productBundleGroupType.data.typeName;
                        productBundleGroupType.data.typeDescription = '';
                        productBundleGroupType.data.typeNameCode='';
                        angular.extend($scope.productBundleGroup.data.productBundleGroupType,productBundleGroupType);
                        //formService.getForm('form.addProductBundleGroupType').$setDirty();
                    }
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
					return $hibachi.getEntity('type', {filterGroupsConfig:filterGroupsConfig.trim()})
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
				$scope.selectProductBundleGroupType = function (item) {
					angular.extend($scope.productBundleGroup.data.productBundleGroupType.data,item);
					var parentType = $hibachi.newType();
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
                    $scope.productBundleGroupTypeSaving = true;
                    //Gets the promise from save                    
                    var promise = $scope.productBundleGroup.data.productBundleGroupType.$$save();
                    promise.then(function(response){
                        //Calls close function
                        
                        if (promise.$$state.status){
                            $scope.productBundleGroupTypeSaving = false;
                            $scope.closeAddScreen();
                        }
                    },()=>{
                         
                        $scope.productBundleGroupTypeSaving = false;
                    });

				};

				//Sets up clickOutside Directive call back arguments
				$scope.clickOutsideArgs = {
					callBackActions : [$scope.closeAddScreen]
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
}
export{
	SWProductBundleGroupType
}
