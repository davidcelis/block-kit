require "spec_helper"

RSpec.shared_examples_for "a block that fixes validation errors" do |attribute:, **options|
  if (fixer = options[:truncate])
    it "automatically truncates the #{attribute} attribute" do
      subject.assign_attributes(attribute => "a" * (fixer[:maximum] + 1))
      expect(subject).not_to be_valid

      subject.fix_validation_errors
      expect(subject).to be_valid
      expect(subject.public_send(attribute).text.length).to be <= fixer[:maximum]
    end
  end

  if (null_value = options[:null_value])
    null_value[:invalid_values].each do |value|
      it "replaces invalid value #{value.inspect} with nil" do
        subject.assign_attributes(attribute => value)
        expect(subject).not_to be_valid

        subject.fix_validation_errors
        expect(subject).to be_valid
        expect(subject.attributes[attribute.to_s]).to be_nil
      end
    end

    null_value[:valid_values].each do |value|
      it "does not change valid value #{value.inspect}" do
        subject.assign_attributes(attribute => value)
        expect(subject).to be_valid

        expect {
          subject.fix_validation_errors
        }.not_to change { subject.attributes[attribute.to_s] }
      end
    end
  end
end
