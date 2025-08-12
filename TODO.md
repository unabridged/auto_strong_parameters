# TODO list

- [X] Add a hidden field with a signed string of all the fields used in the form builder
- [X] Look at how cookies are decrypted to decrypt server-side
- [X] Patch ActionController::Parameters to have auto_permit! and use the shape from the form
- [X] Handle signature verification errors in a customizable way (error/log/silent)
- [ ] Exclude a param from the signed list (for example when displaying non-editable data in an input field) 
- [ ] Add a param to the signed list without an input present (e.g. fields added by javascript)
- [ ] Add ability to wrap arbitrary form helper methods (e.g. home-made form helpers)
- [ ] Add signed message to the list of filtered parameters in logs
- [ ] For upgrades, a setting to try to catch the exception that SP raises and try to call auto_permit! and don't raise
- [ ] Support SimpleForm / other form builders

# Future enhancements
- Add option to enforce that selects or really any values are submitted are only within the choicies that were actually rendered in the form. This makes the most sense for foreign keys.
- Ask for integration into Rails core
