
class FrontendController {

        //@ngInject
        constructor(
                private $scope,
                private $element, private $log: ng.ILogService,
                private $hibachi,
                private collectionConfigService,
                private selectionService) {

        }

}
export { FrontendController }