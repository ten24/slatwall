const initialState = {}

const reducer = (state = initialState, action) => {
  const { type } = action

  switch (type) {
    case 'BATCH_ACTION':
      return { ...state, isPreloaded: true }
    default:
      return { ...state }
  }
}
export default reducer
