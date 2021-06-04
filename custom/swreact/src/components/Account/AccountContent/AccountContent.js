import { useSelector } from 'react-redux'
import { useHistory, useLocation } from 'react-router-dom'

const AccountContent = () => {
  let history = useHistory()
  let loc = useLocation()
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const { customBody = '', contentSubtitle = '' } = content || {}

  return (
    <>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">
          <h5 className="h5">{contentSubtitle}</h5>
        </div>
      </div>

      <div
        onClick={event => {
          event.preventDefault()
          if (event.target.getAttribute('href')) {
            history.push(event.target.getAttribute('href'))
          }
        }}
        dangerouslySetInnerHTML={{
          __html: customBody,
        }}
      />
    </>
  )
}
export default AccountContent
