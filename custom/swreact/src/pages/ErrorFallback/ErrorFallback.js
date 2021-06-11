import { useTranslation } from 'react-i18next'
import { useSelector } from 'react-redux'
import { useHistory } from 'react-router'
import { Button } from '../../components'

const ErrorFallback = ({ error, resetErrorBoundary }) => {
  const history = useHistory()
  const { t } = useTranslation()
  const contentStore = useSelector(state => state.content['error']) || {}

  return (
    <div
      className="container py-5 mb-lg-3"
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
    >
      <div className="row justify-content-center pt-lg-4 text-center">
        <div className="col-lg-5 col-md-7 col-sm-9">
          <h1 className="display-404">{contentStore.title}</h1>
          <div
            dangerouslySetInnerHTML={{
              __html: contentStore?.customSummary || t('frontend.core.error.summary'),
            }}
          ></div>
        </div>
      </div>

      <div className="row justify-content-center">
        <div className="col-xl-8 col-lg-10">
          <div role="alert">
            <p
              dangerouslySetInnerHTML={{
                __html: contentStore?.customBody || t('frontend.core.error.body'),
              }}
            />
          </div>
        </div>
      </div>
      {error?.message && (
        <div className="row justify-content-center">
          <div className="col-xl-8 col-lg-10">
            <div role="alert">
              <p>
                <pre>{error?.message}</pre>
              </p>
              <Button onClick={resetErrorBoundary}>{t('frontend.core.error.reload')}</Button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default ErrorFallback
