

class Player 
    
    attr_reader :name, :ghost
    attr_writer :ghost
    def initialize(name)
        @name = name
        @ghost = ""
    end

    def alert_invlid_guess(guess)
        alpha = ("a".."z").to_a
        return true if alpha.include?(guess)
        false
    end

    def guess
        valid = false

        while !valid
            p "#{@name}, please enter a letter..."
            user_input = gets.chomp.downcase
            return user_input if alert_invlid_guess(user_input)
        end
        
    end
end