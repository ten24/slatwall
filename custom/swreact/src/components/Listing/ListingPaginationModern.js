import { useTranslation } from 'react-i18next'

const ListingPaginationModern = ({ currentPage = 1, setPage }) => {
  const { t } = useTranslation()
  currentPage = parseInt(currentPage)

  return (
    <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
      <ul className="mx-auto pagination">
        {currentPage > 1 && (
          <li className="page-item">
            <div
              className="page-link"
              href=""
              aria-label="Previous"
              onClick={evt => {
                evt.preventDefault()
                setPage(currentPage - 1)
              }}
            >
              <span aria-hidden="true">&laquo;</span>
              <span className="sr-only">{t('frontend.pagination.previous')}</span>
            </div>
          </li>
        )}
        <li class="page-item">
          <span className="">{currentPage}</span>
        </li>

        <li className="page-item">
          <div
            className="page-link"
            aria-label="Next"
            onClick={evt => {
              evt.preventDefault()
              setPage(currentPage + 1)
            }}
          >
            <span aria-hidden="true">&raquo;</span>
            <span className="sr-only">{t('frontend.pagination.next')}</span>
          </div>
        </li>
      </ul>
    </nav>
  )
}

export { ListingPaginationModern }
