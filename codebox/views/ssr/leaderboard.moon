html = require 'lapis.html'
import CompetitionProblems, LeaderboardProblems, Problems from require 'models'

class Leaderboard extends html.Widget
    new: (@placements, @first_load) =>

    content: =>
        div class: 'leaderboard', ->
            drawn_labels = false
			offset = 0
            for place in *@placements
                @problems = place\get_problems!
                CompetitionProblems\include_in @problems, "problem_id",
                    as: 'cp'
                    flip: true
                    local_key: 'problem_id'
                    where: { competition_id: @competition.id }
				Problems\include_in @problems, 'id',
					as: 'p'
					flip: true
					local_key: 'problem_id'
					fields: 'id, kind'

                 -- Sort the problems by letter
                prob.lnum = (prob.cp.letter\byte 1) for prob in *@problems
                table.sort @problems, (a, b) ->
                    a.lnum < b.lnum

                unless drawn_labels
                    div style: "top: 0px; z-index: 1001", class: 'placement-labels', ->
                        div "Place"
                        div "Name"
                        div class: 'problem', style: "grid-template-columns: repeat(#{#@problems}, 1fr)", ->
                            for prob in *@problems
                                div style: 'position: relative', ->
									if prob.p.kind == Problems.kinds.golf
										span style: "position: absolute; left: 0; top 0; font-size:.8rem", 'Golf'
									div "#{prob.cp.letter}"
                        div "Score"
					offset += 36
                    drawn_labels = true

                div {
					'data-setonload': "top:#{offset}px",
					style: "top: #{if @first_load then '0' else offset}px; z-index: #{1000-place.place}",
					class: "placement #{@user.id == place.user_id and "user" or ""}" }, ->
                    div "#{place.place}"
                    div "#{place\get_user!.nickname}"

                    div class: 'problem', style: "grid-template-columns: repeat(#{#@problems}, 1fr)", ->
                        for prob in *@problems
                            prob_status = switch prob.status
                                when LeaderboardProblems.statuses.correct then "correct"
                                when LeaderboardProblems.statuses.wrong then "wrong"
                                when LeaderboardProblems.statuses.attempted then "attempted"

                            div class: "#{prob_status}", ->
                                div "#{prob.points}"
                                div "#{prob.attempts}"

                    div "#{place.score}"

					offset += 44
