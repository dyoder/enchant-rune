import { convert } from "@dashkite/bake"
import { confidential } from "panda-confidential"

Confidential = confidential()
{ Message, hash, convert } = Confidential

hash = ( encoding, value ) ->
  message = Message.from encoding, value
  hash message
    .to "base64"

base64 = ( value ) ->  convert from: "utf8", to: "base64", value

export { hash, base64 }