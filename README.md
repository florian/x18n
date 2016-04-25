# X18n [![Build Status](https://travis-ci.org/florian/x18n.png)](https://travis-ci.org/florian/x18n)

X18n is a JavaScript library that helps you to translate web apps that do a lot on the client side. It automatically detects the user language and sorts the available translations smartly. It has nice interpolation and pluralisation features that are also compatible with Ruby's [r18n](https://github.com/ai/r18n) gem.

If you use React it's super easy to translate your app using [react-x18n](https://github.com/marco-a/react-x18n).

## Overview

`npm install x18n` or just grab [x18n_build.js](https://raw.githubusercontent.com/florian/x18n/master/lib/x18n_build.js)

```js
x18n.register('en', {
  user: {
    greeting: 'Welcome %1',
    browser: 'You are using %{browser}.',
    logout: 'Logout',
    count: {
      1: 'There is 1 user online.',
      n: 'There are %1 users online.'
    }
  }
});

let t = x18n.t;
t('user.logout'); // 'Logout'
t('user.greeting', 'John'); // 'Welcome John'
t('user.browser', {browser: 'Chromium'}); // 'You are using Chromium.'

t('user.count').plural(1); // 'There is 1 user online.'
t('user.count').plural(2); // 'There are 2 users online.'

x18n.on(['lang:change', 'dict:change'], function () {
  // Update the UI
});
```

## Features

- Auto detects the user language.
- Straightforward interpolation and pluralisation.
- Super easy to use with React
- If you don't use React: An event system that enables you to easily re-render the UI when new translations are added or the language changes.
- If a translation is missing x18n will choose a translation from a similiar locale, saves missing translations in an accessible object and fires an event.
- [r18n](https://github.com/ai/r18n) compatible interpolation and pluralisation: All you need to do to use your r18n local dictionaries in x18n is to convert them from YAML to JSON and to register the objects.

## Wiki entries

- **[Getting started](https://github.com/florian/x18n/wiki/Getting-started)**
- [Dealing with missing translations](https://github.com/florian/x18n/wiki/Dealing-with-missing-translations)
- [Using a library that defines `window.t` together with x18n](https://github.com/florian/x18n/wiki/t.noConflict)

## Adapters

X18n has no opinion about views. Because of this the x18n core stays small. Adapters are x18n extensions that are responsible for updating the view when translations change.

The idea is that you are only responsible for registering translations, optionaly defining the user's language and adding data bindings to your HTML elements. The adapter will then update your HTML whenever the language changes or the dictionary is updated.

Currently there are adapters available for:

- [React](https://github.com/marco-a/react-x18n) (*recommended*)
- [Handlebars](https://github.com/SBoudrias/handlebars-x18n)
- [jQuery](https://github.com/florian/jQuery.x18n/)
