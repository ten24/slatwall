/// <reference path='../../../typings/hibachiTypescript.d.ts' />

import { Chart, ChartData, Point } from 'chart.js';

// <reference path='../../../typings/tsd.d.ts' />


///dev-ops/projects/SlatwallDevelop/org/Hibachi/client/typings/chart.js/index.d.ts
///dev-ops/projects/SlatwallDevelop/org/Hibachi/client/typings/chart.js/index.d.ts
///dev-ops/projects/SlatwallDevelop/org/Hibachi/client/src/widget/components/swchartwidget.ts
class SWChartWidgetController {
  // @ngInject
  constructor(
    private $scope,
    private $q,
    private $transclude,
    private $http,
    private requestService,
    private dashboardService,
    public $rootScope:any
  ) {
    console.log("SWChartWidgetController");
    
$scope.chartData = {
    labels: ["January", "February", "March", "April", "May", "June", "July"],
    series: ['Foo', 'Baz', 'Bar'],
    data: [
        [65, 59, 80, 81, 56, 55, 40],
        [28, 48, 40, 19, 86, 27, 90],
        [42, 17, 28, 73, 50, 12, 68]
    ]
};

$scope.$watch(()=>{
    return dashboardService.chartData
}, ()=>{
    console.log("Attempt check")
    if(angular.isDefined(dashboardService.chartData)){
    console.log(dashboardService.chartData)
    console.log("Attempt render")
        this.renderChart()
    }
})


    // 	jQuery("#hibachi-report-chart").remove();
				// 		jQuery("#hibachi-report-chart-wrapper").hide();
						
					

						
				// 		jQuery("#hibachi-report-chart-wrapper").show();
  }
      public $onInit=()=>{
    }
    
    public renderChart=()=>{
            console.log("report-chart");

        			var ctx = $("#report-chart");
    console.log(this.dashboardService.chartData);

     							var chart = new Chart(ctx, {
							    type: this.dashboardService.chartData.data.type,
							    data: {
							        datasets: [{
							            label: this.dashboardService.chartData.series[0].label,
							            data: this.dashboardService.chartData.series[0].data,
							            borderColor: [
							                '#f38631'
							            ],
							            pointBackgroundColor: "#f38631",
							            pointBorderColor: "#f38631",
							            fill: false,
							            borderWidth: 3,
							            lineTension: 0
							        }]
							    },
							    options: {
							        scales: {
							            yAxes: [{
							                ticks: {
							                    beginAtZero: true
							                }
							            }],
							            xAxes: [{
							            	type: 'time',
							            	ticks: {
							            		source: 'data',
							            	},
							            	time: {
							            		parser: 'string',
							            		unit: this.dashboardService.reportDateTimeGroupBy,
							            		stepSize: 1,
							            	}
							            }]
							        },
							        legend: {
							        	display: false
							        }
							    }
							});	
        chart.draw();
    }
    
}

class SWChartWidget implements ng.IDirective {
  public restrict = "E";
  public controller = SWChartWidgetController;
  public templateUrl;
  public transclude = true;
  public controllerAs = "swChartWidget";
  public scope = {};
  public bindToController = {
    name: "@?",
    reportTitle: "@?",
  };
  public link: ng.IDirectiveLinkFn = (
    scope: ng.IScope,
    element: ng.IAugmentedJQuery,
    attrs: ng.IAttributes,
    transcludeFn: ng.ITranscludeFunction
  ) => {
    console.log("SWChartWidget IDirectiveLinkFn");
    // var canvas =  <HTMLCanvasElement> element[0].children[0]
    //     console.log(element);
    //     console.log(canvas);
    // var context = canvas.getContext('2d');
    //     console.log(context);
    //     const ctx = canvas.getContext('2d');
    //     console.log(canvas);
    //     var myChart = new Chart(ctx, {
    //             type: 'bar',
    //             data: {
    //                 labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
    //                 datasets: [{
    //                     label: '# of Votes',
    //                     data: [12, 19, 3, 5, 2, 3],
    //                     backgroundColor: [
    //                         'rgba(255, 99, 132, 0.2)',
    //                         'rgba(54, 162, 235, 0.2)',
    //                         'rgba(255, 206, 86, 0.2)',
    //                         'rgba(75, 192, 192, 0.2)',
    //                         'rgba(153, 102, 255, 0.2)',
    //                         'rgba(255, 159, 64, 0.2)'
    //                     ],
    //                     borderColor: [
    //                         'rgba(255, 99, 132, 1)',
    //                         'rgba(54, 162, 235, 1)',
    //                         'rgba(255, 206, 86, 1)',
    //                         'rgba(75, 192, 192, 1)',
    //                         'rgba(153, 102, 255, 1)',
    //                         'rgba(255, 159, 64, 1)'
    //                     ],
    //                     borderWidth: 1
    //                 }]
    //             }
    //         });	
    //                 console.log(myChart);

  };

  /**
   * Handles injecting the partials path into this class
   */
  public static Factory() {
    var directive = (widgetPartialPath, hibachiPathBuilder) =>
      new SWChartWidget(widgetPartialPath, hibachiPathBuilder);
    directive.$inject = ["widgetPartialPath", "hibachiPathBuilder"];
    return directive;
  }
  constructor(widgetPartialPath, hibachiPathBuilder) {
    this.templateUrl =
      hibachiPathBuilder.buildPartialsPath(widgetPartialPath) + "chartwidget.html";
    console.log("SWTileBarController Factory constructor ");
  }
}

export { SWChartWidget };
