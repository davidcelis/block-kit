# frozen_string_literal: true

require "spec_helper"

RSpec.describe BlockKit::Layout::Video, type: :model do
  subject(:video) { described_class.new(attributes) }
  let(:attributes) do
    {
      alt_text: "The story of a wealthy family who lost everything and the one son who had no choice but to keep them all together.",
      title: "Arrested Development",
      thumbnail_url: "https://i.ytimg.com/vi/Nl_Qyk9DSUw/hqdefault.jpg",
      video_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw"
    }
  end

  describe "#as_json" do
    it "serializes to JSON" do
      expect(video.as_json).to eq({
        type: described_class.type.to_s,
        alt_text: "The story of a wealthy family who lost everything and the one son who had no choice but to keep them all together.",
        title: {type: "plain_text", text: "Arrested Development"},
        thumbnail_url: "https://i.ytimg.com/vi/Nl_Qyk9DSUw/hqdefault.jpg",
        video_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw"
      })
    end

    context "with all attributes" do
      let(:attributes) do
        super().merge(
          author_name: "Mitchell Hurwitz",
          description: "It's one banana, Michael. What could it cost? Ten dollars?",
          provider_icon_url: "https://www.youtube.com/favicon.ico",
          provider_name: "YouTube",
          title_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw"
        )
      end

      it "serializes to JSON" do
        expect(video.as_json).to eq({
          type: described_class.type.to_s,
          alt_text: "The story of a wealthy family who lost everything and the one son who had no choice but to keep them all together.",
          author_name: "Mitchell Hurwitz",
          description: {type: "plain_text", text: "It's one banana, Michael. What could it cost? Ten dollars?"},
          provider_icon_url: "https://www.youtube.com/favicon.ico",
          provider_name: "YouTube",
          title: {type: "plain_text", text: "Arrested Development"},
          title_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw",
          thumbnail_url: "https://i.ytimg.com/vi/Nl_Qyk9DSUw/hqdefault.jpg",
          video_url: "https://www.youtube.com/watch?v=Nl_Qyk9DSUw"
        })
      end
    end
  end

  context "attributes" do
    it { is_expected.to have_attribute(:alt_text).with_type(:string) }
    it { is_expected.to have_attribute(:author_name).with_type(:string) }
    it { is_expected.to have_attribute(:provider_icon_url).with_type(:string) }
    it { is_expected.to have_attribute(:provider_name).with_type(:string) }
    it { is_expected.to have_attribute(:title_url).with_type(:string) }
    it { is_expected.to have_attribute(:thumbnail_url).with_type(:string) }
    it { is_expected.to have_attribute(:video_url).with_type(:string) }

    it_behaves_like "a block with a block_id"
    it_behaves_like "a block that has plain text attributes", :description, :title
    it_behaves_like "a block that has plain text emoji assignment", :description, :title
  end

  context "validations" do
    it { is_expected.to be_valid }

    it { is_expected.to validate_presence_of(:alt_text) }
    it { is_expected.to validate_length_of(:alt_text).is_at_most(2000) }

    it { is_expected.to validate_presence_of(:author_name).allow_nil }
    it { is_expected.to validate_length_of(:author_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:description).allow_nil }
    it { is_expected.to validate_length_of(:description).is_at_most(200) }

    it { is_expected.to validate_presence_of(:provider_icon_url).allow_nil }
    it { is_expected.to validate_length_of(:provider_icon_url).is_at_most(3000) }
    it { is_expected.to allow_value("https://example.com/").for(:provider_icon_url) }
    it { is_expected.to allow_value("http://example.com/").for(:provider_icon_url) }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:provider_icon_url).with_message("is not a valid URI") }
    it { is_expected.not_to allow_value("invalid_url").for(:provider_icon_url).with_message("is not a valid URI") }

    it { is_expected.to validate_presence_of(:provider_name).allow_nil }
    it { is_expected.to validate_length_of(:provider_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(200) }

    it { is_expected.to validate_presence_of(:title_url).allow_nil }
    it { is_expected.to validate_length_of(:title_url).is_at_most(3000) }
    it { is_expected.to allow_value("https://example.com/").for(:title_url) }
    it { is_expected.not_to allow_value("http://example.com/").for(:title_url).with_message("is not a valid HTTPS URI") }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:title_url).with_message("is not a valid HTTPS URI") }
    it { is_expected.not_to allow_value("invalid_url").for(:title_url).with_message("is not a valid HTTPS URI") }

    it { is_expected.to validate_presence_of(:thumbnail_url) }
    it { is_expected.to validate_length_of(:thumbnail_url).is_at_most(3000) }
    it { is_expected.to allow_value("https://example.com/").for(:thumbnail_url) }
    it { is_expected.to allow_value("http://example.com/").for(:thumbnail_url) }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:thumbnail_url).with_message("is not a valid URI") }
    it { is_expected.not_to allow_value("invalid_url").for(:thumbnail_url).with_message("is not a valid URI") }

    it { is_expected.to validate_presence_of(:video_url) }
    it { is_expected.to validate_length_of(:video_url).is_at_most(3000) }
    it { is_expected.to allow_value("https://example.com/").for(:video_url) }
    it { is_expected.not_to allow_value("http://example.com/").for(:video_url).with_message("is not a valid HTTPS URI") }
    it { is_expected.not_to allow_value("this://kind.of.url/").for(:video_url).with_message("is not a valid HTTPS URI") }
    it { is_expected.not_to allow_value("invalid_url").for(:video_url).with_message("is not a valid HTTPS URI") }
  end

  context "fixers" do
    it_behaves_like "a block that fixes validation errors", attribute: :alt_text, truncate: {maximum: described_class::MAX_ALT_TEXT_LENGTH}
    it_behaves_like "a block that fixes validation errors", attribute: :title, truncate: {maximum: described_class::MAX_TITLE_LENGTH}

    it_behaves_like "a block that fixes validation errors",
      attribute: :author_name,
      truncate: {maximum: described_class::MAX_AUTHOR_NAME_LENGTH},
      null_value: {
        valid_values: ["A name", nil],
        invalid_values: [{before: "", after: nil}]
      }

    it_behaves_like "a block that fixes validation errors",
      attribute: :description,
      truncate: {maximum: described_class::MAX_DESCRIPTION_LENGTH},
      null_value: {
        valid_values: ["A description", nil],
        invalid_values: [{before: "", after: nil}]
      }

    it_behaves_like "a block that fixes validation errors", attribute: :provider_icon_url, null_value: {
      valid_values: ["http://example.com/", "https://example.com/", nil],
      invalid_values: [
        {before: "this://kind.of.url/", after: "this://kind.of.url/", still_invalid: true},
        {before: "invalid_url", after: "invalid_url", still_invalid: true},
        {before: "", after: nil}
      ]
    }

    it_behaves_like "a block that fixes validation errors",
      attribute: :provider_name,
      truncate: {maximum: described_class::MAX_PROVIDER_NAME_LENGTH},
      null_value: {
        valid_values: ["YouTube", nil],
        invalid_values: [{before: "", after: nil}]
      }

    it_behaves_like "a block that fixes validation errors", attribute: :title_url, null_value: {
      valid_values: ["https://example.com/", nil],
      invalid_values: [
        {before: "http://example.com/", after: "http://example.com/", still_invalid: true},
        {before: "this://kind.of.url/", after: "this://kind.of.url/", still_invalid: true},
        {before: "invalid_url", after: "invalid_url", still_invalid: true},
        {before: "", after: nil}
      ]
    }

    it_behaves_like "a block that fixes validation errors", attribute: :thumbnail_url, null_value: {
      valid_values: ["https://example.com/", "http://example.com/"],
      invalid_values: [
        {before: "this://kind.of.url/", after: "this://kind.of.url/", still_invalid: true},
        {before: "invalid_url", after: "invalid_url", still_invalid: true},
        {before: "", after: "", still_invalid: true}
      ]
    }

    it_behaves_like "a block that fixes validation errors", attribute: :video_url, null_value: {
      valid_values: ["https://example.com/"],
      invalid_values: [
        {before: "http://example.com/", after: "http://example.com/", still_invalid: true},
        {before: "this://kind.of.url/", after: "this://kind.of.url/", still_invalid: true},
        {before: "invalid_url", after: "invalid_url", still_invalid: true},
        {before: "", after: "", still_invalid: true}
      ]
    }
  end
end
