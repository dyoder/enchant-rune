import { convert } from "@dashkite/bake"

json64 = ( value ) -> 
  convert from: "utf8", to: "base64",
    JSON.stringify value

export { json64 }