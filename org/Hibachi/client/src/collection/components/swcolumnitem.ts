/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWColumnItem{
	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$log,
			hibachiPathBuilder,
			collectionPartialsPath,
            observerService
		) => new SWColumnItem(
			$log,
			hibachiPathBuilder,
			collectionPartialsPath,
            observerService
		);
		directive.$inject = [
			'$log',
			'hibachiPathBuilder',
			'collectionPartialsPath',
            'observerService'
		];
		return directive;
	}
	//@ngInject
	constructor(
		$log,
		hibachiPathBuilder,
		collectionPartialsPath,
        observerService
	){

		return {
			restrict: 'A',
			require:{
                swDisplayOptions:"?^swDisplayOptions",
				swListingControls:"?^swListingControls"
            },
			scope:{
				column:"=",
				columns:"=",
				columnIndex:"=",
				saveCollection:"&?",
				propertiesList:"<",
				orderBy:"="
			},
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"columnitem.html",
			link: function(scope, element,attrs,controller,observerService){
                if(!scope.saveCollection && controller.swListingControls){

                    scope.saveCollection = ()=>{
						controller.swListingControls.collectionConfig.columns=scope.columns;
						controller.swDisplayOptions.columns=scope.columns;
                        controller.swListingControls.saveCollection();
                    }
                }

                scope.editingDisplayTitle=false;

                scope.editDisplayTitle = function(){
                    if(angular.isUndefined(scope.column.displayTitle) || !scope.column.displayTitle.length){
                        scope.column.displayTitle = scope.column.title;
                    }
                    scope.previousDisplayTitle=scope.column.displayTitle;
                    scope.editingDisplayTitle = true;
                };
                scope.saveDisplayTitle = function(){
                    scope.saveCollection();
                    scope.editingDisplayTitle = false;
                };
                scope.cancelDisplayTitle = function(){
                    scope.column.displayTitle = scope.previousDisplayTitle;
                    scope.editingDisplayTitle = false;
                };

				if(angular.isUndefined(scope.column.sorting)){
					scope.column.sorting = {
						active:false,
						sortOrder:'asc',
						priority:0
					};
				}
				
				scope.toggleVisible = function(column){
					if(angular.isUndefined(column.isVisible)){
						column.isVisible = false;
					}
					column.isVisible = !column.isVisible;
					scope.saveCollection();
				};

				scope.toggleSearchable = function(column){
					if(angular.isUndefined(column.isSearchable)){
						column.isSearchable = false;
					}
					column.isSearchable = !column.isSearchable;
					scope.saveCollection();
				};

				scope.toggleExportable = function(column){
					$log.debug('toggle exporable');
					if(angular.isUndefined(column.isExportable)){
						column.isExportable = false;
					}
					column.isExportable = !column.isExportable;
					scope.saveCollection();
				};

				var compareByPriority = function(a,b){
					if(a.sorting && b.sorting && angular.isDefined(a.sorting) && angular.isDefined(a.sorting.priority)){
						if(a.sorting.priority < b.sorting.priority){
							return -1;
						}
						if(a.sorting.priority > b.sorting.priority){
							return 1;
						}
					}
					return 0;
				};

				var updateOrderBy = function(){
					if(angular.isDefined(scope.columns)){
						var columnsCopy = angular.copy(scope.columns);
						columnsCopy.sort(compareByPriority);
						scope.orderBy = [];

						angular.forEach(columnsCopy,function(column){
							if(angular.isDefined(column.sorting) && column.sorting.active === true){
								var orderBy = {
									propertyIdentifier:column.propertyIdentifier,
									direction:column.sorting.sortOrder
								};
                                if(column.aggregate && column.aggregate.aggregateFunction){
                                    var aggregateFunction = column.aggregate.aggregateFunction.toUpperCase();
                                    if(aggregateFunction == 'AVERAGE'){
                                        aggregateFunction = 'AVG';
                                    }
                                    orderBy.propertyIdentifier = aggregateFunction + '('+column.propertyIdentifier+')';
                                }
								scope.orderBy.push(orderBy);
							}
						});
					}
				};

				scope.toggleSortable = function(column){
					$log.debug('toggle sortable');
					if(angular.isUndefined(column.sorting)){
						column.sorting = {
								active:true,
								sortOrder:'asc',
								priority:0
						};
					}

					if(column.sorting.active === true){
						if(column.sorting.sortOrder === 'asc'){
							column.sorting.sortOrder = 'desc';
						}else{
							removeSorting(column);
							column.sorting.active = false;

						}
					}else{
						column.sorting.active = true;
						column.sorting.sortOrder = 'asc';
						column.sorting.priority = getActivelySorting().length;
					}
					updateOrderBy();
					scope.saveCollection();

				};

				var removeSorting = (column,saving?)=>{
					if(column.sorting.active === true){
						for(var i in scope.columns){
							if(scope.columns[i].sorting.active === true && scope.columns[i].sorting.priority > column.sorting.priority){
								scope.columns[i].sorting.priority = scope.columns[i].sorting.priority - 1;
							}
						}
						column.sorting.priority = 0;
					}

					if(!saving){
						updateOrderBy();
						scope.saveCollection();
					}

				};

				scope.prioritize = function(column){
					if(column.sorting.priority === 1){

						var activelySorting = getActivelySorting();
						for(var i in scope.columns){
							if(scope.columns[i].sorting.active === true){
								scope.columns[i].sorting.priority = scope.columns[i].sorting.priority - 1;
							}
						}
						column.sorting.priority = activelySorting.length;

					}else{
						for(var i in scope.columns){
							if(scope.columns[i].sorting.active === true && scope.columns[i].sorting.priority === column.sorting.priority - 1){
								scope.columns[i].sorting.priority = scope.columns[i].sorting.priority + 1;
							}
						}

						column.sorting.priority -= 1;
					}

					updateOrderBy();
					scope.saveCollection();
				};

				var getActivelySorting = function(){
					var activelySorting = [];
					for(var i in scope.columns){
						if(scope.columns[i].sorting.active === true){
							activelySorting.push(scope.columns[i]);
						}
					}
					return activelySorting;
				};

				scope.removeColumn = function(columnIndex){
                    if(scope.columns[columnIndex].isDeletable){
						removeSorting(scope.columns[columnIndex],true);
                        controller.swDisplayOptions.removeColumn(columnIndex);
                        updateOrderBy();
                        scope.saveCollection();
                    }
				};
			}
		};
	}

}
export{
	SWColumnItem
}
