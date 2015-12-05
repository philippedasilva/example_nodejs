$(document).ready ->

  $('#get-metrics').click ->

      $.getJSON '/metrics.json', (data) ->
           ###
           $('#tab-metrics').empty()
           entete = "<th>Timestamp</th>"
           entete += "<th>Value</th>"
           $('#tab-metrics').append(entete)

           i=0
           for metric in data
               $('#tab-metrics').append "<tr></tr>"
               $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.timestamp}</td>"
               $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.value}</td>"
               i++
          ###
          $('#tab-metrics').empty()
          entete = "<th>Key</th>"
          entete += "<th>Value</th>"
          $('#tab-metrics').append(entete)

          i=0
          for metric in data
              $('#tab-metrics').append "<tr></tr>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.key}</td>"
              $('#tab-metrics tr:eq('+i+')').append "<td>#{metric.value}</td>"
              i++

      alert "Getting"

###
$('#get-metrics').click (e) ->
      e.preventDefault()
      $.getJSON '/metrics.json', (data) ->
            $('.container').empty()
            c = ""
            for metric in data
                c += "<p>timestamp: #{metric.timestamp}<br/>value: #{metric.value}</p>"
            $('.container').append c
###
