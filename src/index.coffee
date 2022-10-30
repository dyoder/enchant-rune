import { register } from "@dashkite/enchant/authorizers"
import * as Runes from "@dashkite/runes"
import messages from "./messages"

message = do ( _messages = null ) ->
  _messages = Messages.create()
  _messages.add messages
  ( code, context ) -> _messages.message code, context

register "rune", ({ parameters, credential }, { request }) ->
  { nonce } = parameters
  secret = await getSecret "guardian"
  if Runes.verify { rune: credential, nonce, secret }
    [ authorization ] = Runes.decode credential
    if ( await Runes.match { request, authorization })?
      valid: true
    else
      valid: false
      reason: message "request disallowed", { request }
  else
    valid: false
    reason: message "verification failed", { request }
