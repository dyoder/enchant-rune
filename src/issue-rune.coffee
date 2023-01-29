import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"
import { Expression } from "@dashkite/enchant/expression"
import { Authorization } from "@dashkite/http-headers"

register "issue rune", ({ secret, authorization }, context ) ->
  credential = await Runes.issue {
    secret: ( await getSecret secret )
    authorization: Expression.apply authorization, context
  }
  Authorization.format
    scheme: "rune"
    parameters: credential