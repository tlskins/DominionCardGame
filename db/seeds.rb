User.create!(name:  "testExample User",
             email: "testexample@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
	     admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "testexample-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end


Cardmapping.create!(name:  "Copper",
             text: "Copper",
             is_treasure: true,
	     treasure_amount: 1,
	     cost: 0)

Cardmapping.create!(name:  "Silver",
             text: "Silver",
             is_treasure: true,
             treasure_amount: 2,
             cost: 3)

Cardmapping.create!(name:  "Gold",
             text: "Gold",
             is_treasure: true,
             treasure_amount: 3,
             cost: 6)

Cardmapping.create!(name:  "Estate",
             text: "Estate",
             is_victory: true,
	     victory_points: 1,
	     cost: 2)

Cardmapping.create!(name:  "Duchy",
             text: "Duchy",
             is_victory: true,
             victory_points: 3,
             cost: 5)

Cardmapping.create!(name:  "Province",
             text: "Province",
             is_victory: true,
             victory_points: 6,
             cost: 8)

Cardmapping.create!(name:  "Curse",
             text: "Curse",
             is_victory: true,
             victory_points: -1,
             cost: 0)

Cardmapping.create!(name: "Village",
	     text: "+1 Card & +2 Actions",
	     is_action: true,
	     cost: 3)
             
Cardmapping.create!(name: "Witch",
             text: "+2 Cards & All other players gain a curse",
             is_action: true,
             is_attack: true,
             cost: 5)

Cardmapping.create!(name: "Chancellor",
             text: "+2 Treasure & you may discard your entire deck",
             is_action: true,
             cost: 3)

Cardmapping.create!(name: "Thief",
             text: "All other players reveal top 2 cards on their deck, you may gain one revealed treasure from each player, rest are discarded",
             is_action: true,
             is_attack: true,
             cost: 4)

Cardmapping.create!(name: "Throne Room",
             text: "Choose an action card in your hand and play it twice",
             is_action: true,
             cost: 4)

Cardmapping.create!(name: "Moat",
             text: "+2 Cards & you are unaffected by any attacks if you this card is in your hand",
             is_action: true,
             is_reaction: true,
             cost: 2)

Cardmapping.create!(name: "Cellar",
             text: "+1 Action & discard any number of cards, draw one card for each card discarded",
             is_action: true,
             cost: 2)

Cardmapping.create!(name: "Bureaucrat",
             text: "Gain a silver at the top of your deck. All other players put a victory card from their hand onto the top of their deck",
             is_action: true,
             is_attack: true,
             cost: 4)

Cardmapping.create!(name: "Spy",
             text: "+1 Card & +1 Action & all players reveal the top card on their deck and you choose to discard or put it back",
             is_action: true,
             is_attack: true,
             cost: 4)

Cardmapping.create!(name: "Chapel",
             text: "Trash up to 4 cards from your hand",
             is_action: true,
             cost: 2)

Cardmapping.create!(name: "Adventurer",
             text: "Reveal cards from your deck until you reveal 2 treasures, put those treasures in your hand and discard others",
             is_action: true,
             cost: 6)

Cardmapping.create!(name: "Library",
             text: "Draw until 7 cards in hand, you may choose to discard any drawn action cards",
             is_action: true,
             cost: 5)

Cardmapping.create!(name: "Moneylender",
             text: "Trash a copper from your hand then +3 Treasure",
             is_action: true,
             cost: 4)

Cardmapping.create!(name: "Feast",
             text: "Trash this card & gain a card costing up to 5 Treasure",
             is_action: true,
             cost: 4)

Cardmapping.create!(name: "Mine",
             text: "Trash a Treasure from your hand & gain a Treasure, costing up to 3 more, into your hand",
             is_action: true,
             cost: 5)

Cardmapping.create!(name: "Market",
             text: "+1 Card & +1 Action & +1 Buy & +1 Treasure",
             is_action: true,
             cost: 5)

Cardmapping.create!(name: "Woodcutter",
             text: "+1 Buy & +2 Treasure",
             is_action: true,
             cost: 3)

Cardmapping.create!(name: "Smithy",
             text: "+3 Cards",
             is_action: true,
             cost: 4)

Cardmapping.create!(name: "Laboratory",
             text: "+2 Cards + 1 Action",
             is_action: true,
             cost: 3)

Cardmapping.create!(name: "Festival",
             text: "+1 Buy & +2 Actions & +2 Treasure",
             is_action: true,
             cost: 5)

Cardmapping.create!(name: "Council Room",
             text: "+4 Cards & +1 Buy & all other players draw a card",
             is_action: true,
             cost: 5)

