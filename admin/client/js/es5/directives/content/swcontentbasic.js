"use strict";
angular.module('slatwalladmin').directive('swContentBasic', ['$log', '$location', '$slatwall', 'formService', 'contentPartialsPath', function($log, $location, $slatwall, formService, contentPartialsPath) {
  return {
    restrict: 'EA',
    templateUrl: contentPartialsPath + "contentbasic.html",
    link: function(scope, element, attrs) {
      if (!scope.content.$$isPersisted()) {
        var site = $slatwall.newSite();
        scope.content.$$setSite(site);
        var parentContent = $slatwall.newContent();
        scope.content.$$setParentContent(parentContent);
        var contentTemplateType = $slatwall.newType();
        scope.content.$$setContentTemplateType(contentTemplateType);
      } else {
        scope.content.$$getSite();
        scope.content.$$getParentContent();
      }
    }
  };
}]);

//# sourceMappingURL=../../directives/content/swcontentbasic.js.map