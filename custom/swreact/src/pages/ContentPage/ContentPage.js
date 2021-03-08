import { useSelector, useDispatch } from 'react-redux'
import { Layout } from '../../components'
import React, { useState } from 'react'

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
    component = content[path].setting.contentTemplateFile.replace('.cfm', '')
  }
  console.log('!content.isFetching', !content.isFetching)
  console.log('component', component)

  return <Layout>{!content.isFetching && React.createElement(pageComponents[component])}</Layout>
}

export default ContentPage
