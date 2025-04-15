require "spec_helper"

RSpec.shared_examples_for "a block that fixes validation errors" do |attribute:, **options|
  if (truncater = options[:truncate])
    it "automatically truncates the #{attribute} attribute" do
      invalid_value = truncater.fetch(:invalid_value) { "a" * (truncater[:maximum] + 1) }

      subject.assign_attributes(attribute => invalid_value)
      expect(subject).not_to be_valid

      subject.fix_validation_errors
      expect(subject).to be_valid
      expect(subject.attributes[attribute.to_s].length).to be <= truncater[:maximum]
    end
  end

  if (nullifier = options[:null_value])
    Array(nullifier[:valid_values]).each do |valid_value|
      it "does not change valid value #{valid_value.inspect}" do
        subject.assign_attributes(attribute => valid_value)

        expect { subject.fix_validation_errors }.not_to change { subject.attributes[attribute.to_s] }

        expect(subject.errors[attribute.to_s]).to be_empty
      end
    end

    Array(nullifier[:invalid_values]).each do |scenario|
      old_value, new_value, still_invalid = scenario.values_at(:before, :after, :still_invalid)

      it "replaces invalid value #{old_value.inspect}#{" with #{new_value.inspect}" unless still_invalid}" do
        subject.assign_attributes(attribute => old_value)
        expect(subject).not_to be_valid

        subject.fix_validation_errors

        expect(subject.attributes[attribute.to_s]).to eq(new_value)
        new_errors = subject.errors[attribute.to_s]
        if still_invalid
          expect(new_errors).not_to be_empty
        else
          expect(new_errors).to be_empty
        end
      end
    end
  end
end
