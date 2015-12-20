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

  $('.btn_add_metric').click ->
    $('#save').toggle()

  $.getJSON '/username.json', (data) ->
    $('#username').html data

  #Création de boutons pour chaque batch d'un user
  $.getJSON '/metrics_users.json', (batch) ->
    if batch.length > 0
      for mu in batch
        $('#btns').append "<button class='btn btn-success btn_batch' data-id='#{mu.id_batch}'>Batch n° #{mu.id_batch}</button>"

      $('.btn_batch').click ->
        $('#bloc_metrics h3').html $(this).html()
        id_batch = $(this).data "id"
        $("input[name='id_batch']").val id_batch
        
        $.getJSON '/metricsbyuser.json', (data) ->
          #Inialisation du tableau
          $('#tab-metrics').empty()
          $('#bloc_metrics svg').empty()
          entete = "<th>Timestamp</th>"
          entete += "<th>Value</th>"
          $('#tab-metrics').append(entete)

          #Récupération des metrics du batch correspondant
          i=0
          tab = []
          for m in data
            if "#{m.id_batch}" == "#{id_batch}"
              $('#tab-metrics').append "<tr></tr>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{m.timestamp}</td>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{m.value}</td>"

              tab[i] =
                "timestamp" : "#{m.timestamp}"
                "value" : "#{m.value}"
              i++

          #Graphique
          $('#graph').empty()

          margin =
            top: 10
            right: 20
            bottom: 30
            left: 20
          width = 300 - (margin.left) - (margin.right)
          height = 230 - (margin.top) - (margin.bottom)
          formatInt = d3.format("d");
          x = d3.scale.ordinal().rangeRoundBands([
            0
            width
          ], .1)
          y = d3.scale.linear().range([
            height
            0
          ])
          xAxis = d3.svg.axis().scale(x).orient('bottom')
          yAxis = d3.svg.axis().scale(y).orient('left').tickFormat(formatInt)

          svg = d3.select('#graph').attr('width', width + margin.left + margin.right).attr('height', height + margin.top + margin.bottom).append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

          type = (d) ->
            d.value = +d.value
            d

          x.domain tab.map((d) ->
            d.timestamp
          )
          y.domain [
            0
            d3.max(tab, (d) ->
              d.value
            )
          ]
          svg.append('g').attr('class', 'x axis').attr('transform', 'translate(0,' + height + ')').call xAxis
          svg.append('g').attr('class', 'y axis').call(yAxis).append('text').attr('transform', 'rotate(-90)').attr('y', 10).attr('dy', '.71em').style('text-anchor', 'end').text 'Value'
          svg.selectAll('.bar').data(tab).enter().append('rect').attr('class', 'bar').attr('x', (d) ->
            x d.timestamp
          ).attr('width', x.rangeBand()).attr('y', (d) ->
            y d.value
          ).attr('height', (d) ->
            height - y(d.value)
          )

          $('#bloc_metrics').show()
