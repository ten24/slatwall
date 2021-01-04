import {
  REQUEST_USER,
  RECEIVE_USER,
  CLEAR_USER,
  REQUEST_CREATE_USER,
  RECEIVE_CREATE_USER,
  ERROR_CREATE_USER,
} from '../actions/userActions'

const initialState = {
  id: null,
  email: null,
  name: null,
  phone: null,
  organizationId: null,
  type: {
    id: null,
    name: null,
  },
  uri: null,
  isActive: null,
  isFetching: false,
  isRedirect: false,
  err: null,
}

const user = (state = initialState, action) => {
  const { user, err } = action

  switch (action.type) {
    case REQUEST_USER:
      return Object.assign({}, state, { isFetching: true })

    case RECEIVE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return Object.assign({}, state, user)

    case CLEAR_USER:
      return Object.assign({}, state, initialState)

    case REQUEST_CREATE_USER:
      return Object.assign({}, state, { isFetching: true })

    case RECEIVE_CREATE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return Object.assign({}, state, user)

    case ERROR_CREATE_USER:
      return Object.assign({}, state, { err, isFetching: false })

    default:
      return state
  }
}

export default user
