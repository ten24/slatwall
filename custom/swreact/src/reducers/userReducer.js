import {
  REQUEST_USER,
  RECEIVE_USER,
  CLEAR_USER,
  REQUEST_CREATE_USER,
  RECEIVE_CREATE_USER,
  ERROR_CREATE_USER,
} from '../actions/userActions'

const initStateFromSlatwall = {
  accountID: '',
  firstName: '',
  lastName: '',
  primaryEmailAddress: {
    emailAddress: '',
  },
  primaryPhoneNumber: {
    phoneNumber: '',
  },
  company: '',
}

const initialState = {
  ...initStateFromSlatwall,
  isFetching: false,
  isRedirect: false,
  err: null,
}

const user = (state = initialState, action) => {
  const { user, err } = action

  switch (action.type) {
    case REQUEST_USER:
      return { ...state, isFetching: true }

    case RECEIVE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return { ...state, ...user }

    case CLEAR_USER:
      return { ...state, initialState }

    case REQUEST_CREATE_USER:
      return { ...state, isFetching: true }

    case RECEIVE_CREATE_USER:
      if (user.loginToken) delete user.loginToken
      user.isFetching = false
      return { ...state, user }

    case ERROR_CREATE_USER:
      return { ...state, err, isFetching: false }

    default:
      return state
  }
}

export default user
