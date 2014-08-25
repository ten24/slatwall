angular.module('slatwalladmin')
.directive('swCriteria', 
['$http',
'$compile',
'$templateCache',
'partialsPath',
'$log',
'collectionService',
function($http,
$compile,
$templateCache,
partialsPath,
$log,
collectionService){
	//private functions
	var getTemplate = function(criteriaORMType){
        var template = '';
		var templatePath = '';
        switch(criteriaORMType){
            case 'boolean':
               templatePath = partialsPath+"criteriaBoolean.html";
                break;
            case 'string':
                templatePath = partialsPath+"criteriaString.html";
                break;
            case 'timestamp':
                templatePath = partialsPath+"criteriaDate.html";
                break;
            case 'big_decimal':
            	templatePath = partialsPath+"criteriaBigDecimal.html";
            	break;
        }
        
        var templateLoader = $http.get(templatePath,{cache:$templateCache});
		
        return templateLoader;
    }; 
    
    var getStringOptions = function(){
    	var stringOptions = [
			
			{
				display:"Equals",
				comparisonOperator:"="
			},
			{
				display:"Doesn't Equal",
				comparisonOperator:"<>"
			},
			{
				display:"Contains",
				comparisonOperator:"like",
				pattern:"%w%"
			},
			{
				display:"Doesn't Contain",
				comparisonOperator:"not like",
				pattern:"%w%"
			},
			{
				display:"Starts With",
				comparisonOperator:"like",
				pattern:"w%"
			},
			{
				display:"Doesn't Start With",
				comparisonOperator:"not like",
				pattern:"w%"
			},
			{
				display:"Ends With",
				comparisonOperator:"like",
				pattern:"%w"
			},
			{
				display:"Doesn't End With",
				comparisonOperator:"not like",
				pattern:"%w"
			},
			{
				display:"In List",
				comparisonOperator:"in"
			},
			{
				display:"Not In List",
				comparisonOperator:"not in"
			},
			{
				display:"Defined",
				comparisonOperator:"is",
				value:"null"
			},
			{
				display:"Not Defined",
				comparisonOperator:"not is",
				value:"null"
			}
		];
		return stringOptions;
    };
    
    var getBooleanOptions = function(){
    	var booleanOptions = [
    		{
    			display:"True",
    			comparisonOperator:"=",
    			value:"True"
    		},
    		{
    			display:"False",
    			comparisonOperator:"=",
    			value:"False"
    		},
    		{
    			display:"Defined",
    			comparisonOperator:"is",
    			value:"null"
    		},
    		{
    			display:"Not Defined",
    			comparisonOperator:"is not",
    			value:"null"
    		}
    	];
    	return booleanOptions;
    };
    
    var getDateOptions = function(){
    	var dateOptions = [
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
    			display:"Defined",
    			comparisonOperator:	"is",
    			value:"null"
    		},
    		{
    			display:"Not Defined",
    			comparisonOperator:	"is not",
    			value:"null"
    		}
    	];
    	
    	return dateOptions;
    };
    
    var getBigDecimalOptions = function(){
    	var bigDecimalOptions = [
    		{
				display:"Equals",
				comparisonOperator:"="
			},
			{
				display:"Doesn't Equal",
				comparisonOperator:"<>"
			},
			{
    			display:"In Range",
    			comparisonOperator:	"between",
    			type:"range"
    		},
    		{
    			display:"Not In Range",
    			comparisonOperator:	"not between",
    			type:"range"
    		},
    		{
    			display:"Greater Than",
    			comparisonOperator:">"
    		},
    		{
    			display:"Greater Than Or Equal",
    			comparisonOperator:">="
    		},
    		{
    			display:"Less Than",
    			comparisonOperator:"<"
    		},
    		{
    			display:"Less Than Or Equal",
    			comparisonOperator:"<="
    		},
			{
				display:"In List",
				comparisonOperator:"in"
			},
			{
				display:"Not In List",
				comparisonOperator:"not in"
			},
			{
				display:"Defined",
				comparisonOperator:"is",
				value:"null"
			},
			{
				display:"Not Defined",
				comparisonOperator:"not is",
				value:"null"
			}
    	];
    	return bigDecimalOptions;
    };
    
    var linker = function(scope, element, attrs){
		
		scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
			if(angular.isDefined(selectedFilterProperty)){
				switch(scope.selectedFilterProperty.ORMTYPE){
		    		case "boolean":
		    			scope.booleanOptions = getBooleanOptions();
		    			break;
		    		case "string":
		    			scope.stringOptions = getStringOptions();
		    			
		    			scope.selectedConditionChanged = function(selectedFilterProperty){
		    				console.log(selectedFilterProperty);
		    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
		    					selectedFilterProperty.showCriteriaValue = false;
		    				}else{
		    					selectedFilterProperty.showCriteriaValue = true;
		    				}
		    			};
		    			break;
		    		case "timestamp":
		    			scope.dateOptions = getDateOptions();
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
							
						  	var selectedCondition = selectedFilterProperty.selectedCriteriaType;
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
				  								selectedFilterProperty.criteriaRangeStart = dateBOD;
				  								break;
				  							case 'w':
				  								var firstDayOfWeek = Date.today().last().monday();
				  								selectedFilterProperty.criteriaRangeStart = firstDayOfWeek;
				  								break;
				  							case 'm':
				  								var firstDayOfMonth = Date.today().moveToFirstDayOfMonth();
							  					selectedFilterProperty.criteriaRangeStart = firstDayOfMonth;
				  								break;
				  							case 'q':
				  								var month = Date.parse('today').toString('MM');
				  								var year = Date.parse('today').toString('yyyy');
				  								var quarterMonth = (Math.floor(month/3)*3);
				  								var firstDayOfQuarter = new Date(year,quarterMonth,1);
				  								selectedFilterProperty.criteriaRangeStart = firstDayOfQuarter;
				  								break;
				  							case 'y':
				  								var year = Date.parse('today').toString('yyyy');
				  								var firstDayOfYear = new Date(year,0,1);
				  								selectedFilterProperty.criteriaRangeStart = firstDayOfYear;
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
						  			selectedCondition.showNumberOf = false; 
						  			selectedCondition.conditionDisplay = '';
						  			selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0,0,0,0);
			  						selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23,59,59,999);
						  		}
						  	}else{
						  		selectedCondition.showCriteriaStart = false;
						  		selectedCondition.showCriteriaEnd = false;
						  		selectedCondition.showNumberOf = false;
						  		
						  		selectedCondition.conditionDisplay = '';
						  	}
					  		$log.debug('selectedConditionChanged');
					  		$log.debug(selectedCondition); 
					  		$log.debug(selectedFilterProperty);
						  };
						  
						  scope.criteriaRangeChanged = function(selectedFilterProperty){
						  	var selectedCondition = selectedFilterProperty.selectedCriteriaType;
						  	if(selectedCondition.dateInfo.type === 'calculation'){
							  	var measureCount = selectedFilterProperty.criteriaNumberOf;
				  				switch(selectedCondition.dateInfo.measureType){
				  					case 'h':
				  						var today = Date.parse('today');
					  					selectedFilterProperty.criteriaRangeEnd = today;
					  					var todayXHoursAgo = Date.parse('today').add(-(measureCount)).hours();
					  					selectedFilterProperty.criteriaRangeStart = todayXHoursAgo;
				  						break;
				  					case 'd':
				  						var lastFullDay = Date.parse('today').add(-1).days();
				  						lastFullDay.setHours(23,59,59,999);
				  						selectedFilterProperty.criteriaRangeEnd = lastFullDay;
				  						var lastXDaysAgo = Date.parse('today').add(-(measureCount)).days();
										selectedFilterProperty.criteriaRangeStart = lastXDaysAgo;
										break;
									case 'w':
										var lastFullWeekEnd = Date.today().last().sunday();
										lastFullWeekEnd.setHours(23,59,59,999);
										selectedFilterProperty.criteriaRangeEnd = lastFullWeekEnd;
										var lastXWeeksAgo = Date.today().last().sunday().add(-(measureCount)).weeks();
										selectedFilterProperty.criteriaRangeStart = lastXWeeksAgo;
										break;
									case 'm':
										var lastFullMonthEnd = Date.today().add(-1).months().moveToLastDayOfMonth();
										lastFullMonthEnd.setHours(23,59,59,999);
					  					selectedFilterProperty.criteriaRangeEnd = lastFullMonthEnd;
					  					var lastXMonthsAgo = Date.today().add(-1).months().moveToLastDayOfMonth().add(-(measureCount)).months();
					  					selectedFilterProperty.criteriaRangeStart = lastXMonthsAgo;
										break;
									case 'q':
										 var currentQuarter = Math.floor((Date.parse('today').getMonth() / 3));	
										 var firstDayOfCurrentQuarter = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
										 var lastDayOfPreviousQuarter = firstDayOfCurrentQuarter.add(-1).days();
										 lastDayOfPreviousQuarter.setHours(23,59,59,999);
										 selectedFilterProperty.criteriaRangeEnd = lastDayOfPreviousQuarter;
										 
										 var lastXQuartersAgo = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
									 	lastXQuartersAgo.add(-(measureCount * 3)).months();
									 	selectedFilterProperty.criteriaRangeStart = lastXQuartersAgo;
										 
										break;
									case 'y':
										var lastFullYearEnd = new Date(new Date().getFullYear(), 11, 31).add(-1).years();
										lastFullYearEnd.setHours(23,59,59,999);
					  					selectedFilterProperty.criteriaRangeEnd = lastFullYearEnd;
					  					var lastXYearsAgo = new Date(new Date().getFullYear(), 11, 31).add(-(measureCount)-1).years();
					  					selectedFilterProperty.criteriaRangeStart = lastXYearsAgo;
										break;
				  				}
			  				}
			  				
			  				if(selectedCondition.dateInfo.type === 'exactDate'){
			  					selectedFilterProperty.criteriaRangeStart = selectedFilterProperty.criteriaRangeStart.setHours(0,0,0,0);
			  					selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23,59,59,999);
			  				}
			  				if(selectedCondition.dateInfo.type === 'range'){
			  					if(angular.isDefined(selectedFilterProperty.criteriaRangeStart)){
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
		    			break;
		    		case "big_decimal":
		    			scope.bigDecimalOptions = getBigDecimalOptions();
		    			scope.criteriaRangeChanged = function(selectedFilterProperty){
						  	var selectedCondition = selectedFilterProperty.selectedCriteriaType;
						  	console.log(selectedFilterProperty);
		    			};
		    			
		    			scope.selectedConditionChanged = function(selectedFilterProperty){
		    				console.log(selectedFilterProperty);
		    				selectedFilterProperty.showCriteriaValue = true;
		    				//check whether the type is a range
		    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.type)){
		    					selectedFilterProperty.showCriteriaValue = false;
		    					selectedFilterProperty.selectedCriteriaType.showCriteriaStart = true;
		    					selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = true;
		    				}
		    				//is null or is not null
		    				if(angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)){
		    					selectedFilterProperty.showCriteriaValue = false;
		    				}
		    			};
		    			
		    			
		    			
		    			break;
		    	}
				
				var templateLoader = getTemplate(selectedFilterProperty.ORMTYPE);
		    	var promise = templateLoader.success(function(html){
					element.html(html);
					$compile(element.contents())(scope);
				});
			}
    	}); 
    	
    };
    
	return {
		restrict: 'A',
		scope:{
			filterItem:"=",
	        selectedFilterProperty:"="
		},
		link: linker,
		controller:function ($scope) {
			  
			  
		}
	};
}]);
	
