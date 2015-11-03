/// <reference path="angular.d.ts" />
// issue: https://github.com/borisyankov/DefinitelyTyped/issues/369
// https://github.com/witoldsz/angular-http-auth/blob/master/src/angular-http-auth.js
/**
 * @license HTTP Auth Interceptor Module for AngularJS
 * (c) 2012 Witold Szczerba
 * License: MIT
 */
class AuthService {
    constructor() {
        /**
          * Holds all the requests which failed due to 401 response,
          * so they can be re-requested in future, once login is completed.
          */
        this.buffer = [];
        /**
         * Required by HTTP interceptor.
         * Function is attached to provider to be invisible for regular users of this service.
         */
        this.pushToBuffer = function (config, deferred) {
            this.buffer.push({
                config: config,
                deferred: deferred
            });
        };
        this.$get = [
            '$rootScope', '$injector', function ($rootScope, $injector) {
                var $http; //initialized later because of circular dependency problem
                function retry(config, deferred) {
                    $http = $http || $injector.get('$http');
                    $http(config).then(function (response) {
                        deferred.resolve(response);
                    });
                }
                function retryAll() {
                    for (var i = 0; i < this.buffer.length; ++i) {
                        retry(this.buffer[i].config, this.buffer[i].deferred);
                    }
                    this.buffer = [];
                }
                return {
                    loginConfirmed: function () {
                        $rootScope.$broadcast('event:auth-loginConfirmed');
                        retryAll();
                    }
                };
            }
        ];
    }
}
angular.module('http-auth-interceptor', [])
    .provider('authService', AuthService)
    .config(['$httpProvider', 'authServiceProvider', function ($httpProvider, authServiceProvider) {
        var interceptor = ['$rootScope', '$q', function ($rootScope, $q) {
                function success(response) {
                    return response;
                }
                function error(response) {
                    if (response.status === 401) {
                        var deferred = $q.defer();
                        authServiceProvider.pushToBuffer(response.config, deferred);
                        $rootScope.$broadcast('event:auth-loginRequired');
                        return deferred.promise;
                    }
                    // otherwise
                    return $q.reject(response);
                }
                return function (promise) {
                    return promise.then(success, error);
                };
            }];
        $httpProvider.interceptors.push(interceptor);
    }]);
var HttpAndRegularPromiseTests;
(function (HttpAndRegularPromiseTests) {
    var someController = ($scope, $http, $q) => {
        $http.get("http://somewhere/some/resource")
            .success((data) => {
            $scope.person = data;
        });
        $http.get("http://somewhere/some/resource")
            .then((response) => {
            // typing lost, so something like
            // var i: number = response.data
            // would type check
            $scope.person = response.data;
        });
        $http.get("http://somewhere/some/resource")
            .then((response) => {
            // typing lost, so something like
            // var i: number = response.data
            // would NOT type check
            $scope.person = response.data;
        });
        var aPromise = $q.when({ firstName: "Jack", lastName: "Sparrow" });
        aPromise.then((person) => {
            $scope.person = person;
        });
        var bPromise = $q.when(42);
        bPromise.then((answer) => {
            $scope.theAnswer = answer;
        });
        var cPromise = $q.when(["a", "b", "c"]);
        cPromise.then((letters) => {
            $scope.letters = letters;
        });
        // When $q.when is passed an IPromise<T>, it returns an IPromise<T>
        var dPromise = $q.when($q.when("ALBATROSS!"));
        dPromise.then((snack) => {
            $scope.snack = snack;
        });
        // $q.when may be called without arguments
        var ePromise = $q.when();
        ePromise.then(() => {
            $scope.nothing = "really nothing";
        });
    };
    // Test that we can pass around a type-checked success/error Promise Callback
    var anotherController = ($scope, $http, $q) => {
        var buildFooData = () => 42;
        var doFoo = (callback) => {
            $http.get('/foo', buildFooData())
                .success(callback);
        };
        doFoo((data) => console.log(data));
    };
})(HttpAndRegularPromiseTests || (HttpAndRegularPromiseTests = {}));
// Test for AngularJS Syntax
var My;
(function (My) {
    var Namespace;
    (function (Namespace) {
    })(Namespace = My.Namespace || (My.Namespace = {}));
})(My || (My = {}));
// IModule Registering Test
var mod = angular.module('tests', []);
mod.controller('name', function ($scope) { });
mod.controller('name', ['$scope', function ($scope) { }]);
mod.controller(My.Namespace);
mod.directive('name', function ($scope) { });
mod.directive('name', ['$scope', function ($scope) { }]);
mod.directive(My.Namespace);
mod.factory('name', function ($scope) { });
mod.factory('name', ['$scope', function ($scope) { }]);
mod.factory(My.Namespace);
mod.filter('name', function ($scope) { });
mod.filter('name', ['$scope', function ($scope) { }]);
mod.filter(My.Namespace);
mod.provider('name', function ($scope) { return { $get: () => { } }; });
mod.provider('name', TestProvider);
mod.provider('name', ['$scope', function ($scope) { }]);
mod.provider(My.Namespace);
mod.service('name', function ($scope) { });
mod.service('name', ['$scope', function ($scope) { }]);
mod.service(My.Namespace);
mod.constant('name', 23);
mod.constant('name', "23");
mod.constant(My.Namespace);
mod.value('name', 23);
mod.value('name', "23");
mod.value(My.Namespace);
mod.decorator('name', function ($scope) { });
mod.decorator('name', ['$scope', function ($scope) { }]);
class TestProvider {
    constructor($scope) {
        this.$scope = $scope;
    }
    $get() {
    }
}
// Promise signature tests
var foo;
foo.then((x) => {
    // x is inferred to be a number
    return "asdf";
}).then((x) => {
    // x is inferred to be string
    x.length;
    return 123;
}).then((x) => {
    // x is infered to be a number
    x.toFixed();
    return;
}).then((x) => {
    // x is infered to be void
    // Typescript will prevent you to actually use x as a local variable
    // Try object:
    return { a: 123 };
}).then((x) => {
    // Object is inferred here
    x.a = 123;
    //Try a promise
    var y;
    return y;
}).then((x) => {
    // x is infered to be a number, which is the resolved value of a promise
    x.toFixed();
});
var httpFoo;
httpFoo.then((x) => {
    // When returning a promise the generic type must be inferred.
    var innerPromise;
    return innerPromise;
}).then((x) => {
    // must still be number.
    x.toFixed();
});
httpFoo.success((data, status, headers, config) => {
    var h = headers("test");
    h.charAt(0);
    var hs = headers();
    hs["content-type"].charAt(1);
});
function test_angular_forEach() {
    var values = { name: 'misko', gender: 'male' };
    var log = [];
    angular.forEach(values, function (value, key) {
        this.push(key + ': ' + value);
    }, log);
    //expect(log).toEqual(['name: misko', 'gender: male']);
}
// angular.element() tests
var element = angular.element("div.myApp");
var scope = element.scope();
var isolateScope = element.isolateScope();
function test_IAttributes(attributes) {
    return attributes;
}
test_IAttributes({
    $normalize: function (classVal) { },
    $addClass: function (classVal) { },
    $removeClass: function (classVal) { },
    $set: function (key, value) { },
    $observe: function (name, fn) {
        return fn;
    },
    $attr: {}
});
class SampleDirective {
    constructor() {
        this.restrict = 'A';
        this.name = 'doh';
    }
    compile(templateElement) {
        return {
            post: this.link
        };
    }
    static instance() {
        return new SampleDirective();
    }
    link(scope) {
    }
}
class SampleDirective2 {
    constructor() {
        this.restrict = 'EAC';
    }
    compile(templateElement) {
        return {
            pre: this.link
        };
    }
    static instance() {
        return new SampleDirective2();
    }
    link(scope) {
    }
}
angular.module('SameplDirective', []).directive('sampleDirective', SampleDirective.instance).directive('sameplDirective2', SampleDirective2.instance);
angular.module('AnotherSampleDirective', []).directive('myDirective', ['$interpolate', '$q', ($interpolate, $q) => {
        return {
            restrict: 'A',
            link: (scope, el, attr) => {
                $interpolate(attr['test'])(scope);
                $interpolate('', true)(scope);
                $interpolate('', true, 'html')(scope);
                $interpolate('', true, 'html', true)(scope);
                var defer = $q.defer();
                defer.reject();
                defer.resolve();
                defer.promise.then(function (d) {
                    return d;
                }).then(function () {
                    return null;
                }, function () {
                    return null;
                })
                    .catch(() => {
                    return null;
                })
                    .finally(() => {
                    return null;
                });
                var promise = new $q((resolve) => {
                    resolve();
                });
                promise = new $q((resolve, reject) => {
                    reject();
                    resolve(true);
                });
                promise = new $q((resolver, reject) => {
                    resolver(true);
                    reject(false);
                });
            }
        };
    }]);
// test from https://docs.angularjs.org/guide/directive
angular.module('docsSimpleDirective', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.customer = {
            name: 'Naomi',
            address: '1600 Amphitheatre'
        };
    }])
    .directive('myCustomer', function () {
    return {
        template: 'Name: {{customer.name}} Address: {{customer.address}}'
    };
});
angular.module('docsTemplateUrlDirective', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.customer = {
            name: 'Naomi',
            address: '1600 Amphitheatre'
        };
    }])
    .directive('myCustomer', function () {
    return {
        templateUrl: 'my-customer.html'
    };
});
angular.module('docsRestrictDirective', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.customer = {
            name: 'Naomi',
            address: '1600 Amphitheatre'
        };
    }])
    .directive('myCustomer', function () {
    return {
        restrict: 'E',
        templateUrl: 'my-customer.html'
    };
});
angular.module('docsScopeProblemExample', [])
    .controller('NaomiController', ['$scope', function ($scope) {
        $scope.customer = {
            name: 'Naomi',
            address: '1600 Amphitheatre'
        };
    }])
    .controller('IgorController', ['$scope', function ($scope) {
        $scope.customer = {
            name: 'Igor',
            address: '123 Somewhere'
        };
    }])
    .directive('myCustomer', function () {
    return {
        restrict: 'E',
        templateUrl: 'my-customer.html'
    };
});
angular.module('docsIsolateScopeDirective', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.naomi = { name: 'Naomi', address: '1600 Amphitheatre' };
        $scope.igor = { name: 'Igor', address: '123 Somewhere' };
    }])
    .directive('myCustomer', function () {
    return {
        restrict: 'E',
        scope: {
            customerInfo: '=info'
        },
        templateUrl: 'my-customer-iso.html'
    };
});
angular.module('docsIsolationExample', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.naomi = { name: 'Naomi', address: '1600 Amphitheatre' };
        $scope.vojta = { name: 'Vojta', address: '3456 Somewhere Else' };
    }])
    .directive('myCustomer', function () {
    return {
        restrict: 'E',
        scope: {
            customerInfo: '=info'
        },
        templateUrl: 'my-customer-plus-vojta.html'
    };
});
angular.module('docsTimeDirective', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.format = 'M/d/yy h:mm:ss a';
    }])
    .directive('myCurrentTime', ['$interval', 'dateFilter', function ($interval, dateFilter) {
        return {
            link: function (scope, element, attrs) {
                var format, timeoutId;
                function updateTime() {
                    element.text(dateFilter(new Date(), format));
                }
                scope.$watch(attrs['myCurrentTime'], function (value) {
                    format = value;
                    updateTime();
                });
                element.on('$destroy', function () {
                    $interval.cancel(timeoutId);
                });
                // start the UI update process; save the timeoutId for canceling
                timeoutId = $interval(function () {
                    updateTime(); // update DOM
                }, 1000);
            }
        };
    }]);
angular.module('docsTransclusionDirective', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.name = 'Tobias';
    }])
    .directive('myDialog', function () {
    return {
        restrict: 'E',
        transclude: true,
        templateUrl: 'my-dialog.html'
    };
});
angular.module('docsTransclusionExample', [])
    .controller('Controller', ['$scope', function ($scope) {
        $scope.name = 'Tobias';
    }])
    .directive('myDialog', function () {
    return {
        restrict: 'E',
        transclude: true,
        scope: {},
        templateUrl: 'my-dialog.html',
        link: function (scope, element) {
            scope['name'] = 'Jeff';
        }
    };
});
angular.module('docsIsoFnBindExample', [])
    .controller('Controller', ['$scope', '$timeout', function ($scope, $timeout) {
        $scope.name = 'Tobias';
        $scope.hideDialog = function () {
            $scope.dialogIsHidden = true;
            $timeout(function () {
                $scope.dialogIsHidden = false;
            }, 2000);
        };
    }])
    .directive('myDialog', function () {
    return {
        restrict: 'E',
        transclude: true,
        scope: {
            'close': '&onClose'
        },
        templateUrl: 'my-dialog-close.html'
    };
});
angular.module('dragModule', [])
    .directive('myDraggable', ['$document', function ($document) {
        return function (scope, element, attr) {
            var startX = 0, startY = 0, x = 0, y = 0;
            element.css({
                position: 'relative',
                border: '1px solid red',
                backgroundColor: 'lightgrey',
                cursor: 'pointer'
            });
            element.on('mousedown', function (event) {
                // Prevent default dragging of selected content
                event.preventDefault();
                startX = event.pageX - x;
                startY = event.pageY - y;
                $document.on('mousemove', mousemove);
                $document.on('mouseup', mouseup);
            });
            function mousemove(event) {
                y = event.pageY - startY;
                x = event.pageX - startX;
                element.css({
                    top: y + 'px',
                    left: x + 'px'
                });
            }
            function mouseup() {
                $document.off('mousemove', mousemove);
                $document.off('mouseup', mouseup);
            }
        };
    }]);
angular.module('docsTabsExample', [])
    .directive('myTabs', function () {
    return {
        restrict: 'E',
        transclude: true,
        scope: {},
        controller: function ($scope) {
            var panes = $scope['panes'] = [];
            $scope['select'] = function (pane) {
                angular.forEach(panes, function (pane) {
                    pane.selected = false;
                });
                pane.selected = true;
            };
            this.addPane = function (pane) {
                if (panes.length === 0) {
                    $scope['select'](pane);
                }
                panes.push(pane);
            };
        },
        templateUrl: 'my-tabs.html'
    };
})
    .directive('myPane', function () {
    return {
        require: '^myTabs',
        restrict: 'E',
        transclude: true,
        scope: {
            title: '@'
        },
        link: function (scope, element, attrs, tabsCtrl) {
            tabsCtrl.addPane(scope);
        },
        templateUrl: 'my-pane.html'
    };
});
angular.module('copyExample', [])
    .controller('ExampleController', ['$scope', function ($scope) {
        $scope.master = {};
        $scope.update = function (user) {
            // Example with 1 argument
            $scope.master = angular.copy(user);
        };
        $scope.reset = function () {
            // Example with 2 arguments
            angular.copy($scope.master, $scope.user);
        };
        $scope.reset();
    }]);
var locationTests;
(function (locationTests) {
    var $location;
    /*
     * From https://docs.angularjs.org/api/ng/service/$location
     */
    // given url http://example.com/#/some/path?foo=bar&baz=xoxo
    var searchObject = $location.search();
    // => {foo: 'bar', baz: 'xoxo'}
    // set foo to 'yipee'
    $location.search('foo', 'yipee');
    // => $location
    // set foo to 5
    $location.search('foo', 5);
    // => $location
    /*
     * From: https://docs.angularjs.org/guide/$location
     */
    // in browser with HTML5 history support:
    // open http://example.com/#!/a -> rewrite to http://example.com/a
    // (replacing the http://example.com/#!/a history record)
    $location.path() == '/a';
    $location.path('/foo');
    $location.absUrl() == 'http://example.com/foo';
    $location.search() == {};
    $location.search({ a: 'b', c: true });
    $location.absUrl() == 'http://example.com/foo?a=b&c';
    $location.path('/new').search('x=y');
    $location.url() == 'new?x=y';
    $location.absUrl() == 'http://example.com/new?x=y';
    // in browser without html5 history support:
    // open http://example.com/new?x=y -> redirect to http://example.com/#!/new?x=y
    // (again replacing the http://example.com/new?x=y history item)
    $location.path() == '/new';
    $location.search() == { x: 'y' };
    $location.path('/foo/bar');
    $location.path() == '/foo/bar';
    $location.url() == '/foo/bar?x=y';
    $location.absUrl() == 'http://example.com/#!/foo/bar?x=y';
})(locationTests || (locationTests = {}));
// NgModelController
function NgModelControllerTyping() {
    var ngModel;
    var $http;
    var $q;
    // See https://docs.angularjs.org/api/ng/type/ngModel.NgModelController#$validators
    ngModel.$validators['validCharacters'] = function (modelValue, viewValue) {
        var value = modelValue || viewValue;
        return /[0-9]+/.test(value) &&
            /[a-z]+/.test(value) &&
            /[A-Z]+/.test(value) &&
            /\W+/.test(value);
    };
    ngModel.$asyncValidators['uniqueUsername'] = function (modelValue, viewValue) {
        var value = modelValue || viewValue;
        return $http.get('/api/users/' + value).
            then(function resolved() {
            return $q.reject('exists');
        }, function rejected() {
            return true;
        });
    };
}

//# sourceMappingURL=angular-tests.js.map
