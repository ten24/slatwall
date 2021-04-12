import { useState, useEffect } from 'react'
import { useHistory } from 'react-router-dom'
export const useRedirect = ({ shouldRedirect = false, location = '/', time = 2000 }) => {
  const history = useHistory()
  const [redirect, setRedirect] = useState(shouldRedirect)

  useEffect(() => {
    if (redirect) {
      const timer = setTimeout(() => {
        history.push(location)
      }, time)
      return () => clearTimeout(timer)
    }
  }, [history, redirect, location, time])
  return [redirect, setRedirect]
}
export default useRedirect

export const usePush = defaults => {
  const history = useHistory()
  const [redirect, setRedirect] = useState({ shouldRedirect: false, location: '/', search: '', time: 2000, ...defaults })

  useEffect(() => {
    if (redirect.shouldRedirect) {
      const timer = setTimeout(() => {
        history.push({
          pathname: redirect.location,
          search: redirect.search,
        })
      }, redirect.time)
      return () => clearTimeout(timer)
    }
  }, [history, redirect])
  return [redirect, setRedirect]
}
