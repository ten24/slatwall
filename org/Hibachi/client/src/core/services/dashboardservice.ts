import {BaseService} from "./baseservice";

class DashboardService { 
    public dashboardData = {};
    public salesRevenueThisPeriod= 0;
    public reportDateTimeGroupBy;
    public period;
    public orderCount= 0;
    public configureBar;
    public chartData ;
    public averageOrderTotal= 0;
    public accountCount = 0;

    //@ngInject
    constructor(
      public requestService){
        
    }
    
    getReportData = ()=>{
        
         var data = {
      slatAction: "admin:report.default",
      reportID: jQuery('input[name="reportID"]').val(),
      reportName: jQuery("#hibachi-report").data("reportname"),
      reportStartDateTime: jQuery("a.hibachi-report-date-group.active").data(
        "start"
      ),
      reportEndDateTime: jQuery("a.hibachi-report-date-group.active").data(
        "end"
      ),
      reportCompareStartDateTime: jQuery(
        'input[name="reportCompareStartDateTime"]'
      ).val(),
      reportCompareEndDateTime: jQuery(
        'input[name="reportCompareEndDateTime"]'
      ).val(),
      reportDateTimeGroupBy: jQuery("a.hibachi-report-date-group.active").data(
        "groupby"
      ),
      reportSite: jQuery('select[name="siteSelector"').val(),
      showReport: false
    };

    console.log(data);

    var promise = this.requestService.newPublicRequest("/", 
    data, "post", {
    //   "Content-Type": "application/json",
    'Content-Type':"application/x-www-form-urlencoded",
      'X-Hibachi-AJAX': true
    }).promise;

    promise.then((response) => {
      console.log("LOg");
      console.log(response);
        this.salesRevenueThisPeriod = response.report.salesRevenueThisPeriod;
        this.accountCount =  response.report.accountCount;
        this.reportDateTimeGroupBy = response.report.reportDateTimeGroupBy;
        this.period = response.report.period;
        this.orderCount = response.report.orderCount;
        this.configureBar = response.report.configureBar;
        this.chartData = response.report.chartData;
        this.averageOrderTotal = response.report.averageOrderTotal;
        this.accountCount = response.report.accountCount;
        this.dashboardData = response
    });
    }


}
export {
    DashboardService
}