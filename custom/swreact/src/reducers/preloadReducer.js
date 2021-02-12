const initialState = {}

const reducer = (state = initialState, action) => {
  const { type } = action

  switch (type) {
    case '@@INIT':
      return { ...state, isPreloaded: true }
    case 'PRELOAD_ACTION_EXAMPLE':
      return { ...state, isPreloaded: false }
    case 'SET_TITLE':
      const { title } = action
      return { ...state, title }
    default:
      return { ...state }
  }
}
export default reducer
