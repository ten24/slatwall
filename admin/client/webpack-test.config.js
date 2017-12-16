var testConfig = require('../../org/Hibachi/client/webpack.config');
var path = require('path');
var customPath = __dirname;
var PATHS = {
    app: path.join(customPath, '/src'),
    lib: path.join(customPath, '/lib')
};
testConfig.output.path = PATHS.app;
testConfig.entry.app = [customPath + '/src/test.ts'];
console.log("Test Paths: ", customPath);

//delete testConfig.entry.vendor; //remove the vendor info from this version.
testConfig.output.filename = 'testbundle.js';
module.exports = testConfig;