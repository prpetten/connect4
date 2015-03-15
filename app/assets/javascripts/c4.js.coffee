class ConnectFour
  constructor: (@container) ->
    @drop                     = @container.find('.drop-row')
    @gameBoard                = @container.find('.gameBoard')
    @winner                   = @container.find('.winner')
    @columns                  = (new ConnectColumn($("#column-#{num}")) for num in [1..7])
    @gameOver                 = false
    @drop.on 'click', 'a.drop-spot.position', @addPiece

  addPiece: (event) =>
    event.preventDefault()
    dropSpot = $(event.currentTarget)
    columnNum = dropSpot.data('column-num')
    dropColumn = @columns[columnNum - 1]
    turn = @whoseTurn()
    dropColumn.dropPiece(turn)
    @didTheyWin(turn)
    if @gameover
      @displayWinner(turn)
    else
      @switchColors()

  whoseTurn: ->
    if $('.drop-row').hasClass('red-turn')
      'red'
    else
      'black'

  didTheyWin: (color) ->
    matrix = (column.colors() for column in @columns)
    @testPaths(matrix, color)
    @testPaths(@transpose(matrix), color)
    @testPaths(@diagonals(matrix), color)

  switchColors: ->
    $('.drop-row').toggleClass('red-turn').toggleClass('black-turn')

  testPaths: (pathList, color) ->
    @winPath(path, color) for path in pathList

  winPath: (path, color) ->
    start =  path.toString().indexOf "#{color},#{color},#{color},#{color}"
    if start != -1
      @weHaveAWinner(color)

  weHaveAWinner: (color) ->
    @gameover = true

  displayWinner: (color) ->
    @winner.removeClass('none')
    @winner.addClass(color)
    @winner.append("#{color} wins!")

  transpose: (matrix) ->
    Object.keys(matrix[0]).map (column) ->
      matrix.map (row) ->
        row[column]

  diagonals: (matrix)->
    [[matrix[0][2],matrix[1][3],matrix[2][4],matrix[3][5]],
     [matrix[0][1],matrix[1][2],matrix[2][3],matrix[3][4],matrix[4][5]],
     [matrix[0][0],matrix[1][1],matrix[2][2],matrix[3][3],matrix[4][4],matrix[5][5]],
     [matrix[1][0],matrix[2][1],matrix[3][2],matrix[4][3],matrix[5][4],matrix[6][5]],
     [matrix[2][0],matrix[3][1],matrix[4][2],matrix[5][3],matrix[6][4]],
     [matrix[3][0],matrix[4][1],matrix[5][2],matrix[6][3]],
     [matrix[0][3],matrix[1][2],matrix[2][1],matrix[3][0]],
     [matrix[0][4],matrix[1][3],matrix[2][2],matrix[3][1],matrix[4][0]],
     [matrix[0][5],matrix[1][4],matrix[2][3],matrix[3][2],matrix[4][1],matrix[5][0]],
     [matrix[1][5],matrix[2][4],matrix[3][3],matrix[4][2],matrix[5][1],matrix[6][0]],
     [matrix[2][5],matrix[3][4],matrix[4][3],matrix[5][2],matrix[6][1]],
     [matrix[3][5],matrix[4][4],matrix[5][3],matrix[6][2]]]

class ConnectColumn
  constructor: (@column) ->
    @spots = (new ConnectSpot($("##{@column.data('column-num')}-#{spotNum}")) for spotNum in [1..6])

  dropPiece: (color) =>
    emptySpots = (spot for spot in @spots when spot.color is 'white')
    spot = emptySpots[0]
    spot.setColor(color)

  colors: =>
    spot.color for spot in @spots

class ConnectSpot
  constructor: (@spot) ->
    @color = 'white'

  setColor: (color) =>
    @color = color
    @spot.addClass(color)

$ ->
  new ConnectFour($('.blast-radius'))
