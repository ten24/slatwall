/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var Date:any;
class SWCriteriaDate{
	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$log,
			$hibachi,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder
		)=>new SWCriteriaDate(
			$log,
			$hibachi,
			$filter,
			collectionPartialsPath,
			collectionService,
			metadataService,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$hibachi',
			'$filter',
			'collectionPartialsPath',
			'collectionService',
			'metadataService',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		$hibachi,
		$filter,
		collectionPartialsPath,
		collectionService,
		metadataService,
		hibachiPathBuilder
	){
		return {
			restrict: 'E',
			templateUrl:hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+'criteriadate.html',
			link: function(scope, element, attrs){
				var getDateOptions = function(type){
					if(angular.isUndefined(type)){
				 		type = 'filter'
				 	}
				 	var dateOptions = [];
				 	if(type === 'filter'){
				    	dateOptions = [
				    		{
				    			display:"Date",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    			}
				    		},
				    		{
				    			display:"In Range",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'range'
				    			}
				    		},
				    		{
				    			display:"Not In Range",
				    			comparisonOperator:	"not between",
				    			dateInfo:{
				    				type:'range'
				    			}
				    		},
				    		{
				    			display:"Today",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'d',
				    				measureCount:0,
				    				behavior:'toDate'
				    			}
				    		},
				    		{
				    			display:"Yesterday",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'d',
				    				measureCount:-1,
				    				behavior:'toDate'
				    			}
				    		},
				    		{
				    			display:"This Week",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'w',
				    				behavior:'toDate'
				    			}
				    		},
				    		{
				    			display:"This Month",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'m',
				    				behavior:'toDate'
				    			}
				    		},
				    		{
				    			display:"This Quarter",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'q',
				    				behavior:'toDate'
				    			}
				    		},
				    		{
				    			display:"This Year",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'y',
				    				behavior:'toDate'
				    			}
				    		},
				    		{
				    			display:"Last N Hour(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'h',
				    				measureTypeDisplay:'Hours'
				    			}
				    		},
				    		{
				    			display:"Last N Day(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'d',
				    				measureTypeDisplay:'Days'
				    			}
				    		},
				    		{
				    			display:"Last N Week(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'w',
				    				measureTypeDisplay:'Weeks'

				    			}
				    		},
				    		{
				    			display:"Last N Month(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'m',
				    				measureTypeDisplay:'Months'
				    			}
				    		},
				    		{
				    			display:"Last N Quarter(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'q',
				    				measureTypeDisplay:'Quarters'
				    			}
				    		},
				    		{
				    			display:"Last N Year(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'calculation',
				    				measureType:'y',
				    				measureTypeDisplay:'Years'
				    			}
				    		},
                            {
								display:"Exact N Day(s) Ago",
								comparisonOperator:	"between",
								dateInfo:{
									type:'exactDate',
									measureType:'d',
									measureTypeDisplay:'Days'
								}
							},
							{
								display:"Exact N Month(s) Ago",
								comparisonOperator:	"between",
								dateInfo:{
									type:'exactDate',
									measureType:'m',
									measureTypeDisplay:'Months'
								}
							},
							{
								display:"Exact N Year(s) Ago",
								comparisonOperator:	"between",
								dateInfo:{
									type:'exactDate',
									measureType:'y',
									measureTypeDisplay:'Years'
								}
							},
							{
								display:"Defined",
								comparisonOperator:"is not",
								value:"null"
							},
							{
								display:"Not Defined",
								comparisonOperator:"is",
								value:"null"
							}
				    	];
				    }else if(type === 'condition'){
				 		dateOptions = [
				 			{
								display:"Equals",
								comparisonOperator:"eq"
							},
							{
								display:"Doesn't Equal",
								comparisonOperator:"neq"
							},
							{
								display:"Defined",
								comparisonOperator:"null",
								value:"False"
							},
							{
								display:"Not Defined",
								comparisonOperator:"null",
								value:"True"
							}
				 		];
				 	}

			    	return dateOptions;
			    };

			    scope.conditionOptions = getDateOptions(scope.comparisonType);
				scope.today = function() {
					if (angular.isDefined(scope.selectedFilterProperty)) {
						scope.selectedFilterProperty.criteriaRangeStart = new Date();
						scope.selectedFilterProperty.criteriaRangeEnd = new Date();
					}
				};

				scope.clear = function() {
					scope.selectedFilterProperty.criteriaRangeStart = null;
					scope.selectedFilterProperty.criteriaRangeEnd = null;
				};

				scope.openCalendarStart = function($event) {
					$event.preventDefault();
					$event.stopPropagation();

					scope.openedCalendarStart = true;
				};

				scope.openCalendarEnd = function($event) {
					$event.preventDefault();
					$event.stopPropagation();

					scope.openedCalendarEnd = true;
				};

				scope.formats = [
						'dd-MMMM-yyyy',
						'yyyy/MM/dd',
						'dd.MM.yyyy',
						'shortDate' ];
				scope.format = scope.formats[1];

				scope.selectedConditionChanged = function(selectedFilterProperty){
					$log.debug('selectedConditionChanged Begin');

				  	var selectedCondition:any = selectedFilterProperty.selectedCriteriaType;
				  	//check whether condition is checking for null values in date
				  	if(angular.isDefined(selectedCondition.dateInfo)){
				  		//is condition a calculation
				  		if(selectedCondition.dateInfo.type === 'calculation'){
				  			selectedCondition.showCriteriaStart = true;
				  			selectedCondition.showCriteriaEnd = true;
				  			selectedCondition.disableCriteriaStart = true;
				  			selectedCondition.disableCriteriaEnd = true;

				  			//if item is a calculation of an N number of measure display the measure and number input

		  					if(angular.isUndefined(selectedCondition.dateInfo.behavior)){
				  				$log.debug('Not toDate');
				  				selectedCondition.showNumberOf = true;
				  				selectedCondition.conditionDisplay = 'Number of '+ selectedCondition.dateInfo.measureTypeDisplay + ' :';

		  					}else{
		  						$log.debug('toDate');
		  						var today = Date.parse('today');
			  					var todayEOD = today.setHours(23,59,59,999);
			  					selectedFilterProperty.criteriaRangeEnd = todayEOD;

		  						//get this Measure to date
		  						switch(selectedCondition.dateInfo.measureType){
		  							case 'd':
		  								var dateBOD = Date.parse('today').add(selectedCondition.dateInfo.measureCount).days();
		  								dateBOD.setHours(0,0,0,0);
		  								selectedFilterProperty.criteriaRangeStart = dateBOD.getTime();
		  								break;
		  							case 'w':
		  								var firstDayOfWeek = Date.today().last().monday();
		  								selectedFilterProperty.criteriaRangeStart = firstDayOfWeek.getTime();
		  								break;
		  							case 'm':
		  								var firstDayOfMonth = Date.today().moveToFirstDayOfMonth();
					  					selectedFilterProperty.criteriaRangeStart = firstDayOfMonth.getTime();
		  								break;
		  							case 'q':
		  								var month = Date.parse('today').toString('MM');
		  								var year = Date.parse('today').toString('yyyy');
		  								var quarterMonth = (Math.floor(month/3)*3);
		  								var firstDayOfQuarter = new Date(year,quarterMonth,1);
		  								selectedFilterProperty.criteriaRangeStart = firstDayOfQuarter.getTime();
		  								break;
		  							case 'y':
		  								var year = Date.parse('today').toString('yyyy');
		  								var firstDayOfYear = new Date(year,0,1);
		  								selectedFilterProperty.criteriaRangeStart = firstDayOfYear.getTime();
		  								break;
		  						}

		  					}
				  		}
				  		if(selectedCondition.dateInfo.type === 'range'){
				  			selectedCondition.showCriteriaStart = true;
				  			selectedCondition.showCriteriaEnd = true;

				  			selectedCondition.disableCriteriaStart = false;
				  			selectedCondition.disableCriteriaEnd = false;
				  			selectedCondition.showNumberOf = false;
				  		}
				  		if(selectedCondition.dateInfo.type === 'exactDate'){
				  			selectedCondition.showCriteriaStart = true;
				  			selectedCondition.showCriteriaEnd = false;
				  			selectedCondition.disableCriteriaStart = false;
							selectedCondition.disableCriteriaEnd = true;


							if(!selectedCondition.dateInfo.measureType){
								selectedCondition.conditionDisplay = '';
								selectedCondition.showCriteriaStart = true;
								selectedCondition.showNumberOf = false;

								selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0,0,0,0);
								selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23,59,59,999);
							}else{
								selectedCondition.conditionDisplay = 'How many '+ selectedCondition.dateInfo.measureTypeDisplay+' ago?';
								selectedCondition.showCriteriaStart = false;
								selectedCondition.showNumberOf = true;
							}
				  		}
				  	}else{
				  		selectedCondition.showCriteriaStart = false;
				  		selectedCondition.showCriteriaEnd = false;
				  		selectedCondition.showNumberOf = false;

				  		selectedCondition.conditionDisplay = '';
				  	}
			  		$log.debug('selectedConditionChanged End');
			  		$log.debug('selectedConditionChanged Result');
			  		$log.debug(selectedCondition);
			  		$log.debug(selectedFilterProperty);
				  };

				  scope.criteriaRangeChanged = function(selectedFilterProperty){
					  $log.debug('criteriaRangeChanged');
					  $log.debug(selectedFilterProperty);
				  	var selectedCondition = selectedFilterProperty.selectedCriteriaType;
				  	if(selectedCondition.dateInfo.type === 'calculation'){
					  	var measureCount = selectedFilterProperty.criteriaNumberOf;
		  				switch(selectedCondition.dateInfo.measureType){
		  					case 'h':
		  						var today = Date.parse('today');
			  					selectedFilterProperty.criteriaRangeEnd = today.getTime();
			  					var todayXHoursAgo = Date.parse('today').add(-(measureCount)).hours();
			  					selectedFilterProperty.criteriaRangeStart = todayXHoursAgo.getTime();
		  						break;
		  					case 'd':
		  						var lastFullDay = Date.parse('today').add(-1).days();
		  						lastFullDay.setHours(23,59,59,999);
		  						selectedFilterProperty.criteriaRangeEnd = lastFullDay.getTime();
		  						var lastXDaysAgo = Date.parse('today').add(-(measureCount)).days();
								selectedFilterProperty.criteriaRangeStart = lastXDaysAgo.getTime();
								break;
							case 'w':
								var lastFullWeekEnd = Date.today().last().sunday();
								lastFullWeekEnd.setHours(23,59,59,999);
								selectedFilterProperty.criteriaRangeEnd = lastFullWeekEnd.getTime();
								var lastXWeeksAgo = Date.today().last().sunday().add(-(measureCount)).weeks();
								selectedFilterProperty.criteriaRangeStart = lastXWeeksAgo.getTime();
								break;
							case 'm':
								var lastFullMonthEnd = Date.today().add(-1).months().moveToLastDayOfMonth();
								lastFullMonthEnd.setHours(23,59,59,999);
			  					selectedFilterProperty.criteriaRangeEnd = lastFullMonthEnd.getTime();
			  					var lastXMonthsAgo = Date.today().add(-1).months().moveToLastDayOfMonth().add(-(measureCount)).months();
			  					selectedFilterProperty.criteriaRangeStart = lastXMonthsAgo.getTime();
								break;
							case 'q':
								 var currentQuarter = Math.floor((Date.parse('today').getMonth() / 3));
								 var firstDayOfCurrentQuarter = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
								 var lastDayOfPreviousQuarter = firstDayOfCurrentQuarter.add(-1).days();
								 lastDayOfPreviousQuarter.setHours(23,59,59,999);
								 selectedFilterProperty.criteriaRangeEnd = lastDayOfPreviousQuarter.getTime();

								 var lastXQuartersAgo = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
							 	lastXQuartersAgo.add(-(measureCount * 3)).months();
							 	selectedFilterProperty.criteriaRangeStart = lastXQuartersAgo.getTime();

								break;
							case 'y':
								var lastFullYearEnd = new Date(new Date().getFullYear(), 11, 31).add(-1).years();
								lastFullYearEnd.setHours(23,59,59,999);
			  					selectedFilterProperty.criteriaRangeEnd = lastFullYearEnd.getTime();
			  					var lastXYearsAgo = new Date(new Date().getFullYear(), 11, 31).add(-(measureCount)-1).years();
			  					selectedFilterProperty.criteriaRangeStart = lastXYearsAgo.getTime();
								break;
		  				}
	  				}

	  				if(selectedCondition.dateInfo.type === 'exactDate' && angular.isDefined(selectedFilterProperty.criteriaRangeStart) && angular.isDefined(selectedFilterProperty.criteriaRangeStart.setHours)){
	  					selectedFilterProperty.criteriaRangeStart = selectedFilterProperty.criteriaRangeStart.setHours(0,0,0,0);
	  					selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23,59,59,999);
	  				}
	  				if(selectedCondition.dateInfo.type === 'range' ){
	  					if(angular.isDefined(selectedFilterProperty.criteriaRangeStart) && angular.isDefined(selectedFilterProperty.criteriaRangeStart) ){
	  						selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0,0,0,0);
	  					}

	  					if(angular.isDefined(selectedFilterProperty.criteriaRangeEnd) && angular.isDefined(selectedFilterProperty.criteriaRangeStart)){
	  						selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeEnd).setHours(23,59,59,999);
	  					}

	  				}

				  	$log.debug('criteriaRangeChanged');
			  		$log.debug(selectedCondition);
			  		$log.debug(selectedFilterProperty);
				  };
				   if(angular.isUndefined(scope.filterItem.$$isNew) || scope.filterItem.$$isNew === false){
					  angular.forEach(scope.conditionOptions, function(conditionOption){
							if(conditionOption.display == scope.filterItem.conditionDisplay ){
								scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
								scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;

								if(angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType.dateInfo)
								&& angular.isDefined(scope.filterItem.value)
								&& scope.filterItem.value.length
								){
									var dateRangeArray = scope.filterItem.value.split("-");
									scope.selectedFilterProperty.criteriaRangeStart = new Date(parseInt(dateRangeArray[0]));
									scope.selectedFilterProperty.criteriaRangeEnd = new Date(parseInt(dateRangeArray[1]));
								}

								if(angular.isDefined(scope.selectedConditionChanged)){
									scope.selectedConditionChanged(scope.selectedFilterProperty);
								}
							}
					  });
				  }else{
					  scope.selectedFilterProperty.criteriaValue = '';
					  scope.selectedFilterProperty.criteriaRangeStart = '';
					  scope.selectedFilterProperty.criteriaRangeEnd = '';
				  }

			}
		};
	}
}
export{
	SWCriteriaDate
}
