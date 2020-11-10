import { createStore } from "redux"
import { persistStore, persistReducer } from "redux-persist" // imports from redux-persist
import storage from "redux-persist/lib/storage" // defaults to localStorage for web

import rootReducer from "./reducers"

const persistConfig = {
  // configuration object for redux-persist
  key: "root",
  storage, // define which storage to use
}
const persistedReducer = persistReducer(persistConfig, rootReducer) // create a persisted reducer

const store = createStore(
  persistedReducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
)
const persistor = persistStore(store) // used to create the persisted store, persistor will be used in the next step

export { store, persistor }
