import { getSecret } from "@dashkite/dolores/secrets"
import * as Runes from "@dashkite/runes"

import authorization from "./authorization"

dictionary = undefined

makeRune = ( secret, name ) ->
  dictionary ?= 
    valid: Runes.issue { authorization, secret }
  dictionary[ name ]

export default makeRune
