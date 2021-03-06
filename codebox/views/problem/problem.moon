html = require "lapis.html"
markdown = require "markdown"
import Users, Problems from require 'models'

class ProblemsView extends html.Widget
	content: =>
		div class: 'sidebar-page-container', ->
			unless @problem
				div 'data-setonload': 'left:0', style: 'left: -250px', class: 'sidebar-problem-list', ->
					widget (require 'views.partials.problem_sidebar')
			else
				div class: 'sidebar-problem-list', ->
					widget (require 'views.partials.problem_sidebar')

			div style: 'overflow:hidden', class: 'content', ->
				unless @problem
					h1 "Select a problem from the sidebar"
				else
					h1 @problem.name
					div 'data-setonload': 'left: 0', style: 'left: 500px', class: 'problem-info mar-l-24 mar-b-24', ->
						if @problem.kind == Problems.kinds.word
							if Users\has_correct_submission @user.id, @problem.short_name
								h2 class: 'ta-center pad-8 bcolor-c', "Correct answer"
							elseif Users\has_incorrect_submission @user.id, @problem.short_name
								h2 class: 'ta-center pad-8 bcolor-e', "Incorrect answer"
							else
								form ->
									input id: 'answer', class: 'w100 pad-12', style: 'font-size: 1.1rem', placeholder: "Enter answer here"
									button id: 'word-problem-submit-btn', style: "margin-bottom: 0; font-size: 1.2rem", class: 'ta-center button w100', ->
											text 'Submit answer'

							div class: 'box', ->
								div class: 'split-lr pad-12', ->
									div "Problem kind:"
									kind = Problems.kinds\to_name @problem.kind
									div "#{kind}"
						else
							a {
								style: "margin-bottom: 0; font-size: 1.4rem"
								class: 'ta-center button w100'
								href: (@url_for 'problem.submit', { competition_name: @competition.short_name, problem_name: @problem.short_name })
								-> text "Make a submission"
							}

							div class: 'box', ->
								div class: 'split-lr pad-12', ->
									div "Time limit:"
									div "#{@problem.time_limit}ms"
								div class: 'split-lr pad-12', ->
									div "Problem kind:"
									kind = Problems.kinds\to_name @problem.kind
									div "#{kind}"
								unless @problem.blacklisted_langs == ""
									div class: 'split-lr pad-12', ->
										div "Language blacklist:"
										div "#{@problem.blacklisted_langs}"

						div style: 'font-size: 1.3rem;', class: 'header-line', -> text "Stats for #{@problem.name}"

						correct = @problem\get_correct_jobs!
						wrong = @problem\get_wrong_answer_jobs!
						timed_out = @problem\get_timed_out_jobs!
						error = @problem\get_error_jobs!

						div class: 'box', ->
							if (correct + wrong + timed_out + error) > 0
								piechart {
									style: 'display: inline-block; width: 100%'
									class: "pad-12 ta-center"
									"data-anim-wait": 500,
									"data-segments": 4,
									"data-segment-1": correct,
									"data-segment-1-color": "#44ff44",
									"data-segment-2": wrong,
									"data-segment-2-color": "#ff4444",
									"data-segment-3": timed_out,
									"data-segment-3-color": "#4444ff",
									"data-segment-4": error,
									"data-segment-4-color": "#777777"
								}, ""

							div class: 'pad-8 split-lr', ->
								p style: "color: #44ff44", -> text "Correct"
								p "#{correct}"
							div class: 'pad-8 split-lr', ->
								p style: "color: #ff4444", -> text "Wrong answer"
								p "#{wrong}"
							div class: 'pad-8 split-lr', ->
								p style: "color: #4444ff", -> text "Timed out"
								p "#{timed_out}"
							div class: 'pad-8 split-lr', ->
								p style: "color: #777777", -> text "Other error"
								p "#{error}"

					div class: 'problem-description', ->
						raw (markdown @problem.description)
