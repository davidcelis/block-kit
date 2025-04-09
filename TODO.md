# TODOs

- [ ] Validate that only one element in a `view` has `focus_on_load` set to `true` (note: views are modals or home tabs)
- [ ] Alias certain block constants based on their type or common field name when used in JSON payloads (e.g., `DispatchActionConfiguration` -> `DispatchActionConfig`, `EmailInput` -> `EmailTextInput`, etc.)
- [ ] Most `BlockKit::Type` definitions have identical `cast` methods (accept an object of the same type, or a Hash that is sliced to the type's attributes). Refactor this to be generic. A base class could serve as both a way to generate a generic type for a Block and as a registry for each type as its created so that we don't create more than one instance per type.
