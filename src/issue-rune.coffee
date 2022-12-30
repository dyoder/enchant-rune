import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"
import { Expression } from "@dashkite/enchant/expression"
import { json64 } from "./helpers"

register "issue rune", ({ secret, authorization }, context ) ->
  json64 await Runes.issue {
    secret: ( await getSecret secret )
    authorization: Expression.apply authorization, context
  }