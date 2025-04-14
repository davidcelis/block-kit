require "spec_helper"

RSpec.shared_examples_for "a block that has rich text elements" do
  it { is_expected.to have_attribute(:elements).with_type(:array).containing(*BlockKit::Layout::RichText::Elements.all.map { |t| :"block_kit_#{t.type}" }) }

  describe "#broadcast" do
    it "adds a broadcast element" do
      expect { subject.broadcast(range: "all") }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Broadcast)
      expect(subject.elements.last.range).to eq("all")
    end
  end

  describe "#channel" do
    it "adds a channel element" do
      expect { subject.channel(channel_id: "C12345678", styles: [:bold, :italic]) }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Channel)
      expect(subject.elements.last.channel_id).to eq("C12345678")
      expect(subject.elements.last.style).to be_a(BlockKit::Layout::RichText::Elements::MentionStyle)
      expect(subject.elements.last.style.bold).to be true
      expect(subject.elements.last.style.italic).to be true
    end
  end

  describe "#color" do
    it "adds a color element" do
      expect { subject.color(value: "#FF5733") }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Color)
      expect(subject.elements.last.value).to eq("#FF5733")
    end
  end

  describe "#date" do
    it "adds a date element" do
      expect { subject.date(timestamp: 1234567890, format: "{date_long_pretty}") }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Date)
      expect(subject.elements.last.timestamp).to eq(1234567890)
      expect(subject.elements.last.format).to eq("{date_long_pretty}")
    end

    context "with optional parameters" do
      it "adds a date element with optional parameters" do
        expect {
          subject.date(timestamp: 1234567890, format: "{date_long_pretty}", url: "http://example.com", fallback: "Fallback")
        }.to change { subject.elements.size }.by(1)

        expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Date)
        expect(subject.elements.last.url).to eq("http://example.com")
        expect(subject.elements.last.fallback).to eq("Fallback")
      end
    end
  end

  describe "#emoji" do
    it "adds an emoji element" do
      expect { subject.emoji(name: "smile", unicode: "1F600") }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Emoji)
      expect(subject.elements.last.name).to eq("smile")
      expect(subject.elements.last.unicode).to eq("1F600")
    end
  end

  describe "#link" do
    it "adds a link element" do
      expect { subject.link(url: "http://example.com", text: "Example", unsafe: true, styles: [:italic]) }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Link)
      expect(subject.elements.last.url).to eq("http://example.com")
      expect(subject.elements.last.text).to eq("Example")
      expect(subject.elements.last.unsafe).to be true
      expect(subject.elements.last.style).to be_a(BlockKit::Layout::RichText::Elements::TextStyle)
      expect(subject.elements.last.style.italic).to be true
    end
  end

  describe "#text" do
    it "adds a text element" do
      expect { subject.text(text: "Hello, world!", styles: [:bold]) }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Text)
      expect(subject.elements.last.text).to eq("Hello, world!")
      expect(subject.elements.last.style).to be_a(BlockKit::Layout::RichText::Elements::TextStyle)
      expect(subject.elements.last.style.bold).to be true
    end
  end

  describe "#usergroup" do
    it "adds a usergroup element" do
      expect { subject.usergroup(usergroup_id: "S12345678", styles: [:strike]) }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::Usergroup)
      expect(subject.elements.last.usergroup_id).to eq("S12345678")
      expect(subject.elements.last.style).to be_a(BlockKit::Layout::RichText::Elements::MentionStyle)
      expect(subject.elements.last.style.strike).to be true
    end
  end

  describe "#user" do
    it "adds a user element" do
      expect { subject.user(user_id: "S12345678", styles: [:strike]) }.to change { subject.elements.size }.by(1)

      expect(subject.elements.last).to be_a(BlockKit::Layout::RichText::Elements::User)
      expect(subject.elements.last.user_id).to eq("S12345678")
      expect(subject.elements.last.style).to be_a(BlockKit::Layout::RichText::Elements::MentionStyle)
      expect(subject.elements.last.style.strike).to be true
    end
  end

  describe "#as_json" do
    it "serializes the elements as JSON" do
      subject.elements = [
        BlockKit::Layout::RichText::Elements::Text.new(text: "Hello, "),
        BlockKit::Layout::RichText::Elements::User.new(user_id: "U12345678", style: {bold: true}),
        BlockKit::Layout::RichText::Elements::Text.new(text: "!")
      ]

      expect(subject.as_json).to include(
        elements: [
          {type: "text", text: "Hello, "},
          {type: "user", user_id: "U12345678", style: {bold: true}},
          {type: "text", text: "!"}
        ]
      )
    end
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:elements) }

    it "validates associated elements" do
      subject.elements = [BlockKit::Layout::RichText::Elements::Text.new]

      expect(subject).not_to be_valid
      expect(subject.errors["elements[0]"]).to include("is invalid: text can't be blank")
    end
  end
end
