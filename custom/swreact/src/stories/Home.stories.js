import React from 'react'
import { Footer, Header } from '../components'
import { Home } from '../pages'
import * as FooterStories from './Footer.stories'
import * as HeaderStories from './Header.stories'
import * as HomeBanner from './HomeBanner.stories'
import * as HomeBrand from './HomeBrand.stories'
import * as HomeDetails from './HomeDetails.stories'

export default {
  title: 'StoneAndBerg/Home',
  component: Home,
  argTypes: {},
}

const Template = args => {
  return (
    <>
      <Header {...args} />
      <Home {...args} />
      <Footer {...args} />
    </>
  )
}
export const Primary = Template.bind({})
Primary.args = {
  ...HomeBanner.Primary.args,
  ...HomeBrand.Primary.args,
  ...HomeDetails.Primary.args,
  ...FooterStories.Primary.args,
  ...HeaderStories.Primary.args,
}
