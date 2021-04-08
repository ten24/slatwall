import { useEffect } from 'react'
import { useHistory } from 'react-router'

export default function ScrollToTop() {
  const history = useHistory()
  useEffect(() => {
    window.scrollTo({
      top: 0,
      //   behavior: 'smooth',
    })
    history.listen(location => {
      window.scrollTo({
        top: 0,
        //   behavior: 'smooth',
      })
    })
  }, [history])

  return null
}
