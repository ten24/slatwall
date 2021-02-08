const fs = require('fs')
var _ = require('lodash')
const glob = require('glob')

const propertiesToJSON = properties => {
  return properties
    .split('\n')
    .filter(line => '' !== line.trim())
    .map(line => line.split('='))
    .map(tokens => ({
      [tokens[0].trim()]: tokens[1] ? tokens[1].trim() : ``,
    }))
    .reduce(
      (properties, property) => ({
        ...properties,
        ...property,
      }),
      {}
    )
}

const setValue = (obj, keys, value) => {
  keys = typeof keys === 'string' ? keys.split('.') : keys
  const key = keys.shift()

  if (keys.length === 0) {
    obj[key] = value
    return
  } else if (!obj.hasOwnProperty(key)) {
    obj[key] = {}
  }

  setValue(obj[key], keys, value)
}

const propertiesToJSONObject = properties => {
  let globalTranlations = {}
  properties
    .split('\n')
    .filter(line => '' !== line.trim())
    .filter(line => line.trim().substring(0, 1) !== '#')
    .map(line => line.split('='))
    // .filter(tokens => tokens[0].includes('frontend.'))
    .map(tokens => {
      let obj,
        o = (obj = {})
      tokens[0]
        .trim()
        .split('.')
        .forEach(key => (o = o[key] = {}))
      setValue(obj, tokens[0].trim(), tokens[1] ? tokens[1].trim() : '')
      _.merge(globalTranlations, obj)
    })
  return globalTranlations
}
const rootPropertiesPath = `${__dirname}/../../../config/resourceBundles`
const items = fs.readdirSync(rootPropertiesPath)

items.forEach(fileName => {
  glob(__dirname + `/../../../**/${fileName}`, {}, (err, files) => {
    const name = fileName.split('.')
    fs.mkdirSync(`./src/locales/${name[0]}`, { recursive: true }, err => {
      if (err) throw err
    })
    fs.writeFile(`./src/locales/${name[0]}/translation.json`, '', err => {
      // throws an error, you could also catch it here
      if (err) throw err
    })
    let fileData = {}

    files.forEach(file => {
      const translationFile = fs.readFileSync(file, 'utf8')
      const newTranslations = propertiesToJSONObject(translationFile)

      const translationValues = { [name[0]]: { translation: newTranslations } }
      fileData = _.merge(fileData, translationValues)
    })

    fs.writeFile(`./src/locales/${name[0]}/translation.json`, JSON.stringify(fileData), err => {
      // throws an error, you could also catch it here
      if (err) throw err
    })
  })
})
