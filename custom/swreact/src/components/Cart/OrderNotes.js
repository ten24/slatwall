import { useDispatch, useSelector } from 'react-redux'
import { useTranslation } from 'react-i18next'
import { useState } from 'react'
import { updateOrderNotes } from '../../actions/cartActions'

const OrderNotes = () => {
  const dispatch = useDispatch()
  const { orderNotes = '', isFetching } = useSelector(state => state.cart)
  const { t } = useTranslation()
  const [notes, setOrderNotes] = useState({ text: '', original: '' })
  if (orderNotes !== notes.original) {
    setOrderNotes({ text: orderNotes, original: orderNotes })
  }
  return (
    <div className="form-group mb-4 mt-3">
      <label className="mb-2" htmlFor="order-comments">
        <span className="font-weight-medium">{t('frontend.order.notes')}</span>
      </label>
      <textarea
        className="form-control"
        rows="6"
        disabled={isFetching}
        id="order-comments"
        value={notes.text}
        onChange={e => {
          e.preventDefault()
          setOrderNotes({ text: e.target.value, original: orderNotes })
        }}
      />
      {notes.text !== notes.original && (
        <button
          className="btn btn-secondary btn-block mt-4"
          type="submit"
          disabled={isFetching}
          onClick={event => {
            dispatch(
              updateOrderNotes({
                orderNotes: notes.text,
              })
            )
            event.preventDefault()
          }}
        >
          {/* {t('frontend.order.complete')} */}
          Save Notes
        </button>
      )}
    </div>
  )
}
export { OrderNotes }
