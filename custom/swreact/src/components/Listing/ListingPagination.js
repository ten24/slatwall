import { useTranslation } from 'react-i18next'

const LEFT_PAGE = 'LEFT'
const RIGHT_PAGE = 'RIGHT'

// Built from here: https://www.digitalocean.com/community/tutorials/how-to-build-custom-pagination-with-react

/**
 * Helper method for creating a range of numbers
 * range(1, 5) => [1, 2, 3, 4, 5]
 */
const range = (from, to, step = 1) => {
  let i = from
  const range = []

  while (i <= to) {
    range.push(i)
    i += step
  }

  return range
}

const calculatePageNumbers = (currentPage, pageNeighbours, totalPages) => {
  /**
   * totalNumbers: the total page numbers to show on the control
   * totalBlocks: totalNumbers + 2 to cover for the left(<) and right(>) controls
   */
  const totalNumbers = pageNeighbours * 2 + 3
  const totalBlocks = totalNumbers + 2

  if (totalPages > totalBlocks) {
    const startPage = Math.max(2, currentPage - pageNeighbours)
    const endPage = Math.min(totalPages - 1, currentPage + pageNeighbours)
    let pages = range(startPage, endPage)

    /**
     * hasLeftSpill: has hidden pages to the left
     * hasRightSpill: has hidden pages to the right
     * spillOffset: number of hidden pages either to the left or to the right
     */
    const hasLeftSpill = startPage > 2
    const hasRightSpill = totalPages - endPage > 1
    const spillOffset = totalNumbers - (pages.length + 1)

    switch (true) {
      // handle: (1) < {5 6} [7] {8 9} (10)
      case hasLeftSpill && !hasRightSpill: {
        const extraPages = range(startPage - spillOffset, startPage - 1)
        pages = [LEFT_PAGE, ...extraPages, ...pages]
        break
      }

      // handle: (1) {2 3} [4] {5 6} > (10)
      case !hasLeftSpill && hasRightSpill: {
        const extraPages = range(endPage + 1, endPage + spillOffset)
        pages = [...pages, ...extraPages, RIGHT_PAGE]
        break
      }

      // handle: (1) < {4 5} [6] {7 8} > (10)
      case hasLeftSpill && hasRightSpill:
      default: {
        pages = [LEFT_PAGE, ...pages, RIGHT_PAGE]
        break
      }
    }

    return [1, ...pages, totalPages]
  }
  return range(1, totalPages)
}

const ListingPagination = ({ recordsCount, pageNeighbours = 2, currentPage, totalPages = 1, setPage }) => {
  const { t } = useTranslation()
  recordsCount = typeof recordsCount === 'string' || recordsCount instanceof String ? parseInt(recordsCount) : recordsCount
  currentPage = typeof currentPage === 'string' || currentPage instanceof String ? parseInt(currentPage) : currentPage
  totalPages = typeof totalPages === 'string' || totalPages instanceof String ? parseInt(totalPages) : totalPages

  const gotoPage = pageTo => {
    const newPage = Math.max(0, Math.min(pageTo, totalPages))
    setPage(newPage)
  }

  const pages = calculatePageNumbers(currentPage, pageNeighbours, totalPages)
  if (!recordsCount || recordsCount.length === 0 || totalPages === 1) return null
  return (
    <nav className="d-flex justify-content-between pt-2" aria-label="Page navigation">
      <ul className="mx-auto pagination">
        {pages.map((page, index) => {
          if (page === LEFT_PAGE)
            return (
              <li key={index} className="page-item">
                <div
                  className="page-link"
                  href=""
                  aria-label="Previous"
                  onClick={evt => {
                    evt.preventDefault()
                    gotoPage(currentPage - pageNeighbours * 2 - 1)
                  }}
                >
                  <span aria-hidden="true">&laquo;</span>
                  <span className="sr-only">{t('frontend.pagination.previous')}</span>
                </div>
              </li>
            )

          if (page === RIGHT_PAGE)
            return (
              <li key={index} className="page-item">
                <div
                  className="page-link"
                  aria-label="Next"
                  onClick={evt => {
                    evt.preventDefault()
                    gotoPage(currentPage + pageNeighbours * 2 + 1)
                  }}
                >
                  <span aria-hidden="true">&raquo;</span>
                  <span className="sr-only">{t('frontend.pagination.next')}</span>
                </div>
              </li>
            )

          return (
            <li key={index} className={`page-item${currentPage === page ? ' active' : ''}`}>
              <div
                className="page-link"
                onClick={evt => {
                  evt.preventDefault()
                  const newPage = Math.max(0, Math.min(page, totalPages))
                  setPage(newPage)
                }}
              >
                {page}
              </div>
            </li>
          )
        })}
      </ul>
    </nav>
  )
}

export { ListingPagination }
