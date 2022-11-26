import * as Runes from "@dashkite/runes"
import { getSecret } from "@dashkite/dolores/secrets"
import { register } from "@dashkite/enchant/actions"

register "issue rune", ( { secret, authorization }) ->
  Runes.issue {
    secret: ( await getSecret secret )
    authorization 
  }