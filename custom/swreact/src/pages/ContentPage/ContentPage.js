import { useSelector } from 'react-redux'
import { Layout } from '../../components'
import { createElement } from 'react'

import { useLocation } from 'react-router'
import NotFound from '../NotFound/NotFound'
import BasicPageWithSidebar from '../BasicPageWithSidebar/BasicPageWithSidebar'
import BasicPage from '../BasicPage/BasicPage'

const pageComponents = {
  BasicPageWithSidebar,
  // ProductListingContent,
  BasicPage,
  NotFound,
}

const ContentPage = () => {
  let loc = useLocation()
  const path = loc.pathname.split('/').reverse()[0].toLowerCase()
  const content = useSelector(state => state.content)
  let component = 'NotFound'

  if (!content.isFetching && content[path]) {
    component = content[path].settings.contentTemplateFile.replace('.cfm', '')
  }

  return <Layout>{!content.isFetching && createElement(pageComponents[component])}</Layout>
}

export default ContentPage
