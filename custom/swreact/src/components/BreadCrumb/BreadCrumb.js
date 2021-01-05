import React from 'react'
// import PropTypes from 'prop-types'

const Crumb = ({ slug, title }) => {
  return (
    <li className="breadcrumb-item text-nowrap">
      <a href={slug}>{title}</a>
    </li>
  )
}

const BreadCrumb = ({ crumbs }) => {
  return (
    <nav aria-label="breadcrumb">
      <ol className="breadcrumb flex-lg-nowrap justify-content-center justify-content-lg-start">
        {crumbs.map((crumb, index) => {
          return <Crumb key={index} {...crumb} />
        })}
      </ol>
    </nav>
  )
}
export default BreadCrumb
