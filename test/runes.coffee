import { getSecret } from "@dashkite/dolores/secrets"
import * as Runes from "@dashkite/runes"
import { expand } from "@dashkite/polaris"

import _authorization from "./authorization"

dictionary = undefined
authorization = expand _authorization, {}


makeRune = ( secret, name ) ->
  dictionary ?= 
    valid: Runes.issue { authorization, secret }
  dictionary[ name ]

export default makeRune
