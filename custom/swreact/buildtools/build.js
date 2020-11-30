const fs = require('fs')
const manifest = require('../build/asset-manifest.json')
const assetPrefix = '/custom/swreact/'
const relativePath = `${__dirname}/../../apps/slatwallCMS/stoneAndBerg/templates/inc/`
let cssFiles = ''
let jsFiles = ''

var myArgs = process.argv.slice(2)
const devBuild = () => {
  manifest.entrypoints.map(item => {
    if (item.indexOf('.css') !== -1) {
      cssFiles += `<link rel="stylesheet" media="screen" id="main-styles" href="${assetPrefix}${item}"></link>\n`
    } else if (item.indexOf('.js') !== -1) {
      jsFiles += `<script src="${assetPrefix}${item}" ></script>\n`
    }
  })
  fs.writeFile(
    `${relativePath}/reactFooterAssets.cfm`,
    `<cfoutput>\n${jsFiles}</cfoutput>`,
    err => {
      // throws an error, you could also catch it here
      if (err) throw err
    }
  )
}

const staticBuild = () => {
  manifest.entrypoints.map(item => {
    if (item.indexOf('.css') !== -1) {
      cssFiles += `<link rel="stylesheet" media="screen" id="main-styles" href="${assetPrefix}${item}"></link>\n`
    } else if (item.indexOf('.js') !== -1) {
      jsFiles += `<script src="${assetPrefix}${item}" ></script>\n`
    }
  })

  fs.writeFile(
    `${relativePath}/header/reactHeaderAssets.cfm`,
    `<cfoutput>\n${cssFiles}</cfoutput>`,
    err => {
      // throws an error, you could also catch it here
      if (err) throw err
    }
  )
  fs.writeFile(
    `${relativePath}/reactFooterAssets.cfm`,
    `<cfoutput>\n${jsFiles}</cfoutput>`,
    err => {
      // throws an error, you could also catch it here
      if (err) throw err
    }
  )
}

switch (myArgs[0]) {
  case 'dev':
    devBuild()
    break
  default:
    staticBuild()
}
