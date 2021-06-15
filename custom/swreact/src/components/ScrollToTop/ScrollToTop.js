import { useEffect } from 'react'
import { useHistory } from 'react-router'

export default function ScrollToTop() {
  const history = useHistory()
  useEffect(() => {
    const unload = history.listen(location => {
      if (!location.pathname.includes('/product/')) {
        window.scrollTo({
          top: 0,
          //   behavior: 'smooth',
        })
      }
    })
    return () => {
      unload()
    }
  }, [history])

  return null
}
