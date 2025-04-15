require "spec_helper"

RSpec.shared_examples_for "a block that fixes validation errors" do |attribute:, **options|
  if (truncater = options[:truncate])
    it "automatically truncates the #{attribute} attribute" do
      subject.assign_attributes(attribute => "a" * (truncater[:maximum] + 1))
      expect(subject).not_to be_valid

      subject.fix_validation_errors
      expect(subject).to be_valid
      expect(subject.public_send(attribute).text.length).to be <= truncater[:maximum]
    end
  end

  if (nullifier = options[:null_value])
    Array(nullifier[:valid_values]).each do |valid_value|
      it "does not change valid value #{valid_value.inspect}" do
        subject.assign_attributes(attribute => valid_value)
        expect(subject).to be_valid
        expect {
          subject.fix_validation_errors
        }.not_to change { subject.attributes[attribute.to_s] }
      end
    end

    Array(nullifier[:invalid_values]).each do |scenario|
      old_value, new_value = scenario.values_at(:before, :after)

      it "replaces invalid value #{old_value.inspect} with #{new_value.inspect}" do
        subject.assign_attributes(attribute => old_value)
        expect(subject).not_to be_valid

        subject.fix_validation_errors
        expect(subject).to be_valid
        expect(subject.attributes[attribute.to_s]).to eq(new_value)
      end
    end
  end
end
