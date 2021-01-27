import { combineReducers } from 'redux'
import authReducer from './authReducer'
import userReducer from './userReducer'
import preload from './preloadReducer'
import cartReducer from './cartReducer'
import productSearchReducer from './productSearchReducer'
import content from './contentReducer'
const rootReducer = combineReducers({
  content,
  preload,
  authReducer,
  userReducer,
  cartReducer,
  productSearchReducer,
})

export default rootReducer
