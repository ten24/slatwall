import React, { useEffect, useState } from 'react'
import { useSelector } from 'react-redux'
import { useLocation } from 'react-router-dom'
import axios from 'axios'
import { toast } from 'react-toastify'
import { sdkURL } from '../../services/SlatwalApiService'
import { useTranslation } from 'react-i18next'

const ContactForm = () => {
  const [content, setContent] = useState({ form: null, isLoaded: false, submitted: false })
  const { t, i18n } = useTranslation()
  let loc = useLocation()
  const siteCode = useSelector(state => state.preload.site.siteCode)
  const path = loc.pathname.split('/').reverse()[0]

  let formsByPath = useSelector(state => {
    return Object.keys(state.content)
      .map(key => {
        if (state.content[key] && state.content[key].setting && state.content[key].setting.contentTemplateFile === 'form.cfm') {
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

  useEffect(() => {
    let didCancel = false
    if (!content.isLoaded && formsByPath.length) {
      if (formsByPath.length > 1) {
        formsByPath = formsByPath.sort((a, b) => {
          return a.sortOrder - b.sortOrder
        })
      }
      formsByPath = formsByPath[0]
      axios({
        method: 'POST',
        withCredentials: true,

        url: `${sdkURL}api/scope/getSlatwallContent`,
        headers: {
          'Content-Type': 'application/json',
        },
        data: {
          formCode: 'contact-us',
          siteCode: siteCode,
        },
      }).then(response => {
        if (didCancel) {
          setContent({ form: response.data.content.form, isLoaded: true })
        }
      })
    }
    return () => {
      didCancel = true
    }
  }, [formsByPath, content, setContent, siteCode])

  const encodeForm = data => {
    return Object.keys(data)
      .map(key => encodeURIComponent(key) + '=' + encodeURIComponent(data[key]))
      .join('&')
  }

  const submitForm = form => {
    const formData = new FormData(form)
    var bodyFormData = {}
    for (var pair of formData.entries()) {
      bodyFormData[pair[0]] = pair[1]
    }
    axios({
      method: 'POST',
      withCredentials: true, // default
      url: `${sdkURL}api/scope/addFormResponse`,
      data: encodeForm(bodyFormData),
      headers: {
        'Content-Type': `application/x-www-form-urlencoded`,
      },
    })
      .then(response => {
        toast.success(t('frontend.contact.success'))
        setContent({ ...content, submitted: true })
      })
      .catch(error => {
        toast.error(error.message)
      })
  }

  return (
    <>
      {content.isLoaded && content.form && (
        <div className="contactForm mt-4">
          <div
            onClick={event => {
              if (event.target.value === 'Submit') {
                event.preventDefault()
                submitForm(event.target.closest('form'))
              }
            }}
            dangerouslySetInnerHTML={{
              __html: content.form.markup,
            }}
          />
        </div>
      )}
    </>
  )
}
export default ContactForm
