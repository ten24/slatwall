angular.module('slatwalladmin')
.directive('swDisplayOptions',[
	'$http',
	'$compile',
	'$templateCache',
	'$log',
	'$slatwall',
	'collectionService',
	'collectionPartialsPath',
	function(
		$http,
		$compile,
		$templateCache,
		$log,
		$slatwall,
		collectionService,
		collectionPartialsPath
	){
		return {
			restrict: 'E',
			transclude:true,
			scope:{
				orderBy:"=",
				columns:'=',
				propertiesList:"=",
				saveCollection:"&",
				baseEntityAlias:"=",
				baseEntityName:"@"
			},
			templateUrl:collectionPartialsPath+"displayoptions.html",
			controller: function($scope,$element,$attrs){
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
				
				
				//var baseEntityCfcName = $scope.baseEntityName.replace('Slatwall','').charAt(0).toLowerCase()+$scope.baseEntityName.replace('Slatwall','').slice(1); 
				var getTitleFromPropertyIdentifier = function(propertyIdentifier){
					var title = '';
					var propertyIdentifierArray = propertyIdentifier.split('.');
					
					angular.forEach(propertyIdentifierArray,function(propertyIdentifierItem,key){
						//pass over the initial item
						if(key !== 0 && key !== propertyIdentifierArray.length-1){
							var prefix = 'entity.';
							if(key === 1){
								title += $slatwall.getRBKey(prefix+baseEntityCfcName+'.'+propertyIdentifierItem);
							}else{
								title += $slatwall.getRBKey(prefix+propertyIdentifierArray[key-1]+'.'+propertyIdentifierItem);
							}
							if(key < propertyIdentifierArray.length-2){
								title += ' | ';
							}
						}
					});
					
					
					return title;
				}
				
				$scope.addColumn = function(selectedProperty, closeDialog){
					$log.debug('add Column');
					$log.debug(selectedProperty);
					if(selectedProperty.$$group === 'simple' || 'attribute'){
						$log.debug($scope.columns);
						if(angular.isDefined(selectedProperty)){
							var column = {};
							console.log('selectedProperty');
							console.log(selectedProperty);
							//"_orderitem.order.orderType.typeName"
							//console.log(getTitleFromPropertyIdentifier(selectedProperty.propertyIdentifier));
							column.title = selectedProperty.displayPropertyIdentifier;
							column.propertyIdentifier = selectedProperty.propertyIdentifier;
							column.isVisible = true;
							column.isDeletable = true;
							//only add attributeid if the selectedProperty is attributeid
							if(angular.isDefined(selectedProperty.attributeID)){
								column.attributeID = selectedProperty.attributeID;
								column.attributeSetObject = selectedProperty.attributeSetObject;
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
					
				      var panelList = angular.element($element).children('ul');
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
			}
		};
	}
]);


	
	
