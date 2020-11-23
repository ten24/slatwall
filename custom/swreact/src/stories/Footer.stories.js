import React from 'react'
import { Footer } from '../components'

export default {
  title: 'StoneAndBerg/Footer',
  component: Footer,
  argTypes: {
    backgroundColor: { control: 'color' },
  },
}

const Template = args => <Footer {...args} />
export const Primary = Template.bind({})
Primary.args = {
  isContact: 'true',
  contactUs:
    '<h4>Can&#39;t find what you are looking for?</h4> <p>Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero&#39;s De Finibus Bonorum et Malorum for use in a type specimen book.</p> <p><a href="##" class="btn">Contact Us</a></p>',
  getInTouch:
    '<h3>Get in Touch</h3> <ul> <li>(508) 753-3551</li> <li>Toll Free: (800)535-5625</li> <li><a href="http://emailto:orders@stoneandberg.com">orders@stonandberg.com</a></li> <li>Monday - Friday: 8AM - 5PM</li> </ul> <p>&nbsp;</p> <ul> <li>239 Mill Street</li> <li>Worchester, MA 01602</li> </ul>',
  siteLinks:
    '<h3>Site Links</h3> <ul> <li><a href="##">Home</a></li> <li><a href="##">Products</a></li> <li><a href="##">About</a></li> <li><a href="##">Resources</a></li> <li><a href="##">Contact</a></li> <li><a href="##">My Account</a></li> </ul>',
  stayInformed:
    '<h3>Stay Informed</h3> <p>Sign up to receive any updates on pricing, specials, industry events and lcoal training at our facility!</p>',
  copywriteDate: '2020',
}
