# Changelog

# 2.0.0 / 2016-04-25

This is a major update with some incompatible changes:
- `window.t` is no longer available per default. It's easy to get back if you
  want it to: 'window.t = x18n.t'
- Dynamic data bindings were removed
- Upgrade to Observable v2.0.0 which makes the event system a lot more stable
  and predictable. However this also changed how `.off` works

Other changes:
- It's now suggested to use NPM. There's still a browser/AMD build available in
  the `lib` folder though
- Fixed some bugs

## 1.0.3 / 2013-03-12

Upgrade to observable v1.2.1 which fixes a bug in IE.

## 1.0.2 / 2013-02-16

Fix multiple implicit interpolations.

## 1.0.1 / 2013-01-25

Fix AMD. Remove CommonJS for now.

## 1.0.0 / 2012-12-22

Initial x18n release.
