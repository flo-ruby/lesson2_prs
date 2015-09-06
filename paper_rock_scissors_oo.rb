require "pry"

class Game
  attr_reader :player, :computer

  def initialize(name)
    @player = Human.new(name)
    @computer = Computer.new
    @winning_hand = nil
  end

  def play
    player.pick_hand
    puts "You picked #{@player.hand}."

    computer.pick_hand
    puts "Computer picked #{@computer.hand}."

    compare_hands

    puts "Current score: player #{player.score}, computer #{computer.score}"
  end

  def compare_hands
    if player.hand == computer.hand
      puts "It's a tie!"
    elsif player.hand > computer.hand
      puts player.hand.winning_message
      puts "Congrats #{@player.name}, you win!"
      player.marks_score
    else
      puts computer.hand.winning_message
      puts "Sorry #{@player.name}, computer won."
      computer.marks_score
    end
  end
end

class Player
  attr_reader :name, :hand, :score

  def initialize
    @hand = Hand.new
    @score = 0
  end

  def marks_score
    @score += 1
  end
end

class Human < Player
  def initialize(name)
    @name = name
    super()
  end

  def pick_hand
    @hand.let_choose
  end
end

class Computer < Player
  def pick_hand
    @hand.pick_random
  end
end

class Hand
  include Comparable

  CHOICES = {"P" => "Paper", "R" => "Rock", "S" => "Scissors"}

  attr_reader :value

  def <=>(other_hand)
    if value == otherHand.value
      0
    elsif ((value == "P" && other_hand.value == "R") || (value == "R" && other_hand.value == "S") || (value == "S" && other_hand.value == "P"))
      1
    else  
      -1
    end
  end

  def initialize
    @value = nil
  end

  def to_s
    "#{CHOICES[value]}"
  end

  def pick_random
    @value = CHOICES.keys.sample
  end

  def let_choose
    loop do
      puts "Choose one among Paper, Rock, Scissors (P/R/S)"
      answer = gets.chomp.upcase
      if CHOICES.include?(answer)
        @value = answer
        break
      end
    end
  end

  def winning_message
    case value
    when "P"
      "Paper wraps Rock!"
    when "R"
      "Rock breaks Scissors!"
    when "S"
      "Scissors cut Paper!"
    end
  end
end

puts "Welcome to Paper, Rock, Scissors. What is your name?"
name = gets.chomp
game = Game.new(name)
loop do
  game.play
  puts "Would you like to play again (Y/N)?"
  if gets.chomp.upcase != "Y"
    break
  end
  puts ""
end