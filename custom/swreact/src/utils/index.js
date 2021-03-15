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
      return token.exp && token.exp * 1000 > Date.now()
    } catch (error) {}
  }
  return false
}
