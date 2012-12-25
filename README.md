# X18n **[Beta]** [![Build Status](https://travis-ci.org/js-coder/x18n.png)](https://travis-ci.org/js-coder/x18n)

X18n is a JavaScript library that helps you to translate web apps that do a lot on the client side. It automatically detects the user language and sorts the available translations smartly. It has nice interpolation and pluralisation features that are compatible with Ruby's [r18n](https://github.com/ai/r18n) gem.

*X18n is currently in beta. The API might still change quite a bit.*

## Overview

*The translations are rougly adopted from r18n to show the compability.*

```js
x18n.register('en', {
  user: {
    welcome: 'Welcome %1',
    messages: 'You have %{n} messages.',
    logout: 'Logout',
    count: {
      1: 'There is 1 user online.',
      n: 'There are %1 users online.'
    }
  }
});

t('user.logout'); // 'Logout'
t('user.welcome', 'John'); // 'Welcome John'
t('user.messages', {n: 12}); // 'You have 12 messages.'

t('user.count').plural(1); // 'There is 1 user online.'
t('user.count').plural(2); // 'There are 2 users online.'
```

## Features

- [r18n](https://github.com/ai/r18n) compatible interpolation and pluralisation: All you need to do to use your r18n local dictionaries in x18n is to convert them from YAML to JSON and to register the objects.
- Auto detecting the user language.
- If a translation is not found in the favored language, x18n smartly uses the translation of similiar locales and saves the names of the missing translations in `x18n.missingTranslations`.
- Easy interpolation and pluralisation.
- An event system that enables you to easily re-render the UI when new translations are added or the language changes.

## Getting started

Wiki entries:

- [Getting started](https://github.com/js-coder/x18n/wiki/Getting-started)
- [Writing an adapter](https://github.com/js-coder/x18n/wiki/Writing-an-adapter)

I'm currently writing a jQuery adapter for x18n that will automatically update the UI when the dictionary or the language changes.