import { Layout } from '../../components'
import BasicPageWithSidebar from '../BasicPageWithSidebar/BasicPageWithSidebar'
import ContactForm from './ContactForm'

const Contact = () => {
  return (
    <Layout>
      <BasicPageWithSidebar>
        <ContactForm />
      </BasicPageWithSidebar>
    </Layout>
  )
}

export default Contact
