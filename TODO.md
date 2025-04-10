# TODOs

- [ ] Validate that only one element in a `view` has `focus_on_load` set to `true` (note: views are modals or home tabs)
- [ ] Alias certain block constants to have more human names (e.g., `DispatchActionConfig` -> `DispatchActionConfiguration`, `EmailTextInput` -> `EmailTextInput`, etc.)
- [ ] Try defining `as_json` in the base class to rely on `attributes` so most Block classes don't need to define their own
