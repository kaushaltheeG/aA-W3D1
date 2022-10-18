require "set"
require_relative "player"

class Game

    def self.get_dictionary
        dictionary = File.open("../dictionary.txt")
        file_data = dictionary.read
        arr = file_data.split("\n")
        Set.new(arr)
    end

    def self.losses_hash(players_arr)
        hash = Hash.new { |h,k| h[k] = 0}

        players_arr.each do |player|
            hash[player.name]
        end
        hash
    end

    def self.multi_player(players_arr)
        arr = []
        players_arr.each { |player| arr << Player.new(player)}
        arr
    end

    attr_reader :fragment, :current_player
    def initialize(*players)
        @players, @fragment = Game.multi_player(players), ""
        @current_player, @previous_player = @players[0], @players[-1] 
        @losses_hash = Game.losses_hash(@players)
    end

    def lazy_dictionary
        @dictionary = Game.get_dictionary
    end

    def next_player!
        @previous_player = @current_player
        @players.push(@players.shift)
        @current_player = @players[0]
    end

    def valid_play?(str)
        #check if str is in the alphabet in players
        temp = @fragment + str
        map = @dictionary.map {|word| word.include?(temp)}
        return true if map.include?(true)
        false
    end

    def take_turn(player)
        valid = false
        while !valid
            letter = player.guess
            valid = valid_play?(letter)
            @fragment += letter if valid
        end
        p "The fragment is now... #{@fragment}"
    end

    def play_round
        take_turn(@current_player)
        next_player!
    end

    def losses(player)
        @losses_hash[player.name] = @losses_hash[player.name] + 1
        record(player)
    end

    def record(player)
        str = "GHOST"
        idx = @losses_hash[player.name]
        player.ghost = str[0...idx]
    end

    def run 
        self.lazy_dictionary
        while @players.length > 1
            play_round
            if @dictionary.include?(@fragment)
                losses(@previous_player)
                p "#{@previous_player.name} has lost this round"
                @fragment = ""
                remove_player!
            end
            display_standings
        end
        p "Looks like everyone got GHOST, except for #{@players[0].name}"
        p "Congratulations #{@players[0].name.upcase}!!"
    end

    def display_standings
        @players.each do |player|
            temp = player.ghost.length == 0 ? "zero letters!" : player.ghost
            p "#{player.name} currently has #{temp}"
        end
    end

    def has_ghost?
        @players.each do |player|
            return true if player.ghost == "GHOST"
        end
        false
    end

    def remove_player!
        idx = 0
        if has_ghost?
            @players.each.with_index do |player, i|
                if player.ghost == "GHOST"
                    idx = i
                    break
                end
            end
            @players.slice!(idx)
        end
    end
    

end


g = Game.new('k','z','l')
g.run
