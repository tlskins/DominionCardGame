RSpec::Matchers.define :have_card_type do |expected|
  match do |actual|
    expect(actual.send("is_" + expected.to_s)).to eq(true)
    #(actual.is_action).eq true
  end

  failure_message do |actual|
    "expected card type to be is_" + expected.to_s + " = " + actual.send("is_" + expected.to_s).to_s
  end

  failure_message_when_negated do |actual|
    "exepcted card type to not be " + expected.to_s
  end

  description do
    "have correct card type"
  end
end

