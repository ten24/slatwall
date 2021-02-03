import { useState, useEffect } from 'react'
import { useHistory } from 'react-router-dom'
const useRedirect = ({ shouldRedirect = false, location = '/', time = 2000 }) => {
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
