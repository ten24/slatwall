import _ from 'lodash'
import { createStore, applyMiddleware } from 'redux'
import thunkMiddleware from 'redux-thunk'

import { composeWithDevTools } from 'redux-devtools-extension'
import rootReducer from './reducers'

import devData from './preload'
// Grab the state from a global variable injected into the server-generated HTML
const preloadedState = JSON.parse(window.__PRELOADED_STATE__)

preloadedState.preload = _.merge(preloadedState.preload, devData)
// Allow the passed state to be garbage-collected
delete window.__PRELOADED_STATE__
// Create Redux store with initial state

const store = createStore(rootReducer, preloadedState, composeWithDevTools(applyMiddleware(thunkMiddleware)))
// console.log(store.getState())
export default store
