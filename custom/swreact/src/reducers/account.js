const initialState = {}

const reducer = (state = initialState, action) => {
  const { type } = action

  switch (type) {
    case 'LOGIN_ACTION':
      return { ...state, isLoggedIn: true }
    case 'LOGOUT_ACTION':
      return { ...state, isLoggedIn: false }
    default:
      return { ...state }
  }
}
export default reducer
