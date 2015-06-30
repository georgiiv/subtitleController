require 'green_shoes'


=begin     #This is how you change the button label
Shoes.app do
  @btn = button('old text ') {|btn|alert('Hello, World!')}
  button('Change!') {|btn|@btn.real.set_label("new")}
end
=end


file_path = "Please Select file"
time_to_move = 0

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
		end
		@asd = para ""
		
	end
end

p file_path
p time_to_move
