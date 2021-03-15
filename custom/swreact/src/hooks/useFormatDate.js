const useFormatDate = ({ format = '' }) => {
  const formateDate = dateString => {
    var dateToFormat = new Date(dateString)
    return dateToFormat.toLocaleString()
  }
  return [formateDate]
}
export default useFormatDate
