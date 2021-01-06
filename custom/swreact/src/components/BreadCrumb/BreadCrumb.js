import React from 'react'
// import PropTypes from 'prop-types'

const Crumb = ({ slug, title, index }) => {
  if (index > 0) {
    return (
      <li className="breadcrumb-item text-nowrap">
        <a href={slug}>{title}</a>
      </li>
    )
  }
  return (
    <li className="breadcrumb-item ">
      <a className="text-nowrap" href={slug}>
        <i className="far fa-home" />
        {title}
      </a>
    </li>
  )
}

const BreadCrumb = ({ crumbs }) => {
  return (
    <>
      {crumbs && (
        <nav aria-label="breadcrumb">
          <ol className="breadcrumb flex-lg-nowrap justify-content-center justify-content-lg-start">
            {crumbs.map((crumb, index) => {
              return <Crumb key={index} {...crumb} index={index} />
            })}
          </ol>
        </nav>
      )}
    </>
  )
}
BreadCrumb.defaultProps = {
  crumbs: [],
}
export default BreadCrumb
