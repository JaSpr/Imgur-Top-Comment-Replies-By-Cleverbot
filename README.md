Simple Command Line ruby script to respond to comments on imgur using cleverbot responses.

=============================

Make sure to create a file in your $HOME directory named `.imgurrc`
You can rename this file, but you will need to change the constant in lib/imgur.rb

`.imgurrc` File contents:

```
---
:client_id: YOUR_APP_CLIENT_ID
:client_secret: YOUR_APP_CLIENT_SECRET
```

For this to work, you will need to register an Imgur application (https://api.imgur.com/oauth2/addclient), and then authorize it using an Imgur account.  After doing so, you will record the access token and refresh token in the `.imgurrc` file, using the following lines:

```
:account_username: THE_IMGUR_USER_NAME
:access_token: YOUR_ACCESS_TOKEN
:refresh_token: YOUR_REFRESH_TOKEN
```
