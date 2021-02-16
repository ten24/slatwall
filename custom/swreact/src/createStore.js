import { createStore, applyMiddleware } from 'redux'
import thunkMiddleware from 'redux-thunk'
import { composeWithDevTools } from 'redux-devtools-extension'
import rootReducer from './reducers'
import devData from './preload'

const preloadedState = { configuration: devData }
// preloadedState.preload = {...devData,...preloadedState.preload}
// Allow the passed state to be garbage-collected
const store = createStore(rootReducer, preloadedState, composeWithDevTools(applyMiddleware(thunkMiddleware)))

export default store
