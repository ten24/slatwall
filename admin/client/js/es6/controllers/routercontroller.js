'use strict';
angular.module('slatwalladmin').controller('routerController', [
    '$scope',
    '$routeParams',
    '$location',
    '$log',
    'partialsPath',
    'baseURL',
    function ($scope, $routeParams, $location, $log, partialsPath, baseURL) {
        $scope.$id = "routerController";
        $scope.partialRoute = '';
        $log.debug($routeParams);
        $log.debug($location);
        var path = $location.path();
        $scope.controllerType = path.split('/')[1];
        var type;
        if ($scope.controllerType === 'entity') {
            $scope.entityName = $routeParams.entityName;
            if (angular.isDefined($routeParams.entityID)) {
                $scope.entityID = $routeParams.entityID || '';
            }
        }
    }
]);

//# sourceMappingURL=../controllers/routercontroller.js.map