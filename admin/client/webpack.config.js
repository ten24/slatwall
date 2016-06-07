var devConfig = require('../../org/Hibachi/client/webpack.config');
devConfig.addVendor('jquery-ui-timepicker-addon','../../HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js')
    .addVendor('jquery-typewatch','../../HibachiAssets/js/jquery-typewatch-2.0.js')
    .addVendor('adminjs','../../../../assets/js/admin.js')
    .addVendor('globaljs','../../HibachiAssets/js/global.js')
;
module.exports = devConfig.setupApp(__dirname);