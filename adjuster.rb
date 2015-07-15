require 'green_shoes'

#the time you want to move is inserted like:    hh:mm:ss,ms
#if you want to move backwards:    -hh:-mm:-ss,-ms

=begin
sub[i][0] -> sub number
sub[i][1] -> sub start time
sub[i][2] -> sub end time
sub[i][3] -> sub text
=end

file_path = "Open"
time_to_move = ""
subs = []

Shoes.app(title: "Mover", width: 300, height: 350, resizable: false) do
	background floralwhite..gray
	stack(margin_left: 30, margin_right: 30, margin_top: 5) do
		@click = button("#{file_path}") do
			file_path = ask_open_file
			@click.real.set_label("#{file_path.split("/").last}")
		end		
		
		@firstsubtext = para "from which subtitle to move"
		@firstsub = edit_line("1")
		
		@secondsubtext = para "to which subtitle to move (blank -> till the last)"
		@lastsub = edit_line
		
		@movecapt = para "how much do you want to move?"
		@movetime = edit_line("00:00:00,000")
		
		button "Move" do
			@asd.replace ("moving #{@movetime.text}")
			time_to_move = @movetime.text
			
			text = File.open("#{file_path}").read
			text.gsub!(/\r\n?/, "\n")
			parse = "sub_number"
			i = 0
			text.each_line do |line|
				case parse
					when "sub_number"
						if line != "\n"
							subs[i] = []
							subs[i][0] = line.split("\n").first
						
							parse = "sub_time"
						end
					when "sub_time"
						stime = line.split(" --> ")
						subs[i][1] = stime[0]
						subs[i][2] = stime[1].split("\n").first
						
						subs[i][3] = ""
						parse = "sub_text"
					when "sub_text"
						if line == "\n"
							i = i+1
							parse = "sub_number"
						end
						if line != "\n"
							subs[i][3] += line
						end
						
				end
				
			end
			time_to_move = time_to_move.split(":")
			move_hours = time_to_move[0].to_i
			move_minutes = time_to_move[1].to_i
			move_seconds = time_to_move[2].split(",").first.to_i
			move_miliseconds = time_to_move[2].split(",").last.to_i
			
			startmovesub = @firstsub.text.to_i
			if startmovesub<1
				startmovesub=1
			end
			
			endmovesub = @lastsub.text.to_i					
			
			for i in startmovesub-1..subs.length-1
				if i>0
					if i==endmovesub		#I want 0 or blank to be till the last but without this it
						break			#breaks the cycle immediately
					end
				end
				
				start_time = subs[i][1].split(":")
				start_hours = start_time[0].to_i
				start_minutes = start_time[1].to_i
				start_seconds = start_time[2].split(",").first.to_i
				start_miliseconds = start_time[2].split(",").last.to_i
				
				end_time = subs[i][2].split(":")
				end_hours = end_time[0].to_i
				end_minutes = end_time[1].to_i
				end_seconds = end_time[2].split(",").first.to_i
				end_miliseconds = end_time[2].split(",").last.to_i
				
				start_miliseconds += move_miliseconds
				if start_miliseconds > 999
					start_seconds += 1
					start_miliseconds -= 1000
				end
				if start_miliseconds < 0
					start_seconds -= 1
					start_miliseconds += 1000
				end
				start_seconds += move_seconds
				if start_seconds > 59
					start_minutes += 1
					start_seconds -= 60
				end
				if start_seconds < 0
					start_minutes -= 1
					start_seconds += 60
				end
				start_minutes += move_minutes
				if start_minutes > 59
					start_hours += 1
					start_minutes -= 60
				end
				if start_minutes < 0
					start_hours -= 1
					start_minutes += 60
				end
				start_hours += move_hours
				subs[i][1] = "#{start_hours}:#{start_minutes}:#{start_seconds},#{start_miliseconds}"
				
				end_miliseconds += move_miliseconds
				if end_miliseconds > 999
					end_seconds += 1
					end_miliseconds -= 1000
				end
				if end_miliseconds < 0 
					end_seconds -= 1
					end_miliseconds += 1000
				end
				end_seconds += move_seconds
				if end_seconds > 59
					end_minutes += 1
					end_seconds -= 60
				end
				if end_seconds < 0
					end_minutes -= 1
					end_seconds += 60
				end
				end_minutes += move_minutes
				if end_minutes > 59
					end_hours += 1
					end_minutes -= 60
				end
				if end_minutes < 0
					end_hours -= 1
					end_minutes += 60
				end
				end_hours += move_hours				
				subs[i][2] = "#{end_hours}:#{end_minutes}:#{end_seconds},#{end_miliseconds}"
			end
			
			File.open("#{file_path.split(".srt").first}_moved.srt", 'w') do |file|
				for i in 0..subs.length-1
					file.write("#{subs[i][0]}\r\n#{subs[i][1]} --> #{subs[i][2]}\r\n#{subs[i][3]}\r\n")
				end
			end

		end
		@asd = para ""
		
	end
end

p file_path
p time_to_move
