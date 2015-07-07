require 'green_shoes'

=begin     #This is how you change the button label
Shoes.app do
  @btn = button('old text ') {|btn|alert('Hello, World!')}
  button('Change!') {|btn|@btn.real.set_label("new")}
end
=end

=begin
sub[i][0] -> sub number
sub[i][1] -> sub start time
sub[i][2] -> sub end time
sub[i][3] -> sub text
=end

#the time you want to move is inserted like:    hh:mm:ss,ms
#if you want to add negative time its added like:    -hh:-mm:-ss,-ms    Only put the minus in the place it's needed

file_path = "Please Select file"
time_to_move = ""
subs = []

Shoes.app( :width => 400, :height => 200 ) do
	background papayawhip
	stack do
		@click = button("Open") do
			file_path = ask_open_file
			@space.replace file_path
		end
		@space = para file_path
		
		@movecapt = para "how much do you want to move?"
		@movetime = edit_line
		button "Move" do
			@asd.replace ("moving #{@movetime.text}")
			time_to_move = @movetime.text
			
			line_num=0
			text = File.open("#{file_path}").read
			text.gsub!(/\r\n?/, "\n")
			parse = "sub_number"
			i = 0
			text.each_line do |line|
				case parse
					when "sub_number"
						if line != "\n"
							subs[i] = []
							subs[i][0] = line
						
							parse = "sub_time"
						end
					when "sub_time"
						stime = line.split(" --> ")
						subs[i][1] = stime[0]
						subs[i][2] = stime[1]
						
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
			
			for i in 0..subs.length-1
				start_time = subs[i][1].split(":")
				start_hours = start_time[0].to_i
				start_minutes = start_time[1].to_i
				start_seconds = start_time[2].split(",").first.to_i
				start_miliseconds = start_time[2].split(",").last.to_i
				
				end_time = subs[i][2].split("\n").first.split(":")
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
				if end_minutes < 59
					end_hours -= 1
					end_minutes += 60
				end
				end_hours += move_hours				
				subs[i][2] = "#{end_hours}:#{end_minutes}:#{end_seconds},#{end_miliseconds}"
			end
			
			File.open("#{file_path.split(".srt").first}_moved.srt", 'w') do |file|
				for i in 0..subs.length-1
					file.write("#{subs[i][0]}#{subs[i][1]} --> #{subs[i][2]}\n#{subs[i][3]}\n")
				end
			end

			p subs[2192][0]
			p subs[2192][1]
			p subs[2192][2]
			p subs[2192][3]
		end
		@asd = para ""
		
	end
end

p file_path
p time_to_move

