RSpec::Matchers.define :have_card_type do |expected|
  match do |actual|
    #actual.is_action == expected
    #expect(actual.send("is_" + expected.to_s)).to eq(true)
    actual.send("is_" + expected.to_s) == true
  end

  failure_message do |actual|
    "expected card type to be " + expected.to_s
  end

  failure_message_when_negated do |actual|
    "expected card type to not be " + expected.to_s
  end

  description do
    "have correct card type"
  end
end

