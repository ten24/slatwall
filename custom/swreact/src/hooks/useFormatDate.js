import { useSelector } from 'react-redux'
import dayjs from 'dayjs'
// import en from 'dayjs/locale/en'
//https://day.js.org/docs/en/display/format
const useFormatDate = () => {
  const dateFormat = useSelector(state => state.configuration.theme.dateFormat)
  const formateDate = dateString => dayjs(dateString).format(dateFormat)
  return [formateDate]
}
const useFormatDateTime = () => {
  const { dateFormat, timeFormat } = useSelector(state => state.configuration.theme)
  const formateDate = dateTimeString => dayjs(dateTimeString).format(`${dateFormat} ${timeFormat}`)
  return [formateDate]
}
const useFormatTime = () => {
  const timeFormat = useSelector(state => state.configuration.theme.timeFormat)
  const formateDate = timeString => dayjs(timeString).format(timeFormat)
  return [formateDate]
}
export { useFormatDate, useFormatDateTime, useFormatTime }
