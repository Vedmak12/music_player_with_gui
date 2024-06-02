require 'rubygems'
require 'gosu'

 TOP_COLOR= Gosu::Color::BLACK
 BOTTOM_COLOR = Gosu::Color.new(0xFF8C92AC)
# BACKGROUND_COLOR = Gosu::Color.new(0xFF0096FF)
BACKGROUND_COLOR = Gosu::Color::GRAY
ARTWORK_WIDTH = 750

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

module ScreenType
	ALBUMS, TRACKS = *0..1
end
GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :title, :artist, :genre, :artwork, :tracks

	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
	end
end

class Track
	attr_accessor :title, :location

	def initialize (title, location)
		@title = title
		@location = location
	end
end

def read_track(file)
    track_name = file.gets.chomp
    track_location = file.gets.chomp
    return Track.new(track_name, track_location)
end

def read_tracks(file)
    tracks = []
    count = file.gets.to_i
    i = 0
    while i < count
        tracks << read_track(file)
        i += 1
    end
    return tracks
end

def read_album(file)
    title = file.gets.chomp
    artist = file.gets.chomp
	artwork_pic = file.gets.chomp
    tracks = read_tracks(file)
    return Album.new(title, artist, artwork_pic, tracks)
end

def read_albums()
    albums = []
    file = File.new('albums.txt', 'r')
    count = file.gets.to_i

    i = 0
    while i < count
        albums << read_album(file)
        i += 1
    end

    file.close
    return albums
end

class ArtWork
	attr_accessor :png

	def initialize (file)
		@png = Gosu::Image.new(file)
	end
end

# Put your record definitions here

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 1000, 600
	    self.caption = "Music Player"

		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
       
           @albums = read_albums()
           @big_font = Gosu::Font.new(30)
           @med_font = Gosu::Font.new(22)
           @tiny_font = Gosu::Font.new(17)
   
           @screen_type = ScreenType::ALBUMS
           @selected_album = 0
           @selected_track = 0
           @change_track = true
           @manual_pause = false
	end

  # Put in your code here to load albums and tracks

  # Draws the artwork on the screen for all the albums

  def albums_screen(albums)
        title = " Please choose an Album to play"
		
		@big_font.draw_text(title, 45, 48, ZOrder::UI, 1.0, 1.0, Gosu::Color.new(0xFFECEAE2))
       


		i = 0
		while i < 1
			
				album = albums[i]
				artwork = Gosu::Image.new("images/#{album.artwork}.png")
				artwork.draw(33, 124, ZOrder::UI, scale_x = 0.7, scale_y = 0.7)

				@med_font.draw_text(album.title, 80, 290, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			
			i += 1
		end
        i = 1
		while i < 2
			
				album = albums[i]
				artwork = Gosu::Image.new("images/#{album.artwork}.png")
				artwork.draw(289, 124, ZOrder::UI, scale_x = 0.7, scale_y = 0.7)

				@med_font.draw_text(album.title, 270, 290, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			
			i += 1
		end
        i = 2
		while i < 3
			
				album = albums[i]
				artwork = Gosu::Image.new("images/#{album.artwork}.png")
				artwork.draw(33, 406, ZOrder::UI, scale_x = 0.7, scale_y = 0.7)

				@med_font.draw_text(album.title,42, 575, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			
			i += 1
		end
        i = 3
		while i < 4
			
				album = albums[i]
				artwork = Gosu::Image.new("images/#{album.artwork}.png")
				artwork.draw(289, 406, ZOrder::UI, scale_x = 0.7, scale_y = 0.7)

				@med_font.draw_text(album.title, 275, 575, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
			
			i += 1
		end
	end
    def albums_and_songs_screen(album)	
		# draw the home button
		home_btn = Gosu::Image.new("buttons/Home_Button.png")
		home_btn.draw(860, 9, ZOrder::UI)
		@med_font.draw_text("Back To Home", 820, 60, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		# Draw the album title
		x_title = 725
		x_minus = @big_font.text_width(album.title, 1.0) / 2.0
		y_title = 94
		@big_font.draw_markup("<b>Playing #{album.title}</b>", x_title - x_minus, y_title, ZOrder::UI, 1.0, 1.0, Gosu::Color.new(0xFFECEAE2))

		# Draw the album artwork
		artwork = Gosu::Image.new("images/#{album.artwork}.png")
		artwork.draw(700, 135, ZOrder::UI, scale_x = 0.7, scale_y = 0.7)

		# Draw the artist
		x_artist = 775
		x_minus = @big_font.text_width(album.artist, 1.0) / 2.0
		y_artist = 310
		@big_font.draw_text(album.artist, x_artist - x_minus, y_artist, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

		# Draw the tracks
		Gosu.draw_rect(650, 350, 500, 175, Gosu::Color.argb(0xff_8E8E93), ZOrder::PLAYER, mode=:default)

		i = 0
		while i < album.tracks.length
			track = album.tracks[i]
			y_track = 375 + i *30

			track_title = track.title
			track_color = Gosu::Color::WHITE
			if i == @selected_track
				track_title = "<b>#{track.title}</b>"
				track_color = Gosu::Color::BLACK
				if @change_track
					@song = Gosu::Song.new(track.location)
					@song.play(false)
					@change_track = false
				end
			end
			@med_font.draw_markup(track_title, 725, y_track, ZOrder::UI, 1.0, 1.0, track_color)
			i += 1
		end

		if not @song.playing? and not @manual_pause
			@selected_track = (@selected_track + 1) % album.tracks.length
			@change_track = true
		end

		# Draw media buttons
		btns = Gosu::Image.new("buttons/Media_Buttons.png")
		btns.draw(710, 550, ZOrder::UI)
	end
    def draw_background
		# Gosu.draw_rect(0, 0, 1000, 600, BACKGROUND_COLOR, ZOrder::BACKGROUND, mode=:default)
		Gosu.draw_quad(0, 0, TOP_COLOR, 1000, 0, TOP_COLOR, 0, 600, BOTTOM_COLOR, 1000, 600, BOTTOM_COLOR, ZOrder::BACKGROUND)

	end

    def mouse_albums(x, y)
		i = 0
	    if x.between?(33, 33+ ARTWORK_WIDTH * 0.7) && y.between?(124, 124 + ARTWORK_WIDTH * 0.7)
		    @selected_album = i 
			@screen_type = ScreenType::TRACKS
			
		end
	 i = 1
		if x.between?(289, 289+ ARTWORK_WIDTH * 0.7) && y.between?(124, 124 + ARTWORK_WIDTH * 0.7)
			@selected_album = i 
			@screen_type = ScreenType::TRACKS
		end
	i = 2
		if x.between?(33, 33+ ARTWORK_WIDTH * 0.7) && y.between?(406, 406 + ARTWORK_WIDTH * 0.7)
			@selected_album = i 
			@screen_type = ScreenType::TRACKS
	    end
				
	i = 3
	    if x.between?(289, 289+ ARTWORK_WIDTH * 0.7) && y.between?(406, 406 + ARTWORK_WIDTH * 0.7)
		    @selected_album = i 
			@screen_type = ScreenType::TRACKS
        end
	end		
		


	def mouse_tracks(x, y)
		if x.between?(835, 835 + 22 + @med_font.text_width("Back to Home", 1.0)) && y.between?(9, 9 + 22)
			@screen_type = ScreenType::ALBUMS
			@selected_track = 0
			@song.stop
			@change_track = true
			@manual_pause = false
		end
		# Select track
		i = 0
		while i < @albums[@selected_album].tracks.length
			if x.between?(670, 670 + 272) && y.between?(373 + i * 30, 373 + i * 30 + 30)
				if @selected_track != i
					@selected_track = i
					@change_track = true
				end
			end
			i += 1
		end

		# Media buttons
		# Previous
		if x.between?(710, 710 + 40) && y.between?(550, 550 + 40)
			@song.stop
			@selected_track = (@selected_track - 1) % @albums[@selected_album].tracks.length
			@change_track = true
		end

		# Play/Pause
		if x.between?(760, 760 + 40) && y.between?(550, 550 + 40)
			if @song.playing?
				@song.pause
				@manual_pause = true
			else
				@song.play
				@manual_pause = false
			end
		end

		# Next
		if x.between?(810, 810 + 40) && y.between?(550, 550 + 40)
			@song.stop
			@selected_track = (@selected_track + 1) % @albums[@selected_album].tracks.length
			@change_track = true
		end

		#detect change in album while a song is playing
		if x.between?(33, 33+ ARTWORK_WIDTH * 0.25) && y.between?(124, 124 + ARTWORK_WIDTH * 0.25)
			@selected_track = 0
			@song.stop
			@change_track = true
			@manual_pause = false
		    @selected_album = 0
			@screen_type = ScreenType::TRACKS
			
		end
		if x.between?(289, 289+ ARTWORK_WIDTH * 0.25) && y.between?(124, 124 + ARTWORK_WIDTH * 0.25)
			@selected_track = 0
			@song.stop
			@change_track = true
			@manual_pause = false
			@selected_album = 1
			@screen_type = ScreenType::TRACKS
		end

		if x.between?(33, 33+ ARTWORK_WIDTH * 0.25) && y.between?(406, 406 + ARTWORK_WIDTH * 0.25)
			@selected_track = 0
			@song.stop
			@change_track = true
			@manual_pause = false
			@selected_album = 2
			@screen_type = ScreenType::TRACKS
	    end

		if x.between?(289, 289+ ARTWORK_WIDTH * 0.25) && y.between?(406, 406 + ARTWORK_WIDTH * 0.25)
		    @selected_track = 0
			@song.stop
			@change_track = true
			@manual_pause = false
			@selected_album = 3
			@screen_type = ScreenType::TRACKS
        end
		
	end

	def draw
		draw_background()

		case @screen_type
		when ScreenType::ALBUMS
			albums_screen(@albums)
		when ScreenType::TRACKS
			albums_screen(@albums)
			albums_and_songs_screen(@albums[@selected_album])
		end

		# Draw credit
		credit_text = "@Created by VED JAY MAKHIJANI, 2024"
		
		@tiny_font.draw_text(credit_text, 350, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color.new(0xFFECEAE2))
	end

 	def needs_cursor?; true; end

	def button_down(id)
		case id
	    when Gosu::MsLeft
			case @screen_type
			when ScreenType::ALBUMS
				mouse_albums(mouse_x, mouse_y)
			when ScreenType::TRACKS
				mouse_tracks(mouse_x, mouse_y)
			end
	    end
	end

end

MusicPlayerMain.new.show if __FILE__ == $0

	# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	

	# Handle the button_down event
	
