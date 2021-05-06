import React from 'react'
import { useHistory, useLocation } from 'react-router-dom'
import { useSelector } from 'react-redux'

const ActionBanner = props => {
  let history = useHistory()
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0]

  // Get All contnent of type Banner
  const allBanners = useSelector(state => {
    return Object.keys(state.content)
      .map(key => {
        if (state.content[key] && state.content[key].settings && state.content[key].settings.contentTemplateFile === 'banner.cfm') {
          state.content[key].key = key
          return state.content[key]
        }
        return null
      })
      .filter(item => {
        return item
      })
  }, [])

  let banner = { customBody: '' }

  if (allBanners.length === 1) {
    // Only one banner so lets use that
    banner = allBanners[0]
  } else if (allBanners.length > 1) {
    // lets try and see if we have a banner prefixed with this path
    const actionBannersForPath = allBanners.filter(banner => {
      return banner.key.includes(`${path}/`)
    })
    if (actionBannersForPath.length === 0 || actionBannersForPath.length > 1) {
      // no  banner for this path so lets check footer
      const actionBannersForFooter = allBanners.filter(banner => {
        return banner.key.includes(`footer/`)
      })
      // set the footer banner or the first banner in the global list
      banner = actionBannersForFooter.length === 0 || actionBannersForFooter.length > 1 ? allBanners[0] : actionBannersForFooter[0]
    } else {
      // set the banner for path
      banner = actionBannersForPath[0]
    }
  }

  return (
    <div className="bg-primary p-5">
      <div className="container">
        <div className="row">
          <div className="col-0 col-md-2"></div>
          <div
            className="col-md-8 text-center"
            onClick={event => {
              event.preventDefault()
              if (event.target.getAttribute('href')) {
                if (event.target.getAttribute('href').includes('http')) {
                  window.location.href = event.target.getAttribute('href')
                } else {
                  history.push(event.target.getAttribute('href'))
                }
              }
            }}
            dangerouslySetInnerHTML={{ __html: banner.customBody }}
          />
          <div className="col-0 col-md-2"></div>
        </div>
      </div>
    </div>
  )
}

export default ActionBanner
