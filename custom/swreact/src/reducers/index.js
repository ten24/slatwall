import { combineReducers } from 'redux'
import authReducer from './authReducer'
import userReducer from './userReducer'
import preload from './preloadReducer'
import cartReducer from './cartReducer'
import productSearchReducer from './productSearchReducer'
import content from './contentReducer'
import configuration from './configReducer'
const rootReducer = combineReducers({
  content,
  preload,
  authReducer,
  userReducer,
  cartReducer,
  productSearchReducer,
  configuration,
})

export default rootReducer
