import React from 'react'
import { useLocation } from 'react-router'
import { Link } from 'react-router-dom'
// import PropTypes from 'prop-types'

const Crumb = ({ path, name, index }) => {
  if (index > 0) {
    return (
      <li className="breadcrumb-item text-nowrap">
        <Link to={path}>{name}</Link>
      </li>
    )
  }
  return (
    <li className="breadcrumb-item ">
      <Link className="text-nowrap" to={path}>
        <i className="far fa-home" />
        {name}
      </Link>
    </li>
  )
}
const titleizeWord = str => `${str[0].toUpperCase()}${str.slice(1)}`
const kebabToTitle = str => str.split('-').map(titleizeWord).join(' ')
const toBreadcrumbs = (link, { rootName = 'Home', nameTransform = s => s } = {}) =>
  link
    .split('/')
    .filter(Boolean)
    .reduce(
      (acc, curr, idx, arr) => {
        acc.path += `/${curr}`
        acc.crumbs.push({
          path: acc.path,
          name: nameTransform(curr),
        })

        if (idx === arr.length - 1) return acc.crumbs
        else return acc
      },
      { path: '', crumbs: [{ path: '/', name: rootName }] }
    )

const BreadCrumb = () => {
  let location = useLocation()
  let crumbs = toBreadcrumbs(location.pathname, { nameTransform: kebabToTitle })
  crumbs.pop()
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

export default BreadCrumb
