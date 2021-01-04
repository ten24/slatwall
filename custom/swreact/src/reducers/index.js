import { combineReducers } from 'redux'
import authReducer from './authReducer'
import userReducer from './userReducer'
import preload from './preloadReducer'
import cartReducer from './cartReducer'
const rootReducer = combineReducers({
  preload,
  authReducer,
  userReducer,
  cartReducer,
})

export default rootReducer
