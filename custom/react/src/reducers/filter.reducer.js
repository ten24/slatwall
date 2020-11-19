import { ADD_AUTHOR_TO_FILTER, REMOVE_AUTHOR_FROM_FILTER } from '../actions'

const filterReducer = (state = '', action) => {
  switch (action.type) {
    case ADD_AUTHOR_TO_FILTER: {
      if (state.includes(action.author)) return state
      return (state += action.author)
    }
    case REMOVE_AUTHOR_FROM_FILTER: {
      const reg = new RegExp(action.author, 'gi')
      return state.replace(reg, '')
    }
    default:
      return state
  }
}

export default filterReducer
