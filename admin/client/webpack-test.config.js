var devConfig = require('../../org/Hibachi/client/webpack.config');
devConfig.entry.app = ['./test.ts'];
devConfig.addVendor('jquery-ui-timepicker-addon','../../HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js')
.addVendor('jquery-typewatch','../../HibachiAssets/js/jquery-typewatch-2.0.js')
.addVendor('date','date/date.min.js')
.addVendor('angular','angular/angular.min.js')
.addVendor('angular-lazy-bootstrap','angular-lazy-bootstrap/bootstrap.js')
.addVendor('ui.bootstrap','angular-ui-bootstrap/ui.bootstrap.min.js')
.addVendor('angular-resource','angular/angular-resource.min.js')
.addVendor('angular-cookies','angular/angular-cookies.min.js')
.addVendor('angular-route','angular/angular-route.min.js')
.addVendor('angular-animate','angular/angular-animate.min.js')
.addVendor('angular-sanitize','angular/angular-sanitize.min.js')
.addVendor('metismenu','metismenu/metismenu.js')
.addVendor('angularjs-datetime-picker','angularjs-datetime-picker/angularjs-datetime-picker.js')

;
devConfig.output.filename = 'testbundle.js';
module.exports = devConfig.setupApp(__dirname);