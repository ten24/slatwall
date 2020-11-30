process.env.NODE_ENV = 'development'

const fs = require('fs-extra')
const paths = require('react-scripts/config/paths')
const webpack = require('webpack')
const config = require('react-scripts/config/webpack.config')('development')

// the output directory of the development files
outputPath = paths.appPath + '/dist'
config.output.path = outputPath

// // update the webpack dev config in order to remove the use of webpack hotreload tools
// config.entry = config.entry.filter((f) => !f.match(/webpackHotDevClient/));
// config.plugins = config.plugins.filter((p) => !(p instanceof webpack.HotModuleReplacementPlugin));
fs.emptyDir(outputPath)
webpack(config).watch({}, err => {
  if (err) {
    console.error(err)
  } else {
    // copy the remaining thing from the public folder to the output folder
    fs.copySync(paths.appPublic, outputPath, {
      dereference: true,
      filter: file => file !== paths.appHtml,
    })
  }
})
