'use strict';
angular.module('slatwalladmin').directive('swHref', [
    function () {
        return {
            restrict: 'A',
            scope: {
                swHref: "@"
            },
            link: function (scope, element, attrs) {
                /*convert link to use hashbang*/
                var hrefValue = attrs.swHref;
                hrefValue = '?ng#!' + hrefValue;
                element.attr('href', hrefValue);
            }
        };
    }
]);

//# sourceMappingURL=../../directives/common/swhref.js.map