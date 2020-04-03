<template>
  <div class="text-center">
    <v-dialog
      v-model="visible"
      width="500"
    >
      <v-card>
        <v-card-title
          class="headline grey lighten-2"
          primary-title
        >
          Trusted OAuth2 Providers
        </v-card-title>

        <v-card-text>
          <v-icon v-for='(provider, i) in providers' :key='i'>
            {{icon[provider]}}
          </v-icon>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script lang='coffee'>
import {mdiGoogle, mdiGithub} from '@mdi/js'
{providers} = require('./oauth2.coffee').default
 
export default
  props:
    dialog:
      type: Boolean
    providers: 
      type: Array
      default: ->
        Object.keys providers
  data: ->
    icon:
      google: mdiGoogle
      github: mdiGithub
  computed:
    visible:
      get: ->
        @dialog
      set: (value) ->
        @$emit 'update:dialog', value
</script>
