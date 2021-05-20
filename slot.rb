QUIT_COMMAND = 4

class Slot
  BET = [0,10,30,50,0]

  attr_accessor :izume

  def initialize(izume)
    self.izume = izume
  end

  def left?
    izume[0]==izume[1] && izume[1]==izume[2]
  end

  def center?
    (izume[3]==izume[4] && izume[4]==izume[5]) || (izume[1]==izume[4] && izume[4]==izume[7])
  end

  def right?
    izume[6]==izume[7] && izume[7]==izume[8]
  end

  def top?
    izume[0]==izume[3] && izume[3]==izume[6]
  end

  def bottom?
    izume[2]==izume[5] && izume[5]==izume[8]
  end
end

def possession(per_number,message,balance,point,bet)
  possession_point = bet * 10
  possession_balance = bet * 2
  point += possession_point
  balance += possession_balance
  puts "#{message}に#{per_number}が揃いました！"
  puts "#{possession_point}ポイント獲得！"
  puts "#{possession_balance}コイン獲得！"
  return balance,point
end

def push_enter
  enterkey = ""
  while true
    enterkey = gets
    if enterkey == "\n"
      return
    else
      puts "エンターを押してください"
    end
  end
end

def turn
  izume = ["","","","","","","","",""]
  puts "エンターを3回押しましょう！"
  for i in 0..2 do
    push_enter
    izume[3*i] = rand(0..9)
    izume[3*i+1] = rand(0..9)
    izume[3*i+2] = rand(0..9)
    puts "-------------------------"
    puts "|#{izume[0]}|#{izume[3]}|#{izume[6]}|"
    puts "|#{izume[1]}|#{izume[4]}|#{izume[7]}|"
    puts "|#{izume[2]}|#{izume[5]}|#{izume[8]}|"
  end
  puts "-------------------------"
  result = Slot.new(izume)
  return result,izume
end

def gets_select(balance)
  while true
    select = gets.to_i
    if select.between?(1,4) == true
      if balance < Slot::BET[select]
        puts "コインが足りません\n再度入力してください"
        puts "残りコイン数#{balance}"
      else
        return select
      end
    else
      puts "無効な入力です\n再度入力してください"
    end
  end
end

def execute
  balance = 100
  point = 0
  while true
    puts "--------"
    puts "残りコイン数#{balance}"
    puts "ポイント#{point}"
    puts "何コイン入れますか？"
    puts "1(#{Slot::BET[1]}コイン) 2(#{Slot::BET[2]}コイン) 3(#{Slot::BET[3]}コイン) 4(やめとく)"
    puts "--------"
    player_select = gets_select(balance)
    if player_select == QUIT_COMMAND
      puts "また遊びましょう"
      return
    end
    result,izume = turn
    if result.right?
      balance,point = possession(izume[6],"右列",balance,point,
        Slot::BET[player_select])
    elsif result.left?
      balance,point = possession(izume[0],"左列",balance,point,
        Slot::BET[player_select]) 
    elsif result.center?
      balance,point = possession(izume[4],"真ん中",balance,point,
        Slot::BET[player_select])
    elsif result.top?
      balance,point = possession(izume[0],"上段",balance,point,
        Slot::BET[player_select])
    elsif result.bottom?
      balance,point = possession(izume[2],"下段",balance,point,
        Slot::BET[player_select])
    else
      balance -= Slot::BET[player_select]
      if balance == 0
        puts "最終ポイントは#{point}です"
        return
      end
    end
  end
end

execute


