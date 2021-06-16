import { Footer, Header, SEO } from '../index'

const Loading = () => {
  return (
    <>
      <SEO />
      <Header />
      <div style={{ minHeight: '800px' }}></div>
      <Footer />
    </>
  )
}

export { Loading }
