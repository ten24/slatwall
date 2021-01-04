import { combineReducers } from 'redux'
import authReducer from './authReducer'
import userReducer from './userReducer'
import preload from './preload'
import account from './account'
import batch from './batch'

const rootReducer = combineReducers({
  preload,
  batch,
  account,
  authReducer,
  userReducer,
})

export default rootReducer
