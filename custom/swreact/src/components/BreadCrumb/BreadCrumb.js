import React from 'react'
import { useTranslation } from 'react-i18next'
import { Link } from 'react-router-dom'
// import PropTypes from 'prop-types'

const Crumb = ({ urlTitle, title }) => {
  return (
    <li className="breadcrumb-item ">
      <Link className="text-nowrap" to={urlTitle}>
        {title}
      </Link>
    </li>
  )
}

const BreadCrumb = ({ crumbs, includeHome = true, brand = [] }) => {
  const { t } = useTranslation()
  return (
    <div className="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
      {crumbs && (
        <nav aria-label="breadcrumb">
          <ol className="breadcrumb flex-lg-nowrap justify-content-center justify-content-lg-start">
            {includeHome && (
              <li className="breadcrumb-item ">
                <Link className="text-nowrap" to="/">
                  <i className="far fa-home" />
                  {t('frontend.core.home')}
                </Link>
              </li>
            )}
            {brand.map(crumb => {
              return <Crumb key={crumb.urlTitle} {...crumb} />
            })}
            {crumbs.map(crumb => {
              return <Crumb key={crumb.urlTitle} {...crumb} />
            })}
          </ol>
        </nav>
      )}
    </div>
  )
}

export { BreadCrumb }
