import { useTranslation } from 'react-i18next'

/**
 * Primary UI component for user interaction
 */
const Button = ({ disabled, classList = 'btn btn-primary btn-block', isLoading = false, children, label, onClick }) => {
  const { t } = useTranslation()
  return (
    <button type="button" className={classList} onClick={onClick}>
      {children && children}
      {!children && t(label)}
      {isLoading && (
        <>
          <span> </span>
          <i className="far fa fa-spinner fa fa-spin font-size-lg mr-2" />
        </>
      )}
    </button>
  )
}
export { Button }
