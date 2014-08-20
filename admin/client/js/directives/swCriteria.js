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
    			comparisonOperator:	"between"
    		},
    		{
    			display:"In Range",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Not In Range",
    			comparisonOperator:	"not between"
    		},
    		{
    			display:"Today",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Yesterday",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"This Week",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"This Month",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"This Quarter",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"This Year",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Last N Hour(s)",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Last N Day(s)",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Last N Week(s)",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Last N Month(s)",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Last N Quarter(s)",
    			comparisonOperator:	"between"
    		},
    		{
    			display:"Last N Year(s)",
    			comparisonOperator:	"between"
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
	}
}]);
	
