import {Component} from 'react'
import h from 'react-hyperscript'

import {BrowserRouter as Router, Route, Link} from 'react-router-dom'

import {APIContext} from './api'
import {UIMain} from './ui-main'
import {Role} from './enum'
import {LoginForm} from './login-form'

class App extends Component
  @contextType: APIContext
  constructor: (props)->
    super props
    @state = {
      people: null
      person: null
      role: null
    }

  allRequiredOptionsAreSet: =>
    console.log @state
    return false unless @state.person?
    return false unless @state.role?
    return true

  renderUI: ->
    {person, people, role} = @state
    if @allRequiredOptionsAreSet()
      id = person.person_id
      console.log person
      extraSaveData = null
      nextImageEndpoint = "/image/next"
      allowSaveWithoutChanges = false
      editingEnabled = true
      if role == Role.TAG
        extraSaveData = {tagger: id}
        subtitleText = "Tag"
      else if role == Role.VALIDATE
        extraSaveData = {validator: id}
        nextImageEndpoint = "/image/validate"
        # Tags can be validated even when unchanged
        allowSaveWithoutChanges = true
        subtitleText = "Validate"
      else if role == Role.VIEW
        editingEnabled = false
        nextImageEndpoint = "/image/validate"
        subtitleText = "View"

      return h UIMain, {
        extraSaveData
        nextImageEndpoint
        allowSaveWithoutChanges
        editingEnabled
        subtitleText
        @props...
      }
    else if people?
      return h LoginForm, {
        person, people,
        setPerson: @setPerson
        setRole: @setRole
      }
    return null

  render: ->
    h 'div.app-main', [
      @renderUI()
    ]

  setupPeople: (d)=>
    @setState {people: d}

  setPerson: (item)=>
    {tagger, validator} = item
    tagger = tagger == 1
    validator = validator == 1
    role = null
    if tagger == 1 and validator != 1
      role = Role.TAG
    @setState {person: item, role}

  setRole: (role)=>
    @setState {role}

  componentDidMount: ->
    @context.get("/people/all")
      .then @setupPeople

export {App}
