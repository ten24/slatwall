import { useHistory } from 'react-router-dom'

const AccountContent = ({ customBody, contentTitle }) => {
  let history = useHistory()

  return (
    <>
      <div className="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
        <div className="d-flex justify-content-between w-100">
          <h2 className="h3">{contentTitle}</h2>
        </div>
      </div>

      <div
        onClick={event => {
          event.preventDefault()
          history.push(event.target.getAttribute('href'))
        }}
        dangerouslySetInnerHTML={{
          __html: customBody,
        }}
      />
    </>
  )
}
export default AccountContent
