import React from 'react'
import { useLocation } from 'react-router'
import { Link } from 'react-router-dom'
// import PropTypes from 'prop-types'

const Crumb = ({ path, name, index }) => {
  //override path for product detail breadcrumb with last page visited
  // if (path === '/product') {
  //   let lastLocation = localStorage.getItem('lastLocation')
  //   if (typeof lastLocation !== undefined) {
  //     lastLocation = JSON.parse(lastLocation) //parse to valid object
  //     lastLocation = lastLocation[lastLocation.length - 1] //get last elemenet

  //     //override path and name with last page
  //     path = lastLocation.path
  //     name = lastLocation.name
  //   }
  // }

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

/**
 * Returns custom path for breadcrumb
 * @param {string} path
 * @return {string} customPath
 */
const customBredCrumbPath = path => {
  path = path.replace('/', '')
  switch (path) {
    case 'brand':
      return '/brands'
    default:
      return `/${path}`
  }
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
          path: customBredCrumbPath(acc.path),
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

  // //don't save value for product detail page
  // if( !location.pathname.includes("/product/") ) {
  //   //set current location as last location on storage
  //   localStorage.setItem("lastLocation", JSON.stringify(crumbs) );
  // }

  // crumbs.pop()
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
