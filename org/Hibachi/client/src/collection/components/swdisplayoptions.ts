/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDisplayOptions{
	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			$http,
			$compile,
			$templateCache,
			$log,
			$hibachi,
			collectionService,
			hibachiPathBuilder,
			collectionPartialsPath,
            rbkeyService

		) => new SWDisplayOptions(
			$http,
			$compile,
			$templateCache,
			$log,
			$hibachi,
			collectionService,
			hibachiPathBuilder,
			collectionPartialsPath,
            rbkeyService
		);
		directive.$inject = [
			'$http',
			'$compile',
			'$templateCache',
			'$log',
			'$hibachi',
			'collectionService',
			'hibachiPathBuilder',
			'collectionPartialsPath',
            'rbkeyService'
		];
		return directive;
	}

	//@ngInject
	constructor(
		$http,
		$compile,
		$templateCache,
		$log,
		$hibachi,
		collectionService,
		hibachiPathBuilder,
		collectionPartialsPath,
        rbkeyService
	){

		return{
			restrict: 'E',
			transclude:true,
			scope:{
				orderBy:"=",
				columns:'=',
				propertiesList:"=",
				saveCollection:"&",
				baseEntityAlias:"=",
				baseEntityName:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"displayoptions.html",
			controller: ['$scope','$element','$attrs',function($scope,$element,$attrs){
				$log.debug('display options initialize');

				this.removeColumn = function(columnIndex){
					$log.debug('parent remove column');
					$log.debug($scope.columns);
					if($scope.columns.length){
						$scope.columns.splice(columnIndex, 1);
					}

				};

				this.getPropertiesList = function(){
					return $scope.propertiesList;
				};

				$scope.addDisplayDialog = {
					isOpen:false,
					toggleDisplayDialog:function(){
						$scope.addDisplayDialog.isOpen = !$scope.addDisplayDialog.isOpen;
					}
				};


				var getTitleFromProperty = function(selectedProperty){
					var baseEntityCfcName = $scope.baseEntityName.replace('Slatwall','').charAt(0).toLowerCase()+$scope.baseEntityName.replace('Slatwall','').slice(1);
                    var propertyIdentifier = selectedProperty.propertyIdentifier;
					var title = '';
					var propertyIdentifierArray = propertyIdentifier.split('.');
					var currentEntity;
					var currentEntityInstance;
					var prefix = 'entity.';
                    
                    if(selectedProperty.$$group == "attribute"){
                        return selectedProperty.displayPropertyIdentifier;
                    }

					angular.forEach(propertyIdentifierArray,function(propertyIdentifierItem,key){
						//pass over the initial item
						if(key !== 0 ){
							if(key === 1){
								currentEntityInstance = $hibachi['new'+$scope.baseEntityName.replace('Slatwall','')]();
								currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
								title += rbkeyService.getRBKey(prefix+baseEntityCfcName+'.'+propertyIdentifierItem);
							}else{
								var currentEntityInstance = $hibachi['new'+currentEntity.cfc.charAt(0).toUpperCase()+currentEntity.cfc.slice(1)]();
								currentEntity = currentEntityInstance.metaData[propertyIdentifierArray[key]];
								title += rbkeyService.getRBKey(prefix+currentEntityInstance.metaData.className+'.'+currentEntity.name);
							}
							if(key < propertyIdentifierArray.length-1){
								title += ' | ';
							}
						}
					});


					return title;
				};

				$scope.addColumn = function(selectedProperty, closeDialog){
					$log.debug('add Column');
					$log.debug(selectedProperty);
					if(selectedProperty.$$group === 'simple' || 'attribute'){
						$log.debug($scope.columns);
						if(angular.isDefined(selectedProperty)){
							var column = {
								title : getTitleFromProperty(selectedProperty),
								propertyIdentifier : selectedProperty.propertyIdentifier,
								isVisible : true,
								isDeletable : true,
								isSearchable : true,
								isExportable : true
							};
							//only add attributeid if the selectedProperty is attributeid
							if(angular.isDefined(selectedProperty.attributeID)){
								column['attributeID'] = selectedProperty.attributeID;
								column['attributeSetObject'] = selectedProperty.attributeSetObject;
							}
							if(angular.isDefined(selectedProperty.ormtype)){
								column['ormtype'] = selectedProperty.ormtype;
							}
							$scope.columns.push(column);
							$scope.saveCollection();
							if(angular.isDefined(closeDialog) && closeDialog === true){
								$scope.addDisplayDialog.toggleDisplayDialog();
							}
						}
					}
				};

				$scope.selectBreadCrumb = function(breadCrumbIndex){
					//splice out array items above index
					var removeCount = $scope.breadCrumbs.length - 1 - breadCrumbIndex;
					$scope.breadCrumbs.splice(breadCrumbIndex + 1,removeCount);
					$scope.selectedPropertyChanged(null);

				};

				var unbindBaseEntityAlias = $scope.$watch('baseEntityAlias',function(newValue,oldValue){
					if(newValue !== oldValue){
						$scope.breadCrumbs = [ {
							entityAlias : $scope.baseEntityAlias,
							cfc : $scope.baseEntityAlias,
							propertyIdentifier : $scope.baseEntityAlias
						} ];
						unbindBaseEntityAlias();
					}
				});

				$scope.selectedPropertyChanged = function(selectedProperty){
					// drill down or select field?
					$log.debug('selectedPropertyChanged');
					$log.debug(selectedProperty);
					$scope.selectedProperty = selectedProperty;
				};


				jQuery(function($) {

				      var panelList:any = angular.element($element).children('ul');
				      panelList.sortable({
				          // Only make the .panel-heading child elements support dragging.
				          // Omit this to make then entire <li>...</li> draggable.
				          handle: '.s-pannel-name',
				          update: function(event,ui) {
				        	  var tempColumnsArray = [];
				              $('.s-pannel-name', panelList).each(function(index, elem) {
				            	  var newIndex = $(elem).attr('j-column-index');
				            	  var columnItem = $scope.columns[newIndex];
				            	  tempColumnsArray.push(columnItem);
				              });
				              $scope.$apply(function () {
				            	  $scope.columns = tempColumnsArray;
				              });
				              $scope.saveCollection();
				          }
				      });
				  });

				/*var unbindBaseEntityAlaisWatchListener = scope.$watch('baseEntityAlias',function(){
		       		 $("select").selectBoxIt();
		       		 unbindBaseEntityAlaisWatchListener();
		       	});*/
			}]
		}
	}
}
export{
	SWDisplayOptions
}




