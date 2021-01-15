var testConfig = require('../../admin/client/webpack.config');
var path = require('path');
var customPath = __dirname;
var PATHS = {
    app: path.join(customPath, '/src'),
    lib: path.join(customPath, '/lib')
};
testConfig.output.path = PATHS.app;

delete testConfig.plugins;
delete testConfig.entry.vendor; //remove the vendor info from this version.
testConfig.output.filename = 'testbundle.js';
module.exports = testConfig;