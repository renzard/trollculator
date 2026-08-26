# Instagram UT

Instagram web client for Ubuntu Touch with UBports Push Notifications support.

## Build

Install Clickable, then run from this directory:

```bash
clickable build
```

Install the generated `.click` package on a connected Ubuntu Touch device with:

```bash
clickable install
```

## Push notifications

The app registers a UBports PushClient token. The token is printed in the app logs.

The included `pushexec` push helper forwards push payloads unchanged to the system notification service.

A backend is still required to decide when to send notifications and call the UBports push endpoint. The backend must know the user's push token and should store it securely.

This project does **not** scrape Instagram credentials or bypass Meta authentication. Instagram is loaded through its web interface.
