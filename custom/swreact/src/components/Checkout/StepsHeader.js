import { useHistory, useLocation } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { checkOutSteps } from './steps'

// https://www.digitalocean.com/community/tutorials/how-to-create-multistep-forms-with-react-and-semantic-ui
// https://github.com/srdjan/react-multistep/blob/master/react-multistep.js
// https://www.geeksforgeeks.org/how-to-create-multi-step-progress-bar-using-bootstrap/

//
const getCurrentStep = path => {
  return (checkOutSteps.filter(step => {
    return step.key === path
  }) || [checkOutSteps[1]])[0]
}

const StepsHeader = () => {
  const { t } = useTranslation()
  const loc = useLocation()
  let history = useHistory()

  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const current = getCurrentStep(path)
  return (
    <div className="steps steps-dark pt-2 pb-3 mb-5">
      {checkOutSteps.map(step => {
        let progressSate = ''
        if (step.progress < current.progress) {
          progressSate = 'active'
        } else if (step.progress === current.progress) {
          progressSate = 'active current'
        }
        return (
          <a
            className={`step-item ${progressSate}`}
            href={`/${step.name}`}
            key={step.progress}
            onClick={e => {
              e.preventDefault()
              history.push(step.link)
            }}
          >
            <div className="step-progress">
              <span className="step-count">{step.progress}</span>
            </div>
            <div className="step-label">
              <i className={`fal fa-${step.icon}`}></i>
              {t(step.name)}
            </div>
          </a>
        )
      })}
    </div>
  )
}

export { StepsHeader }
