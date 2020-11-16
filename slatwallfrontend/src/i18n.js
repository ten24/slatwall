import i18n from "i18next"
import { initReactI18next } from "react-i18next"
import resources from "./locales/index"

i18n
  .use(initReactI18next)

  .init({
    resources,
    lng: window.localStorage.getItem("i18nextLng"),
    supportedLngs: ["en", "fr"],
    // Allows "en-US" and "en-UK" to be implcitly supported when "en"
    // is supported
    nonExplicitSupportedLngs: true,
    fallbackLng: "en",
    debug: true,
    interpolation: {
      escapeValue: false, // not needed for react as it escapes by default
    },
  })

export default i18n
