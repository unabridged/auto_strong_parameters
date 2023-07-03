# TODO list

- [ ] Add a hidden field with a string of all the fields used in the form builder
- [ ] Add a hidden field with a signature, take value toJson, sign and encrypt it
- [ ] For upgrades, we can suggest / allow a setting to try to catch the exception that SP raises and try to call auto_permit! and don't raise.
- [X] Look at how cookies are decrypted to decrypt server-side
- [X] Patch ActionController::Parameters to have auto_permit! and use the shape from the form

# Future enhancements
- Add option to enforce that selects or really any values are submitted are only within the choicies that were actually rendered in the form. This makes the most sense for foreign keys.
