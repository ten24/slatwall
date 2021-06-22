import { useSelector } from 'react-redux'

const PromotionalMessaging = () => {
  const appliedPromotionMessages = useSelector(state => state.cart.appliedPromotionMessages)
  return (
    <>
      {appliedPromotionMessages.length > 0 &&
        appliedPromotionMessages.map(({ message }, index) => {
          return (
            <div key={index} className="alert alert-success alert-wicon" role="alert">
              <i className="fal fa-usd-circle"></i>
              {message}
            </div>
          )
        })}
    </>
  )
}
export { PromotionalMessaging }
