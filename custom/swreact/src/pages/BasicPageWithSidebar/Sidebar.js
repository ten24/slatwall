import React from 'react'
import { useHistory, useLocation } from 'react-router-dom'
import { useSelector } from 'react-redux'

const Sidebar = () => {
  let history = useHistory()
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0]
  // Get All contnent of type sidebar
  let allSidebar = useSelector(state => {
    return Object.keys(state.content)
      .map(key => {
        if (state.content[key] && state.content[key].settings && state.content[key].settings.contentTemplateFile === 'sidebar.cfm') {
          state.content[key].key = key
          return state.content[key]
        }
        return null
      })
      .filter(item => {
        return item
      })
      .map(content => {
        return content.key.includes(`${path}/`) ? content : null
      })
      .filter(item => {
        return item
      })
  }, [])
  return (
    <aside className="col-lg-4 pt-4 pt-lg-0">
      <div className="cz-sidebar-static rounded-lg box-shadow-lg p-4 mb-5">
        {allSidebar &&
          allSidebar
            .sort((a, b) => {
              return a.sortOrder - b.sortOrder
            })
            .map((item, index) => {
              return (
                <div key={index}>
                  <div
                    onClick={event => {
                      if (event.target.getAttribute('href')) {
                        event.preventDefault()
                        if (event.target.getAttribute('href').includes('http')) {
                          window.location.href = event.target.getAttribute('href')
                        } else {
                          history.push(event.target.getAttribute('href'))
                        }
                      }
                    }}
                    dangerouslySetInnerHTML={{
                      __html: item.customBody,
                    }}
                  />
                  {item.customSummary.length && <iframe title="location Map" src={item.customSummary.replace(/(<([^>]+)>)/gi, '')} width="400" height="250" frameBorder="0" style={{ border: 0 }} aria-hidden="false" tabIndex="0" />}
                </div>
              )
            })}
      </div>
    </aside>
  )
}
export default Sidebar
