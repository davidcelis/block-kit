require "spec_helper"

RSpec.shared_examples_for "a block that has a DSL method" do |attribute:, type:, actual_fields:, as: nil, expected_fields: nil, required_fields: [], mutually_exclusive_fields: [], yields: true|
  expected_fields ||= actual_fields

  describe "##{as || attribute}" do
    let(:attributes) { {} }
    let(:args) { {} }

    let(:result) { subject.public_send(as || attribute, **args) }

    unless as.present?
      it "returns the attribute when no args are passed" do
        expect { result }.not_to change { subject.public_send(attribute) }
        expect(result).to be_nil
      end
    end

    context "with optional args" do
      let(:args) { actual_fields }

      it "creates a value with the given attributes" do
        expect { result }.to change { subject.public_send(attribute) }.to instance_of(type)

        actual_fields.each do |key, value|
          field = subject.public_send(attribute)

          next if key == :emoji && !field.is_a?(BlockKit::Composition::PlainText)
          expect(field.public_send(key)).to eq(expected_fields[key])
        end
      end

      context "when unknown fields are passed" do
        let(:args) { super().merge(unknown_field_1: "unknown_value_1", unknown_field_2: "unknown_value_2") }

        it "raises an error if unknown fields are passed" do
          expect { result }.to raise_error(ArgumentError, "unknown keywords: :unknown_field_1, :unknown_field_2")
        end
      end

      if required_fields.any?
        it "raises an error if required fields are missing" do
          expected_message = "missing keyword#{"s" if required_fields.size > 1}: #{required_fields.map(&:inspect).join(", ")}"

          expect { subject.public_send(as || attribute, **args.except(*required_fields)) }.to raise_error(ArgumentError, expected_message)
        end
      end

      if mutually_exclusive_fields.any?
        context "when mutually exclusive fields are passed" do
          let(:args) do
            bad_fields = mutually_exclusive_fields.each_with_object({}) do |field, h|
              h[field] = "value"
            end
            super().merge(bad_fields)
          end

          it "raises an error" do
            expected_message = "mutually exclusive keywords: #{mutually_exclusive_fields.map(&:inspect).join(", ")}"
            expect { subject.public_send(as || attribute, **args) }.to raise_error(ArgumentError, expected_message)
          end
        end
      end

      if yields
        it "yields the value" do
          expect { |b| subject.public_send(as || attribute, **args, &b) }.to yield_with_args(type)
        end
      else
        it "does not yield" do
          expect { |b| subject.public_send(as || attribute, **args, &b) }.not_to yield_control
        end
      end
    end
  end
end
