import axios from 'axios'
import store from '../createStore'

axios.interceptors.request.use(config => {
  const siteCode = store.getState().configuration.site.siteCode
  config.headers['SWX-requestSiteCode'] = siteCode
  if (localStorage.getItem('token')) {
    config.headers['Auth-Token'] = `Bearer ${localStorage.getItem('token')}`
  }
  return config
})

axios.interceptors.response.use(
  successRes => {
    if (successRes.data.token) localStorage.setItem('token', successRes.data.token)
    return successRes
  },
  error => {}
)

export { axios }
