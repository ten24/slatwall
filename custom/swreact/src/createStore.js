import { createStore, combineReducers } from 'redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import preload from './reducers/preload'
import batch from './reducers/batch'
import account from './reducers/account'
import devData from './preload'
// Grab the state from a global variable injected into the server-generated HTML
const preloadedState = JSON.parse(window.__PRELOADED_STATE__)
preloadedState.preload = process.env.NODE_ENV ? devData : preloadedState.preload
// Allow the passed state to be garbage-collected
delete window.__PRELOADED_STATE__
// Create Redux store with initial state

const rootReducer = combineReducers({
  preload,
  batch,
  account,
})

const store = createStore(rootReducer, preloadedState, composeWithDevTools())
// console.log(store.getState())
export default store
