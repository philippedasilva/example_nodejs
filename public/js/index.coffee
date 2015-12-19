$(document).ready ->
  $('#inscrire').hide()
  $('#login').hide()
  $("#bloc_metrics").hide()
  $('#save').hide()

  $('#btn_inscrire').click ->
    $('#login').hide()
    $('#inscrire').toggle()

  $('#btn_login').click ->
    $('#inscrire').hide()
    $('#login').toggle()

  $('#save-metrics').click ->
    $('#save').toggle()

  $.getJSON '/username.json', (data) ->
    $('#username').html data

  #Création de boutons pour chaque batch d'un user
  $.getJSON '/metrics_users.json', (batch) ->
    if batch.length > 0
      for mu in batch
        $('#btns').append "<button class='btn btn-success btn_batch' data-id='#{mu.id_batch}'>Batch n° #{mu.id_batch}</button>"

      $('.btn_batch').click ->
        id_batch = $(this).data "id"
        $.getJSON '/metricsbyuser.json', (data) ->
          #Inialisation du tableau
          $('#tab-metrics').empty()
          $('#bloc_metrics svg').empty()
          entete = "<th>Timestamp</th>"
          entete += "<th>Value</th>"
          entete += "<th>Suppr</th>"
          $('#tab-metrics').append(entete)

          #Récupération des metrics du batch correspondant
          i=0
          #tab = [][]
          for m in data
            if "#{m.id_batch}" == "#{id_batch}"
              $('#tab-metrics').append "<tr></tr>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{m.timestamp}</td>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{m.value}</td>"
              $('#tab-metrics tr:eq('+i+')').append "<td><button class='btn btn-danger btn_suppr' data-id='#{m.id_metric}'>X</button></td>"
              i++

          $('#bloc_metrics').show()
    ###
    $.getJSON '/metricsbyuser.json', (data) ->
      $('#tab-metrics').empty()
      $('#bloc_metrics svg').empty()
      entete = "<th>Timestamp</th>"
      entete += "<th>Value</th>"
      entete += "<th>Suppr</th>"
      $('#tab-metrics').append(entete)

      i=0
      dataset = []
      for metric in data
        dataset[i] = metric.value
        $('#tab-metrics').append "<tr></tr>"
        $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.timestamp}</td>"
        $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.value}</td>"
        $('#tab-metrics tr:eq('+i+')').append "<td><button class='btn btn-danger btn_suppr' data-id='#{metric.id}'>X</button></td>"
        i++

      #Graphique
      #dataset = [ 5, 10, 13, 19, 21, 25, 22, 18, 15, 13,11, 12, 15, 20, 18, 17, 16, 18, 23, 25 ]

      w = 500
      h = 100
      barPadding = 1

      svg = d3.select('#bloc_metrics svg')
      svg.selectAll("rect")
      .data dataset
      .enter()
      .append "rect"
      .attr "x", 0
      #.attr "y", 0
      .attr "width", 20
      #.attr "height", 100
      .attr "x", (d, i) ->
        #return i * (w / dataset.length - barPadding)
        return i * (w / 15 - barPadding)
      .attr "height", (d) ->
        return d *8
      .attr "y", (d) ->
        return h - d*4
      .attr "fill", (d) ->
        return "rgb(0, " + (d * 10) + ",0)"
      ###
###
      margin =
      top: 10
      right: 10
      bottom: 15
      left: 25
      width = 480 - (margin.left) - (margin.right)
      height = 250 - (margin.top) - (margin.bottom)
      #parseDate = d3.time.format('%d-%b-%y').parse
      x = d3.scale.linear().range([
        0
        width
      ])
      y = d3.scale.linear().range([
        height
        0
      ])
      xAxis = d3.svg.axis().scale(x).orient('bottom')
      yAxis = d3.svg.axis().scale(y).orient('left')
      line = d3.svg.line().x((m) ->
        x m.timestamp
      ).y((m) ->
        y m.value
      )
      svg = d3.select('body').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
      for metric in data
        x.domain d3.extent(metric, (m) ->
          m.timestamp
        )
        y.domain d3.extent(metric, (m) ->
          m.value
        )
      svg.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
      svg.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 6).attr('dy', '.71em').style('text-anchor', 'end').text 'Price ($)'
      svg.append('path').datum(data).attr('class', 'line').attr 'd', line
      return
      ###
