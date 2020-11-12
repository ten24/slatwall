import { combineReducers } from "redux"
import shop from "./shop.reducer"
import filter from "./filter.reducer"

export default combineReducers({
  shop,
  filter,
})
