class Gamemanager < ActiveRecord::Base
  belongs_to :game
  serialize :supply_count, Hash

  # Returns the name of the player who's turn it is
  def current_player_name
    Player.find(player_turn).name unless player_turn.nil?
  end

  # Returns the player object who's turn it is
  def current_player
    Player.find(player_turn) unless player_turn.nil?
  end

  # Returns the current available treasure balance for the current player
  def current_treasure_balance
    current_hand_treasure_balance + (self.treasure || 0)
  end

  # End current phase and move on to next
  def next_phase
    if phase == 'Action'
      reset_action_variables
      update_attributes(phase: "Buy")    
    elsif phase == 'Buy'
      reset_player_balances
      current_player.discard.add_deck_to_top( current_player.played )
      current_player.discard.add_deck_to_top( current_player.hand )
      current_player.draw_card(5)
      next_turn
      update_attributes(phase: "Action")
    end
  end

  def end_card_action_phase
    update_attributes(action_phase: 'End')
  end

  # End current user's turn and initiate next users turn
  def next_turn
    turn_sequence = game.players.find(player_turn).turn_order
    if turn_sequence == game.players.maximum(:turn_order)
      turn_sequence = 1
    else
      turn_sequence = turn_sequence + 1
    end
    update_attributes(player_turn: game.players.find_by(turn_order: turn_sequence).id)
  end

  # Plays the given card
  def play_card(card)
    puts 'begin playcard id :' + card.id.to_s
    if self.respond_to?(card.name.gsub(' ','_'), true)
      update_attributes(played_card_id: card.id)
      self.send(card.name.gsub(' ','_'), nil)
    else
      puts 'No card played! gamemanager couldnt find details for ' + card.cardmapping.name
    end
  end

  # Plays subsequent action card actions by passing user selections in a hash to the action's method
  def play_card_action(action_hash)
    puts 'begin playcardaction id :' + played_card_id.to_s + ' action_hash = ' + action_hash.to_s
    unless played_card_id.nil?
      card = Card.find(played_card_id)
      if self.respond_to?(card.name.gsub(' ','_'), true)
        self.send(card.name.gsub(' ','_'), action_hash)
      else
        puts 'No cardaction played! gamemanager couldnt find details for ' + played_card_id.to_s
      end
    end
  end

  # Buys a given card
  def buy_card(card_name)
    mapping = Cardmapping.find_by(name: card_name)
    current_player.discard.cards.create!( cardmapping_id: mapping.id ) 
    decrement_supply_count(card_name, 1)
    update_attributes(buys: buys - 1, treasure: treasure - mapping.cost )
  end

  # Decrease the remaining supply cards count based on the given card name and count
  def decrement_supply_count(card_name, count)
    current_counts = supply_count
    if current_counts.has_key? card_name
      current_counts[card_name] = current_counts[card_name] - count
    end
    update_attributes( supply_count: current_counts )
  end

  # Set the supply cards count based on the given card name and count
  def initialize_supply_count(card_name, count)
    current_counts = supply_count
    current_counts.store(card_name, count)
    update_attributes( supply_count: current_counts )
  end

  private

    # Returns the current available treasure balance in the current players hand
    def current_hand_treasure_balance
      balance = 0
      current_player.hand.all_treasure_cards.each do |c|
        balance = balance + ( c.cardmapping.treasure_amount || 0 )
      end
      return balance
    end

    # Add the given number to the current players actions counter
    def add_actions(count)
      update_attributes(actions: actions + count)
    end

    # Add the given number to the current players buys counter
    def add_buys(count)
      update_attributes(buys: buys + count)
    end

    # Add the given number to the current players treasure counter (this balance only reflects treasure from action cards
    def add_treasures(count)
      update_attributes(treasure: treasure + count)
    end

    # Reset the columns used for maintaining player balances
    def reset_player_balances
      update_attributes(actions: 1, treasure: 0, buys: 1, prompt: nil) 
    end

    # Reset the columns used for controlling card handling
    def reset_action_variables 
      update_attributes(selection_id: nil, value: nil, played_card_id: nil, action_phase: nil)
    end


   ###############     Begin Action Card definitions    ##############


    # Village: +1 card / +2 actions
    def Village(action_hash = {})
      puts 'Village called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        add_actions(1) # +2 actions -1 from playing village = +1 actions
        player = game.players.find(player_turn)
        player.draw_card(1)
        player.add_to_played(card)
        update_attributes(prompt: '<b>Played Village!</b><br />Draw 1 card / +2 Actions<br />')
      end
      reset_action_variables
    end

    # Laboratory: +2 cards / +1 action
    def Laboratory(action_hash = {})
      puts 'Laboratory called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        # +1 actions -1 from playing laboratory = +0 actions
        player = game.players.find(player_turn)
        player.draw_card(2)
        player.add_to_played(card)
        update_attributes(prompt: '<b>Played Village!</b><br />Draw 1 card / +2 Actions<br />')
      end
      reset_action_variables
    end

    # Smithy: +3 cards
    def Smithy(action_hash = {})
      puts 'Smithy called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        add_actions(-1)
        player = game.players.find(player_turn)
        player.draw_card(3)
        player.add_to_played(card)
        update_attributes(prompt: '<b>Played Smithy!</b><br />Draw 3 cards<br />')
      end
      reset_action_variables
    end

    # Woodcutter: +1 buy / +2 treasure
    def Woodcutter(action_hash = {})
      puts 'Woodcutter called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        add_actions(-1)
        add_buys(1)
        add_treasures(2)
        player = game.players.find(player_turn)
        player.add_to_played(card)
        update_attributes(prompt: '<b>Played Woodcutter!</b><br />+1 Buy / +2 Treasure<br />')
      end
      reset_action_variables
    end

    # Bureaucrat: Gain a silver card at the top of your deck. Each other player with a victory card in their hand puts it on the top of their deck.
    def Bureaucrat(action_hash = {})
      puts 'Bureaucrat called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        add_actions(-1)
        player = game.players.find(player_turn)
        player.add_to_played(card)
        player.supply.cards.create!( cardmapping_id: Cardmapping.get( 'Silver' ) )
        decrement_supply_count('Silver', 1)
        game.players.where.not(id: player_turn).each do |p|
          puts 'adding victory to supply for player_id = ' + p.id.to_s
          p.hand.cards.all.each do |c|
            puts 'card name = ' + c.cardmapping.name + ' victory = ' + c.cardmapping.is_victory.to_s + ' action = ' + c.cardmapping.is_action.to_s
            if ( c.cardmapping.is_victory and not c.cardmapping.is_action )
              p.add_to_supply(c)
              break
            end
          end
        end
        update_attributes(prompt: '<b>Played Bureaucrat!</b><br />Gain a silver card at the top of your deck.<br />Each other player with a victory card in their hand puts it on the top of their deck.<br />')
      end
      reset_action_variables
    end

    # Witch: +2 Cards. Each other player gains a curse card
    def Witch(action_hash = {})
      puts 'Witch called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        add_actions(-1)
        player = game.players.find(player_turn)
        player.add_to_played(card)
        player.draw_card(2)
        game.players.where.not(id: player_turn).each do |p|
          puts 'adding curse to discard for player_id = ' + p.id.to_s
          p.discard.cards.create!( cardmapping_id: Cardmapping.get( 'Curse' ) )
        end
        update_attributes(prompt: '<b>Played Witch!</b><br />Draw 2 cards<br />Each other player gains a curse card.<br />')
      end
      reset_action_variables
    end

    # Council Room: +4 cards/+1 buy and each other player draws a card
    def Council_Room(action_hash = {})
      puts 'Council Room called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        add_actions(-1)
        add_buys(1)
        player = game.players.find(player_turn)
        player.draw_card(4)
        player.add_to_played(card)
        game.players.where.not(id: current_player.id).each do |p|
          p.draw_card(1)
        end
        update_attributes(prompt: '<b>Played Council Room!</b><br />Draw 4 cards / +1 Buy<br />All other players draw 1 card!<br />')
      end
      reset_action_variables
    end
    
    # Festival: +2 actions/+1 buy/+2 treasure
    def Festival(action_hash = {})
      puts 'Festival called!'
      card = Card.find(played_card_id)
      if card and phase == 'Action'
        player = game.players.find(player_turn)
        add_actions(1) # +2 actions -1 from playing festival = +1 actions
        add_buys(1)
        add_treasures(2)
        player.add_to_played(card)
        update_attributes(prompt: '<b>Played Festival!</b><br />+2 Actions / +1 Buy / +2 Treasure<br />')
      end
      reset_action_variables
    end

    # Cellar: +1 Action & discard any number of cards, +1 card per card discarded
    def Cellar(action_hash = {})
      puts 'Cellar called! phase = ' + phase + ' action_hash = ' + action_hash.to_s + ' class = ' + action_hash.class.to_s
      if phase == 'Action' and self.played_card_id
        puts 'begin cellar execution'
        card = Card.find(played_card_id)
        player = game.players.find(player_turn)
        if action_phase.nil?  # first time playing this card
          puts 'Cellars initial play!'
          player.add_to_played(card)
          # +1 actions - 1 from playing cellar = +0 actions
          player.mark_all_hand_selectable
          update_attributes(played_card_id: card.id, value: 0, action_phase: 'Discard', prompt: '<b>Played Cellar!</b><br />+1 Action<br />Discard cards any number of cards from your hand, +1 card for each card discarded!')
        elsif action_phase == 'Discard' and card and action_hash # discarding a card
          puts 'discard array = ' + action_hash['Discard'].to_s
          action_hash['Discard'].each do |card_id|
            discard_card = Card.find(card_id)
            discard_card.unmark_selectable
            player.add_to_discard(discard_card)
            update_attributes(value: value + 1)
          end
          update_attributes(prompt: '<b>Played Cellar!</b><br />+1 Action<br />Discard cards any number of cards from your hand, +1 card for each card discarded!<br />Discarded ' + value.to_s + ' cards!' ) 
        elsif action_phase == 'End' and card # ending card and drawing cards
          player.unmark_all_hand_selectable
          player.draw_card(value) 
          reset_action_variables
        end
      end
    end

    # Mine: Trash a treasure card from your hand, gain a treasure card costing up to 3 treasure more and put it in your hand
    def Mine(action_hash = {})
      puts 'Mine called! phase = ' + phase + ' action_hash = ' + action_hash.to_s
      if phase == 'Action' and self.played_card_id
        puts 'begin mine execution'
        card = Card.find(played_card_id)
        player = game.players.find(player_turn)
        if action_phase.nil?  # first time playing this card
          puts 'Mines initial play!'
          player.add_to_played(card)
          player.mark_hand_type_selectable('Treasure')
          update_attributes(played_card_id: card.id, value: 0, actions: actions - 1, action_phase: 'Trash', prompt: '<b>Played Mine!</b><br />Trash a treasure card from your hand. Gain a treasure card costing up to 3 treasure more and put it into your hand!')
        elsif action_phase == 'Trash' and card and action_hash # Trashing a treasure card
          puts 'Trash array = ' + action_hash['Trash'].to_s
          action_hash['Trash'].each do |card_id|
            trash_card = Card.find(card_id)
            trash_card.unmark_selectable
            player.add_to_trash(trash_card)
            update_attributes(value: trash_card.cost, action_phase: 'Gain')
          end
          update_attributes(prompt: '<b>Played Mine!</b><br />Trash a treasure card from your hand. Gain a treasure card costing up to 3 treasure more and put it into your hand!<br />Gain a treasure card in your hand worth at least ' + (value + 3).to_s + ' treasure!')
          player.unmark_all_hand_selectable
          return game.generate_selectable_supply_array('Treasure', 0, (value + 3), nil)
        elsif action_phase == 'Gain' and card and action_hash # Gaining a treasure card
          puts 'Gain array = ' + action_hash['Gain'].to_s
          action_hash['Gain'].each do |name|
            player.hand.cards.create!( cardmapping_id: Cardmapping.get( name ) )
            decrement_supply_count(name, 1)
          end
          update_attributes(prompt: '<b>Played Mine!</b><br />Trash a treasure card from your hand. Gain a treasure card costing up to 3 treasure more and put it into your hand!<br />Gain a treasure card in your hand worth at least ' + value.to_s + ' treasure!')
          reset_action_variables
        elsif action_phase == 'End' and card # ending card without gaining a card
          reset_action_variables
        end
      end
    end


end
