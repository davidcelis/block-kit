# TODOs

- [ ] Add the `RichTextInput` element once all `RichText` blocks are implemented
- [ ] Validate that only one element in a `view` has `focus_on_load` set to `true` (note: views are modals or home tabs)
- [ ] Try defining `as_json` in the base class to rely on `attributes` so most Block classes don't need to define their own
- [ ] Alias certain block constants to have more human names:
  * `DispatchActionConfig` -> `DispatchActionConfiguration`
  * `EmailTextInput` -> `EmailTextInput`
  * `Overflow` -> `OverflowMenu`
