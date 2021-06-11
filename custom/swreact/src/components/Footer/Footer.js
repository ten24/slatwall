import React from 'react'
import { useSelector } from 'react-redux'
import { ActionBanner, SignUpForm } from '..'
import styles from './Footer.module.css'
import { useHistory } from 'react-router-dom'
import { useTranslation } from 'react-i18next'

function Footer() {
  const { t } = useTranslation()
  let history = useHistory()
  const formLink = useSelector(state => state.configuration.footer.formLink)
  const contentStore = useSelector(state => {
    return Object.keys(state.content)
      .map(key => {
        if (state.content[key] && state.content[key].settings) {
          state.content[key].key = key
          return state.content[key]
        }
        return null
      })
      .filter(item => {
        return item
      })
      .map(content => {
        return content.key.includes(`footer`) ? content : null
      })
      .filter(item => {
        return item
      })
      .sort((a, b) => {
        return a.sortOrder - b.sortOrder
      })
  }, {})

  let getInTouch,
    stayInformed,
    siteLinks = ''
  if (contentStore.length) {
    getInTouch = contentStore.map(content => (content.key === 'footer/get-in-touch' ? content : null)).filter(item => item)
    getInTouch = getInTouch.length ? getInTouch[0].customBody : ''

    stayInformed = contentStore.map(content => (content.key === 'footer/stay-informed' ? content : null)).filter(item => item)
    stayInformed = stayInformed.length ? stayInformed[0].customBody : ''

    siteLinks = contentStore.map(content => (content.key === 'footer/site-links' ? content : null)).filter(item => item)
    siteLinks = siteLinks.length ? siteLinks[0].customBody : ''
  }

  return (
    <footer className="pt-5">
      <ActionBanner />
      <div className={`${styles.bottomBar} p-5`}>
        <div className="container">
          <div className="row pt-2">
            <div className="col-md-2 col-sm-6">
              <div
                className="widget widget-links pb-2 mb-4"
                onClick={event => {
                  event.preventDefault()
                  if (event.target.getAttribute('href')) {
                    history.push(event.target.getAttribute('href'))
                  }
                }}
                dangerouslySetInnerHTML={{ __html: siteLinks }}
              />
            </div>
            <div className="col-md-4 col-sm-6">
              <div className="widget widget-links pb-2 mb-4" dangerouslySetInnerHTML={{ __html: getInTouch }} />
            </div>
            <div className="col-md-6">
              <div className="widget pb-2 mb-4">
                <div className={`${styles.stayInformed}`} dangerouslySetInnerHTML={{ __html: stayInformed }} />
                <SignUpForm url={formLink} />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className={`${styles.bgFooter} p-4`}>
        <div className="container">
          <div className="text-center font-size-xs">{`@${new Date().getFullYear()} ${t('frontend.copywrite')}`}</div>
        </div>
      </div>
    </footer>
  )
}

export default Footer
