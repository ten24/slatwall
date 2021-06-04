import { createStore, applyMiddleware } from 'redux'
import thunkMiddleware from 'redux-thunk'
import { composeWithDevTools } from 'redux-devtools-extension'
import { content, authReducer, userReducer, cart, configuration } from './reducers'
import devData from './preload'
import { combineReducers } from 'redux'

const rootReducer = combineReducers({
  content,
  authReducer,
  userReducer,
  cart,
  configuration,
})

const preloadedState = { configuration: devData }
// preloadedState.preload = {...devData,...preloadedState.preload}
// Allow the passed state to be garbage-collected
const store = createStore(rootReducer, preloadedState, composeWithDevTools(applyMiddleware(thunkMiddleware)))

export default store
