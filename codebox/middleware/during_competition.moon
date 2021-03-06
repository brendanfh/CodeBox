import Competitions from require 'models'

=>
    unless @competition
		@competition = Competitions\find short_name: @params.competition_name

		unless @competition
			@write json: 'No active competition'

    current_time = os.time()
    start_time = @competition\get_start_time_num!
    end_time = @competition\get_end_time_num!

    unless start_time <= current_time
        @write render: 'competition.not_started'
    unless current_time <= end_time
        @write render: 'competition.finished'
