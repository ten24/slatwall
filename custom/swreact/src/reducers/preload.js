const initialState = {}

const reducer = (state = initialState, action) => {
  const { type } = action

  switch (type) {
    case '@@INIT':
      return { ...state, isPreloaded: true }
    case 'PRELOAD_ACTION_EXAMPLE':
      return { ...state, isPreloaded: false }
    default:
      return { ...state }
  }
}
export default reducer
