/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWDashboardController {
  // @ngInject
  constructor(
    private $scope,
    private $q,
    private $transclude,
    private $http,
    private requestService,
    private dashboardService
  ) {
    console.log("SWDashboardController");
    console.log(dashboardService);
    
    dashboardService.getReportData();

  }
}

class SWDashboard implements ng.IDirective {
  public restrict = "E";
  public controller = SWDashboardController;
  public templateUrl;
  public transclude = true;
  public controllerAs = "swDashboard";
  public scope = {};
  public bindToController = {
    name: "@?",
  };
  public link: ng.IDirectiveLinkFn = (
    scope: ng.IScope,
    element: ng.IAugmentedJQuery,
    attrs: ng.IAttributes,
    transcludeFn: ng.ITranscludeFunction
  ) => {
    console.log("SWDashboard IDirectiveLinkFn");
    console.log(scope);
  };

  /**
   * Handles injecting the partials path into this class
   */
  public static Factory() {
    var directive = (widgetPartialPath, hibachiPathBuilder) =>
      new SWDashboard(widgetPartialPath, hibachiPathBuilder);
    directive.$inject = ["widgetPartialPath", "hibachiPathBuilder"];
    return directive;
  }
  constructor(widgetPartialPath, hibachiPathBuilder) {
    this.templateUrl =
      hibachiPathBuilder.buildPartialsPath(widgetPartialPath) + "dashboard.html";
    console.log("SWTileBarController Factory constructor ");
  }
}

export { SWDashboard };
