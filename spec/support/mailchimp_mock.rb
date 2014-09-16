RSpec.configure do |config|
  config.before do
    allow(Gibbon::API).to receive_message_chain(:lists, :segments).and_return(Hash.new("static" => []))
    allow(Gibbon::API).to receive_message_chain(:lists, :segment_add).and_return({"id" => 1})
    allow(Gibbon::API).to receive_message_chain(:lists, :segment_update).and_return({"complete" => true})
  end
end
