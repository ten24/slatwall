import { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { logout } from '../../../actions/'
import { useSelector, useDispatch } from 'react-redux'
import { useTranslation } from 'react-i18next'
import { getMyAccountMenu } from '../../../selectors/'

const isSelectedClass = 'bg-secondary  mb-0 text-primary'

const AccountSidebar = () => {
  const { t } = useTranslation()
  let loc = useLocation()
  const accountMenu = useSelector(getMyAccountMenu)
  const user = useSelector(state => state.userReducer)
  const dispatch = useDispatch()
  const [disableButton, setdisableButton] = useState(false)

  return (
    <aside className="col-lg-4 pt-4 pt-lg-0">
      <div className="cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0">
        <div className="px-4 mb-4">
          <div className="media align-items-center">
            <div className="media-body">
              <h3 className="font-size-base mb-0">{`${user.firstName} ${user.lastName}`}</h3>
              <button
                type="button"
                disabled={disableButton}
                onClick={() => {
                  setdisableButton(true)
                  dispatch(logout())
                }}
                className="link-button text-accent font-size-sm"
              >
                {t('frontend.core.logout')}
              </button>
              <br />
            </div>
          </div>
        </div>

        <ul className="list-unstyled mb-0 ">
          <li key={'/my-account'} className={`border-bottom mb-0 ${loc.pathname === `/my-account` && isSelectedClass}`}>
            <Link to={'/my-account'} className="nav-link-style d-flex align-items-center px-4 py-3">
              <i className="far pr-2" /> {t('frontend.account.overview')}
            </Link>
          </li>
          {accountMenu.map(({ contentID, urlTitlePath, title }) => {
            return (
              <li key={contentID} className={`border-bottom mb-0 ${loc.pathname.startsWith(`/${urlTitlePath}`) && isSelectedClass}`}>
                <Link to={`/${urlTitlePath}`} className="nav-link-style d-flex align-items-center px-4 py-3">
                  <i className="far pr-2" /> {title}
                </Link>
              </li>
            )
          })}
        </ul>
      </div>
    </aside>
  )
}

const AccountHeader = () => {
  let loc = useLocation()
  const content = useSelector(state => state.content[loc.pathname.substring(1)])
  const { title } = content || {}
  return (
    <div className="page-title-overlap bg-lightgray pt-4">
      <div className="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">{/* <BreadCrumb /> */}</div>
        <div className="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 className="h3 mb-0">{title}</h1>
        </div>
      </div>
    </div>
  )
}

const MyAccountLayout = ({ children }) => {
  return (
    <>
      <AccountHeader />
      <div className="container pb-5 mb-2 mb-md-3">
        <div className="row">
          <AccountSidebar />
          <section className="col-lg-8">{children}</section>
        </div>
      </div>
    </>
  )
}

const PromptLayout = ({ children }) => {
  return (
    <div className="container py-4 py-lg-5 my-4">
      <div className="row d-flex justify-content-center">
        <div className="col-md-6">
          <div className="card box-shadow">
            <div className="card-body">{children}</div>
          </div>
        </div>
      </div>
    </div>
  )
}

const AccountLayout = MyAccountLayout
export { AccountLayout, PromptLayout }
