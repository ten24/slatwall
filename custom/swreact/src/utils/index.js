import jwt_decode from 'jwt-decode'

export const cleanHTML = data => data.replace('class=', 'className=')
export const renameKeys = (obj, find, replace = '') => {
  Object.keys(obj).forEach(key => {
    const newKey = key.replace(find, replace)
    obj[newKey] = obj[key]
    delete obj[key]
  })
}
export const renameKeysInArrayOfObjects = (arr, find, replace) => {
  arr.forEach(obj => {
    renameKeys(obj, find, replace)
  })
}

export const isAuthenticated = () => {
  let token = localStorage.getItem('token')
  if (token) {
    try {
      token = jwt_decode(token)
      return token.exp && token.exp * 1000 > Date.now() && token.accountID.length > 0
    } catch (error) {}
  }
  return false
}

export const containsHTML = str => /<[a-z][\s\S]*>/i.test(str)
export const isString = val => 'string' === typeof val
export const isBoolean = val => 'boolean' === typeof val
export const booleanToString = value => (value ? 'Yes' : 'No')
export const skuIdsToSkuCodes = (idList, productOptionGroups) => {
  return productOptionGroups
    .map(optionGroup =>
      optionGroup.options
        .filter(option => {
          return idList.includes(option.optionID)
        })
        .map(option => {
          let payload = {}
          payload[optionGroup.optionGroupCode] = option.optionCode
          return payload
        })
    )
    .flat()
}
export const parseErrorMessages = error => {
  if (error instanceof Object) {
    console.log('1', error)
    return Object.keys(error)
      .map(key => parseErrorMessages(error[key]))
      .flat()
  }
  return error
}
export const getErrorMessage = error => {
  return parseErrorMessages(error)?.join('. ')
}
