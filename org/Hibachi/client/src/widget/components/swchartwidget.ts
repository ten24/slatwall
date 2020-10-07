/// <reference path='../../../typings/hibachiTypescript.d.ts' />
import {
    Chart,
    ChartData,
    Point
} from 'chart.js';

// <reference path='../../../typings/tsd.d.ts' />

class SWChartWidgetController {
    public collectionConfig: any;
    private chartData;
    private chartID = 'report-chart';
    private chart;
    private dates = [];
    private siteId;
    private period = "Day";
    private periodIntervalKey = "createdDateTime";
    private metricKey = "orderTotal";
    private startDateTime;
    private endDateTime;
    // @ngInject
    constructor(
        public $filter,
        private $scope,
        private $q,
        private $transclude,
        private $http,
        private requestService,
        private collectionConfigService,
        public $rootScope: any,
        public observerService
    ) {
        this.observerService.attach((config) => {
            this.period = config.period
            this.startDateTime = config.startDateTime
            this.endDateTime = config.endDateTime
            this.getMyChart()
        }, 'swReportConfigurationBar_PeriodUpdate', 'report-chart');

        this.observerService.attach((siteId) => {
            this.siteId = siteId
            this.getMyChart()
        }, 'swReportConfigurationBar_SiteUpdate', 'report-chart');

        const now = new Date()
        const eodData = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59)
        this.startDateTime = '{ts \'' + new Date(eodData).addDays(-13).toString('yyyy-MM-dd HH:mm:ss') + '\'}'
        this.endDateTime = '{ts \'' + eodData.toString('yyyy-MM-dd HH:mm:ss') + '\'}'

        this.getMyChart()
    }
    public getMyChart = () => {



        var metricCollection = this.collectionConfigService.newCollectionConfig('Order');
        metricCollection.setReportFlag(1)

        metricCollection.setPeriodInterval(this.period);
        metricCollection.addDisplayProperty("createdDateTime", '', {
            isHidden: true,
            isPeriod: true
        });
        if (this.siteId) {
            metricCollection.addFilter('orderCreatedSite.siteID', this.siteId, '=');
        } else {
            metricCollection.addFilter('orderCreatedSite.siteID', 'NULL', 'IS');
        }
        metricCollection.addDisplayAggregate('calculatedTotal', 'sum', this.metricKey);
        metricCollection.removeFilterGroupByFilterGroupAlias('dates');
        metricCollection.setOrderBy('createdDateTime|ASC');
        metricCollection.addFilter('createdDateTime', this.startDateTime, '>=', 'AND', true, true, false, 'dates');
        metricCollection.addFilter('createdDateTime', this.endDateTime, '<=', 'AND', true, true, false, 'dates');
        metricCollection.setAllRecords(true);


        metricCollection.getEntity().then((data) => {
            this.dates = []
            this.chartData = []
            if (data["records"] && data["records"].length > 0) {
                let metrics = []

                data["records"].forEach(element => {
                    var value = this.$filter('swdatereporting')(element[this.periodIntervalKey], this.period);

                    this.dates.push(value);
                });

                data["records"].forEach(element => {
                    metrics.push({
                        y: element["orderTotal"],
                        x: element[this.periodIntervalKey]
                    })
                });

                this.chartData = metrics
            }
            this.renderChart()

        });

    }

    public renderChart = () => {
        if (this.chart) {
            this.chart.destroy()
        }

        this.chart = new Chart(this.chartID, {
            type: "line",
            data: {
                labels: this.dates,
                spanGaps: true,

                datasets: [{
                    label: "Revenue",
                    data: this.chartData,
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
                        display: true,
                        scaleLabel: {
                            labelString: "Revenue by " + this.period,
                            display: true,
                        },
                    }]
                },
                legend: {
                    display: false
                }
            }
        });
        this.chart.draw();

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
        collectionConfig: "<?",
        startDateTime: "@?",
        endDateTime: "@?",
        siteId: "@?",
        chartID: "<?"
    };
    public link: ng.IDirectiveLinkFn = (
        scope: ng.IScope,
        element: ng.IAugmentedJQuery,
        attrs: ng.IAttributes,
        transcludeFn: ng.ITranscludeFunction
    ) => {


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
    }
}

export {
    SWChartWidget
};