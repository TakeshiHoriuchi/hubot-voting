path = require('path')
Robot = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage
should = require('chai').should()

describe 'hubot-voting', ->
  robot = null
  user = null
  adapter = null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'testhubot')
    robot.adapter.on 'connected', ->
      robot.loadFile path.resolve('.', 'src', 'scripts'), 'voting.coffee'
      user = robot.brain.userForId '1', {
        name: 'testuser'
        room: '#testroom'
      }
      adapter = robot.adapter
      done()
    robot.run()

  afterEach -> robot.shutdown()

  msg = 'testhubot start vote first item, second item, third item'
  describe msg, ->
    it 'should send message', (done) ->
      adapter.on 'send', (envelope, strs) ->
        try
          envelope.user.room.should.equal '#testroom'
          if strs[0] == 'Vote started'
            strs[0].should.equal 'Vote started'
          else
            strs[0].should.include 'first item'
            done()
        catch err
          done err
      adapter.receive new TextMessage(user, msg)

  describe 'start vote from script', ->
    it 'should send message', (done) ->
      adapter.on 'send', (envelope, strs) ->
        try
          envelope.room.should.equal '#testroom'
          if strs[0] == 'Vote started'
            strs[0].should.equal 'Vote started'
          else
            strs[0].should.include 'first item'
            done()
        catch err
          done err
      robot.startVote '#testroom', ['first item', 'second item', 'third item']


  describe 'end vote from script', ->
    beforeEach (done) ->
      adapter.on 'send', (envelope, strs) ->
        try
          if strs[0].indexOf('0: first item') >= 0
            adapter.receive new TextMessage(
              user,
              'testhubot vote 0'
            )
          else if strs[0].indexOf('voted for') >= 0
            done()
        catch err
          done err
      robot.startVote '#testroom', ['first item', 'second item', 'third item']

    it 'should send message', (done) ->
      adapter.on 'send', (envelope, strs) ->
        try
          console.log strs[0]
          envelope.room.should.equal '#testroom'
          strs[0].should.include 'The results are'
          strs[0].should.include 'first item: 1'
          done()
        catch err
          done err
      robot.endVote '#testroom'
