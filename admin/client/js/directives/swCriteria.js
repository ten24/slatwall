angular.module('slatwalladmin')
.directive('swCriteria', 
['$http',
'$compile',
'$templateCache',
'partialsPath',
function($http,
$compile,
$templateCache,
partialsPath){
	
	var getTemplate = function(criteriaORMType){
        var template = '';
		var templatePath = '';
        switch(criteriaORMType){
            case 'boolean':
               templatePath = partialsPath+"criteriaBoolean.html"
                break;
            case 'string':
                templatePath = partialsPath+"criteriaString.html";
                break;
            case 'timestamp':
                templatePath = partialsPath+"criteriaDate.html";
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
    }
    
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
    }
    
    var getDateOptions = function(){
    	var dateOptions = [
    		{
    			display:"Date",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				behavior:'exactDate'
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
    				measureCount:-1,
    				behavior:'toDate'
    			}
    		},
    		{
    			display:"This Month",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'m',
    				measureCount:-1,
    				behavior:'toDate'
    			}
    		},
    		{
    			display:"This Quarter",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'q',
    				measureCount:-1,
    				behavior:'toDate'
    			}
    		},
    		{
    			display:"This Year",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'y',
    				measureCount:-1,
    				behavior:'toDate'
    			}
    		},
    		{
    			display:"Last N Hour(s)",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'h',
    			}
    		},
    		{
    			display:"Last N Day(s)",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'d',
    			}
    		},
    		{
    			display:"Last N Week(s)",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'w',
    			}
    		},
    		{
    			display:"Last N Month(s)",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'m',
    			}
    		},
    		{
    			display:"Last N Quarter(s)",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'q',
    			}
    		},
    		{
    			display:"Last N Year(s)",
    			comparisonOperator:	"between",
    			dateInfo:{
    				type:'calculation',
    				measureType:'y',
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
    }
    
    var linker = function(scope, element, attrs){
    	
		scope.stringOptions = getStringOptions();
		scope.dateOptions = getDateOptions();
		scope.booleanOptions = getBooleanOptions();
		console.log(scope.booleanOptions);
		/*switch(selectedFilterProperty.ORMTYPE){
			case 'boolean':
               	
                break;
            case 'string':

                break;
            case 'timestamp':

                break;	
		}*/
		
		scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
			if(angular.isDefined(selectedFilterProperty)){
				var templateLoader = getTemplate(selectedFilterProperty.ORMTYPE)
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
			  $scope.today = function() {
			    $scope.dt = new Date();
			    $scope.dtx = new Date();
			  };
			  $scope.today();
			
			  $scope.clear = function () {
			    $scope.dt = null;
			    $scope.dtx = null;
			  };
			
			  $scope.openCalendarStart = function($event) {
			    $event.preventDefault();
			    $event.stopPropagation();
			
			    $scope.openedCalendarStart = true;
			  };
			  
			  $scope.openCalendarEnd = function($event) {
			    $event.preventDefault();
			    $event.stopPropagation();
			
			    $scope.openedCalendarEnd = true;
			  };
			
			  $scope.initDate = new Date('2016-15-20');
			  $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate'];
			  $scope.format = $scope.formats[1];
			  
			  $scope.selectedConditionChanged = function(selectedCondition){
			  	console.log(selectedCondition);
			  }
		}
	}
}]);
	
