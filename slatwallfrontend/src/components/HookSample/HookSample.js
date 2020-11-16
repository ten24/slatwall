import React from "react"
import { useTranslation } from "react-i18next"
import i18next from "i18next"

const HookSample = props => {
  const { t } = useTranslation()

  console.log(props)
  return (
    <div>
      <h1>{t("Welcome to React")}</h1>
      <p>{t("description.part1")}</p>
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          i18next.changeLanguage("en")
          window.localStorage.setItem("i18nextLng", "en")
        }}
      >
        Set English
      </button>
      <button
        type="button"
        className="btn btn-outline-primary"
        onClick={() => {
          i18next.changeLanguage("fr")
          window.localStorage.setItem("i18nextLng", "fr")
        }}
      >
        Set French
      </button>
    </div>
  )
}

export default HookSample
