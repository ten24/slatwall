import React from 'react'
import { Link } from 'react-router-dom'
import { useHistory } from 'react-router-dom'
import CartMenuItem from './CartMenuItem'
import AccountBubble from './AccountBubble'
import logo from '../../assets/images/logo.png'
import mobileLogo from '../../assets/images/logo-mobile.png'
import { useTranslation } from 'react-i18next'
import groupBy from 'lodash/groupBy'
import queryString from 'query-string'
import { useSelector } from 'react-redux'

const extractMenuFromContent = content => {
  let menu = Object.keys(content)
    .map(key => {
      return key.includes('productcategories') ? content[key] : null
    })
    .filter(item => {
      return item
    })
    .sort((a, b) => {
      return a.sortOrder - b.sortOrder
    })
  if (menu.length) {
    const groupedItems = groupBy(menu, 'parentContentID')
    menu = menu
      .map(item => {
        item.children = groupedItems.hasOwnProperty(item.contentID) ? groupedItems[item.contentID] : []
        return item
      })
      .filter(item => {
        return item.children.length
      })
      .filter(item => {
        return item.urlTitle != 'productcategories'
      })
      .sort((a, b) => {
        return a.sortOrder - b.sortOrder
      })
  }
  return menu
}

const MegaMenu = props => {
  let history = useHistory()
  const { t, i18n } = useTranslation()

  return (
    <li className="nav-item dropdown">
      <a className="nav-link dropdown-toggle" href={props.linkUrl || '/'} data-toggle="dropdown">
        {props.title}
      </a>
      <div className="dropdown-menu pt-0 pb-3">
        <div className="nav-shop-all">
          <Link to={props.linkUrl || '/'}>
            {`${t('frontend.nav.shopall')} ${props.title}`}
            <i className="far fa-arrow-right ml-2"></i>
          </Link>
        </div>
        <div className="d-flex flex-wrap flex-lg-nowrap px-2">
          {props.subMenu.map((productCategory, index) => {
            return (
              <div key={index} className="mega-dropdown-column py-4 px-3">
                <div
                  className="widget widget-links mb-3"
                  onClick={event => {
                    event.preventDefault()
                    if (event.target.getAttribute('href')) {
                      history.push(event.target.getAttribute('href'))
                    }
                  }}
                  dangerouslySetInnerHTML={{
                    __html: productCategory['customBody'],
                  }}
                />
              </div>
            )
          })}
        </div>
      </div>
    </li>
  )
}

function Header() {
  const { t, i18n } = useTranslation()
  let history = useHistory()
  const content = useSelector(state => state.content)
  const menuItems = extractMenuFromContent(content)
  const mainNavigation = content['header/main-navigation'] ? content['header/main-navigation'].customBody : ''
  return (
    <header className="shadow-sm">
      <div className="navbar-sticky bg-light">
        <div className="navbar navbar-expand-lg navbar-light">
          <div className="container">
            <Link className="navbar-brand d-none d-md-block mr-3 flex-shrink-0" to="/">
              <img src={logo} alt={t('frontend.logo')} />
            </Link>
            <Link className="navbar-brand d-md-none mr-2" to="/">
              <img src={mobileLogo} style={{ minWidth: '90px' }} alt={t('frontend.logo')} />
            </Link>

            <div className="navbar-right">
              <div className="navbar-topright">
                <div className="input-group-overlay d-none d-lg-flex">
                  <input
                    className="form-control appended-form-control"
                    type="text"
                    onKeyDown={e => {
                      if (e.key === 'Enter') {
                        e.preventDefault()
                        history.push({
                          pathname: '/products',
                          search: queryString.stringify({ keyword: e.target.value }, { arrayFormat: 'comma' }),
                        })
                      }
                    }}
                    // onChange={e => debounced.callback(e.target.value)}
                    placeholder={t('frontend.search.placeholder')}
                  />
                  <div className="input-group-append-overlay">
                    <span className="input-group-text">
                      <i
                        style={{ cursor: 'pointer' }}
                        onClick={e => {
                          e.preventDefault()
                          history.push({
                            pathname: '/products',
                            search: queryString.stringify({ keyword: e.target.value }, { arrayFormat: 'comma' }),
                          })
                        }}
                        className="far fa-search"
                      ></i>
                    </span>
                  </div>
                </div>
                <div className="navbar-toolbar d-flex flex-shrink-0 align-items-center">
                  <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse">
                    <span className="navbar-toggler-icon"></span>
                  </button>
                  <a className="navbar-tool navbar-stuck-toggler" href="#">
                    <span className="navbar-tool-tooltip">{t('frontend.nav.expand')}</span>
                    <div className="navbar-tool-icon-box">
                      <i className="far fa-bars"></i>
                    </div>
                  </a>
                  <Link className="navbar-tool ml-1 ml-lg-0 mr-n1 mr-lg-2" to="/my-account" data-toggle="modal">
                    <AccountBubble />
                  </Link>

                  <CartMenuItem />
                </div>
              </div>

              <div
                className="navbar-main-links"
                onClick={event => {
                  event.preventDefault()
                  if (event.target.getAttribute('href')) {
                    history.push(event.target.getAttribute('href'))
                  }
                }}
                dangerouslySetInnerHTML={{
                  __html: mainNavigation,
                }}
              />
            </div>
          </div>
        </div>

        <div className="navbar navbar-expand-lg navbar-dark bg-dark navbar-stuck-menu mt-2 pt-0 pb-0">
          <div className="container p-0">
            <div className="collapse navbar-collapse" id="navbarCollapse">
              <div className="input-group-overlay d-lg-none my-3 ml-0">
                <div className="input-group-prepend-overlay">
                  <span className="input-group-text">
                    <i className="far fa-search"></i>
                  </span>
                </div>
                <input className="form-control prepended-form-control" type="text" placeholder={t('frontend.search.placeholder')} />
              </div>

              <ul className="navbar-nav nav-categories">
                {menuItems.map((menuItem, index) => {
                  return <MegaMenu key={index} subMenu={menuItem.children} title={menuItem.title} linkUrl={menuItem.linkUrl} />
                })}
              </ul>
              <ul className="navbar-nav mega-nav ml-lg-2">
                <li className="nav-item">
                  <Link className="nav-link" to="/">
                    <i className="far fa-industry-alt mr-2"></i>
                    {t('frontend.nav.manufacturer')}
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </header>
  )
}

export default Header
