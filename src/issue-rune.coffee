import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"
import { Expression } from "@dashkite/enchant/expression"

register "issue rune", ( { secret, authorization }, context ) ->
  base64 hash "base36", Runes.issue {
    secret: ( await getSecret secret )
    authorization: Expression.apply authorization, context
  }