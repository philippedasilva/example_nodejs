$(document).ready ->
  $("#bloc_metrics").hide();
  $('#save').hide()

  #Login
  ###
  $('#submit_login').click ->
    $.postJSON '/', ->
    login = $("input[name='login']").val()
    password = $("input[name='password']").val()
    i=0
    $.getJSON '/users.json', (data) ->
      for users in data
        if login == "#{users.user}" && password == "#{users.password}"
          i++

    if i == 1
      return true
    else
      return false
  ###
  $('#save-metrics').click ->
     $('#save').toggle()

  $('#get-metrics').click ->

      $.getJSON '/metrics.json', (data) ->
          $('#tab-metrics').empty()
          $('#bloc_metrics svg').empty()
          entete = "<th>Key</th>"
          entete += "<th>Value</th>"
          $('#tab-metrics').append(entete)

          i=0
          dataset = []
          for metric in data
              dataset[i] = metric.value
              $('#tab-metrics').append "<tr></tr>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.timestamp}</td>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.value}</td>"
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

           $('#bloc_metrics').toggle()
