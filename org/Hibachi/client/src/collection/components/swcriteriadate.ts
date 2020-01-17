/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var Date:any;
class SWCriteriaDate{
	public static Factory(){
		var directive:ng.IDirectiveFactory = (
			$log,
			collectionPartialsPath,
			hibachiPathBuilder
		)=>new SWCriteriaDate(
			$log,
			collectionPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'collectionPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$log,
		collectionPartialsPath,
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
				    				type:'date',
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
				    				type:'exactDate',
				    				measureType:'today'
				    			}
				    		},
				    		{
				    			display:"Yesterday",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'yesterday'
				    			}
				    		},
				    		{
				    			display:"This Week",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'tw'
				    			}
				    		},
				    		{
				    			display:"This Month",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'tm'
				    			}
				    		},
				    		{
				    			display:"This Quarter",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'tq'
				    			}
				    		},
				    		{
				    			display:"This Year",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'ty'
				    			}
				    		},
				    		{
				    			display:"Last N Hour(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'lh',
				    				measureTypeDisplay:'Hours'
				    			}
				    		},
				    		{
				    			display:"Last N Day(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'ld',
				    				measureTypeDisplay:'Days'
				    			}
				    		},
				    		{
				    			display:"Last N Week(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'lw',
				    				measureTypeDisplay:'Weeks'

				    			}
				    		},
				    		{
				    			display:"Last N Month(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'lm',
				    				measureTypeDisplay:'Months'
				    			}
				    		},
				    		{
				    			display:"Last N Quarter(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'lq',
				    				measureTypeDisplay:'Quarters'
				    			}
				    		},
				    		{
				    			display:"Last N Year(s)",
				    			comparisonOperator:	"between",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'ly',
				    				measureTypeDisplay:'Years'
				    			} 
				    		},
				    		{
				    			display:"More Than N Day(s) Ago",
				    			comparisonOperator:	"<",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'md',
				    				measureTypeDisplay:'Days'
				    			}
				    		},
				    		{
				    			display:"More Than N Week(s) Ago",
				    			comparisonOperator:	"<",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'mw',
				    				measureTypeDisplay:'Weeks'
 				    			}
				    		},
				    		{
				    			display:"More Than N Month(s) Ago",
				    			comparisonOperator:	"<",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'mm',
				    				measureTypeDisplay:'Months'
				    			}
				    		},
				    		{
				    			display:"More Than N Year(s) Ago",
				    			comparisonOperator:	"<",
				    			dateInfo:{
				    				type:'exactDate',
				    				measureType:'my',
				    				measureTypeDisplay:'Years'
				    			}
				    			
				    		},
                            {
                                display:"Exact N Day(s) Ago",
                                comparisonOperator:	"between",
                                dateInfo:{
                                    type:'exactDate',
                                    measureType:'ed',
                                    measureTypeDisplay:'Days'
                                }
                            },
                            {
                                display:"Exact N Month(s) Ago",
                                comparisonOperator:	"between",
                                dateInfo:{
                                    type:'exactDate',
                                    measureType:'em',
                                    measureTypeDisplay:'Months'
                                }
                            },
                            {
                                display:"Exact N Year(s) Ago",
                                comparisonOperator:	"between",
                                dateInfo:{
                                    type:'exactDate',
                                    measureType:'ey',
                                    measureTypeDisplay:'Years'
                                }
                            },//HERE PROG
							{
                                display:"Exact N Day(s) From Now",
                                comparisonOperator:	"between",
                                dateInfo:{
                                    type:'exactDate',
                                    measureType:'edfn',
                                    measureTypeDisplay:'Days'
                                }
                            },
							{
								display:"Match Day of Month",
								comparisonOperator:	"=",
								dateInfo:{
									type:'matchPart',
									measureType:'d',
									measureTypeDisplay:'Day'
								}
							},
							{
								display:"Match Month",
								comparisonOperator:	"=",
								dateInfo:{
									type:'matchPart',
									measureType:'m',
									measureTypeDisplay:'Month'
								}
							},
							{
								display:"Match Year",
								comparisonOperator:	"=",
								dateInfo:{
									type:'matchPart',
									measureType:'y',
									measureTypeDisplay:'Year'
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
							},
							{
								display:"Past",
								comparisonOperator: "<=",
								value:"now()"
							},
							{
								display:"Future",
								comparisonOperator: ">=",
								value:"now()"
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
						scope.selectedFilterProperty.criteriaRangeStart = new Date().getTime();
						scope.selectedFilterProperty.criteriaRangeEnd = new Date().getTime();
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
				  		if(selectedCondition.dateInfo.type === 'exactDate'){
				  			
			  				var setStartRange = false;
							var setEndRange = false;
							var setNumberOf = false;
							var setStartDate = Date.parse('today');
							var setEndDate = Date.parse('today');
			  				
				  			//get this Measure to date
	  						switch(selectedCondition.dateInfo.measureType){
	  							case "today":
	  								setStartRange = true;
	  								setEndRange = true;
	  								break;
	  							case "yesterday":
	  								setStartRange = true;
	  								setEndRange = true;
	  								setStartDate = setStartDate.add(-1).days();
	  								setEndDate = setStartDate;
	  								break;
	  							case 'tw': //This Week
	  								setStartRange = true;
	  								setEndRange = true;
	  								setStartDate = Date.today().monday().add(-7).days(); //added 7 days because Date.today().monday() is not returning this week's monday
	  								setEndDate = Date.today().sunday();
	  								break;
	  							case 'tm': //This Month
	  								setStartRange = true;
	  								setEndRange = true;
	  								setStartDate = new Date.today().moveToFirstDayOfMonth();
	  								setEndDate = new Date.today().moveToLastDayOfMonth();
	  								break;
	  							case 'tq': //This Quarter
	  								setStartRange = true;
	  								setEndRange = true;
	  								var month = Date.parse('today').toString('M');
	  								var year = Date.parse('today').toString('yyyy');
	  								var quarterMonth = (Math.floor(month/3)*3);
	  								setStartDate = new Date(year,quarterMonth,1);
	  								setEndDate = new Date(year,quarterMonth,1).addMonths(3).add(-1).days();
	  								break;
	  							case 'ty': //This Year
	  								setStartRange = true;
	  								setEndRange = true;
	  								var year = Date.parse('today').toString('yyyy');
	  								setStartDate = new Date(year,0,1);
	  								setEndDate = new Date(year,11,31);
	  								break;
	  							case 'lh': //Last N Hour
	  								setStartRange = true;
	  								setEndRange = true;
	  								setNumberOf = true;
	  								break;
	  							case 'ld': //Last N Day
	  								setStartRange = true;
	  								setEndRange = true;
	  								setNumberOf = true;
	  								setStartDate = setStartDate.add(-1).days();
	  								setEndDate = setStartDate;
	  								break;
	  							case 'lw': //Last N Week
	  								setStartRange = true;
	  								setEndRange = true;
	  								setNumberOf = true;
	  								setStartDate = Date.today().monday().add(-2).weeks();
	  								setEndDate = Date.today().sunday().add(-1).weeks();
	  								break;
	  							case 'lm': //Last N Month
	  								setStartRange = true;
	  								setEndRange = true;
	  								setNumberOf = true;
	  								setStartDate = new Date.today().last().month().moveToFirstDayOfMonth();
	  								setEndDate = new Date.today().last().month().moveToLastDayOfMonth();
	  								break;
	  							case 'lq': //Last Quarter
	  								setStartRange = true;
	  								setEndRange = true;
	  								setNumberOf = true;
	  								var month = Date.parse('today').toString('M');
	  								var year = Date.parse('today').toString('yyyy');
	  								var quarterMonth = (Math.floor(month/3)*3);
	  								setStartDate = new Date(year,quarterMonth,1).addMonths(-3);
	  								setEndDate = new Date(year,quarterMonth,1).add(-1).days();
	  								break;
	  							case 'ly': //Last N Year
	  								setStartRange = true;
	  								setEndRange = true;
	  								setNumberOf = true;
	  								var year = Date.parse('today').toString('yyyy');
	  								setStartDate = new Date(year - 1,0,1);
	  								setEndDate = new Date(year - 1,11,31);
	  								break;
	  							case 'md': //More than N Day Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								setStartDate = setStartDate.add(-1).days();
	  								break;
	  							case 'mw': //More than N Week Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								setStartDate = Date.today().monday().add(-2).weeks();
	  								break;
	  							case 'mm': //More than N Month Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								setStartDate = new Date.today().last().month().moveToFirstDayOfMonth();
	  								break;
	  							case 'my': //More than N Year Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								var year = Date.parse('today').toString('yyyy');
	  								setStartDate = new Date(year - 1,0,1);
	  								break;
	  							case 'ed': //Exact N Day Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								setStartDate = setStartDate.add(-1).days();
	  								break;
	  							case 'em': //Exact N Month Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								setStartDate = new Date.today().last().month().moveToFirstDayOfMonth();
	  								break;
	  							case 'ey': //Exact N Year Ago
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								var year = Date.parse('today').toString('yyyy');
	  								setStartDate = new Date(year - 1,0,1);
	  								break;
	  							case 'edfn':
	  								setStartRange = false;
	  								setEndRange = false;
	  								setNumberOf = true;
	  								break;
	  							// case 'd':
	  							// 	var dateBOD = Date.parse('today').add(selectedCondition.dateInfo.measureCount).days();
	  							// 	dateBOD.setHours(0,0,0,0);
	  							// 	selectedFilterProperty.criteriaRangeStart = dateBOD.getTime();
	  							// 	break;
	  							// case 'w':
	  							// 	var firstDayOfWeek = Date.today().last().monday();
	  							// 	selectedFilterProperty.criteriaRangeStart = firstDayOfWeek.getTime();
	  							// 	break;
	  							// case 'm':
	  							// 	var firstDayOfMonth = Date.today().moveToFirstDayOfMonth();
				  				// 	selectedFilterProperty.criteriaRangeStart = firstDayOfMonth.getTime();
	  							// 	break;
	  							// case 'q':
	  							// 	var month = Date.parse('today').toString('MM');
	  							// 	var year = Date.parse('today').toString('yyyy');
	  							// 	var quarterMonth = (Math.floor(month/3)*3);
	  							// 	var firstDayOfQuarter = new Date(year,quarterMonth,1);
	  							// 	selectedFilterProperty.criteriaRangeStart = firstDayOfQuarter.getTime();
	  							// 	break;
	  							// case 'y':
	  							// 	var year = Date.parse('today').toString('yyyy');
	  							// 	var firstDayOfYear = new Date(year,0,1);
	  							// 	selectedFilterProperty.criteriaRangeStart = firstDayOfYear.getTime();
	  							// 	break;
	  						}
	  						
	  						if(setStartRange == true) {
	  							selectedCondition.showCriteriaStart = true;
	  							selectedCondition.disableCriteriaStart = true;
	  							if(selectedCondition.dateInfo.measureType != "lh") //set time to current, if filter is for hours
				  				{
	  								selectedFilterProperty.criteriaRangeStart = setStartDate.setHours(0,0,0,0);
				  				} else {
				  					selectedFilterProperty.criteriaRangeStart = setStartDate.getTime();
				  				}
	  						} else {
	  							selectedCondition.showCriteriaStart = false;
	  							selectedCondition.disableCriteriaStart = false;
	  						}
	  						
	  						if(setEndRange == true) {
	  							selectedCondition.showCriteriaEnd = true;
				  				selectedCondition.disableCriteriaEnd = true;
				  				if(selectedCondition.dateInfo.measureType != "lh") //set time to current, if filter is for hours
				  				{
				  					selectedFilterProperty.criteriaRangeEnd = setEndDate.setHours(23,59,59,999);
				  				} else {
				  					selectedFilterProperty.criteriaRangeEnd = setEndDate.getTime();
				  				}
	  						} else {
	  							selectedCondition.showCriteriaEnd = false;
				  				selectedCondition.disableCriteriaEnd = false;
	  						}
	  						
	  						selectedCondition.showNumberOf = setNumberOf;
	  						if(setNumberOf == true) {
	  							if(angular.isDefined(selectedCondition.dateInfo.measureTypeDisplay)) {
	  								selectedCondition.conditionDisplay = 'Number of '+ selectedCondition.dateInfo.measureTypeDisplay + ' :';
	  							}
	  						} else {
	  							selectedCondition.conditionDisplay = "";
	  						}

				  			//if item is a calculation of an N number of measure display the measure and number input

		  					// if(angular.isUndefined(selectedCondition.dateInfo.behavior)){
				  			// 	selectedCondition.showNumberOf = true;
				  			// 	selectedCondition.conditionDisplay = 'Number of '+ selectedCondition.dateInfo.measureTypeDisplay + ' :';

		  					// }else{
		  						
		  					// }
				  		}
				  		else if(selectedCondition.dateInfo.type === 'range'){
				  			selectedCondition.showCriteriaStart = true;
				  			selectedCondition.showCriteriaEnd = true;

				  			selectedCondition.disableCriteriaStart = false;
				  			selectedCondition.disableCriteriaEnd = false;
				  			selectedCondition.showNumberOf = false;
				  		}
				  		else  if(selectedCondition.dateInfo.type === 'date'){
				  			selectedCondition.showCriteriaStart = true;
				  			selectedCondition.showCriteriaEnd = false;
				  			selectedCondition.disableCriteriaStart = false;
				  			selectedCondition.showNumberOf = false;
				  		}
				  		else  if(selectedCondition.dateInfo.type === 'matchPart'){
				  			selectedCondition.showCriteriaStart = false;
				  			selectedCondition.showCriteriaEnd = false;
				  			selectedCondition.showNumberOf = true;
				  			selectedCondition.conditionDisplay = 'Enter '+ selectedCondition.dateInfo.measureTypeDisplay+':';
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
			  		
				  }; //End selectedConditionChanged

				  scope.criteriaRangeChanged = function(selectedFilterProperty){
					  $log.debug('criteriaRangeChanged');
					  $log.debug(selectedFilterProperty);
				  	var selectedCondition = selectedFilterProperty.selectedCriteriaType;
				  	var measureCount = selectedFilterProperty.criteriaNumberOf;
				  	if(selectedCondition.dateInfo.type === 'exactDate'){
		  				switch(selectedCondition.dateInfo.measureType){
		  					case 'lh':
			  					var todayXHoursAgo = Date.parse('today').add(-(measureCount)).hours();
			  					selectedFilterProperty.criteriaRangeStart = todayXHoursAgo.getTime();
		  						break;
		  					case 'ld':
		  					case 'md':
		  					//case 'ed':
		  						var lastXDaysAgo = Date.parse('today').add(-(measureCount)).days();
								selectedFilterProperty.criteriaRangeStart = lastXDaysAgo.getTime();
								break;
							case 'lw':
							case 'mw':
								var lastXWeeksAgo = Date.today().last().monday().add(-(measureCount)).weeks();
								selectedFilterProperty.criteriaRangeStart = lastXWeeksAgo.getTime();
								break;
							case 'lm':
							case 'mm':
							//case 'em':
			  					var lastXMonthsAgo = Date.today().months().moveToFirstDayOfMonth().add(-(measureCount)).months();
			  					selectedFilterProperty.criteriaRangeStart = lastXMonthsAgo.getTime();
								break;
							case 'lq':
								 var currentQuarter = Math.floor((Date.parse('today').getMonth() / 3));
								 var lastXQuartersAgo = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
							 	lastXQuartersAgo.add(-(measureCount * 3)).months();
							 	selectedFilterProperty.criteriaRangeStart = lastXQuartersAgo.getTime();
								break;
							case 'ly':
							case 'my':
							//case 'ey':
			  					var lastXYearsAgo = new Date(new Date().getFullYear(), 0, 1).add(-measureCount).years();
			  					selectedFilterProperty.criteriaRangeStart = lastXYearsAgo.getTime();
								break;
							case 'edfn':
								var xDaysFromNow = new Date(Date.parse('today').getTime() + (measureCount * 24 * 60 * 60 * 1000));
								selectedFilterProperty.criteriaRangeStart = xDaysFromNow.setHours(0,0,0,0);
								selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23,59,59,999);
								break;
		  				}
		  				
		  				// if(selectedCondition.dateInfo.measureType == "em" || selectedCondition.dateInfo.measureType == "ed" || selectedCondition.dateInfo.measureType == "ey") {
		  				// 	selectedFilterProperty.criteriaRangeEnd = selectedFilterProperty.criteriaRangeStart.setHours(23,59,59,999);
		  				// }
	  				}
	  				
	  				if(selectedCondition.dateInfo.type === 'date' ){
	  					if(angular.isDefined(selectedFilterProperty.criteriaRangeStart) ){
	  						selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0,0,0,0);
	  						selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23,59,59,999);
	  					}
	  				}
	  				
	  				if(selectedCondition.dateInfo.type === 'range' ){
	  					if(angular.isDefined(selectedFilterProperty.criteriaRangeStart) ){
	  						selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0,0,0,0);
	  					}

	  					if(angular.isDefined(selectedFilterProperty.criteriaRangeEnd)){
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

									scope.selectedFilterProperty.criteriaRangeStart = parseInt(dateRangeArray[0]);
									scope.selectedFilterProperty.criteriaRangeEnd = parseInt(dateRangeArray[1]);
								}

								if(angular.isDefined(scope.selectedConditionChanged)){
									scope.selectedConditionChanged(scope.selectedFilterProperty);
								}
							}
					  });
				  }else{
					  scope.selectedFilterProperty.criteriaValue = '';
					  scope.selectedFilterProperty.criteriaRangeStart = new Date().setHours(0,0,0,0);
					  scope.selectedFilterProperty.criteriaRangeEnd = new Date().setHours(11,59,59,999);
				  }

			}
		};
	}
}
export{
	SWCriteriaDate
}
