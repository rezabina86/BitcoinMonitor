## Bitcoin Watcher:

<p align="center">
  <img src="https://github.com/user-attachments/assets/8f80ca50-4601-439f-919d-e8fd53e0d38c" width=250>
  <img src="https://github.com/user-attachments/assets/80d1f75f-4ce4-42fd-98fb-db482145369c" width=250>
</p>

The app uses Combine to drive data flow and navigation. `AppTriggerFactory`
emits refresh triggers via timers and manual retries, which power the
`BTCPriceUseCase` and `BTCLatestTickUseCase`. These use cases fetch data from
repositories and emit `loading`, `error`, or `data` states as publishers.
Navigation is handled reactively using a `NavigationRouter` that updates a
`NavigationPath` in response to user actions.

![visual-readme](https://github.com/user-attachments/assets/d603a016-0c9e-40ef-a638-c3446e9ea365)


##API Layer:
It consistes of two API calls: 
- BTCLatestTickService that returns `BTCLatestTickAPIEntity` - Real time BTC price
- BTCPriceService returns `BTCPriceAPIEntity` - Historical data 

## Domain Layer:
- BTCLatestTickRepository: Converts the API Entity into `BTCLatestTickModel`
- BTCPriceRepository: Convertrs the API entity into `BTCPriceModel`

## Usecase and utilities:
- AppTriggerFactory: This component helps abstract trigger logic for features that need to respond to timers or refresh events from the app.

- AppRefreshUseCase: Manages manual refresh triggers for specific features in the app. This component provides a simple pub-sub mechanism using Combine to emit events when a refresh is initiated.

- TimerFactory: A lightweight wrapper around Combine’s Timer publisher to create interval-based signals for the app.

- NavigationRouter: A simple Combine-powered router for managing SwiftUI navigation in the app. It abstracts navigation logic into a reactive, testable component, making view transitions explicit and decoupled from the UI.

- BTCLatestTickUseCase: A reactive use case responsible for fetching and updating the latest BTC price in the app. It listens to triggers ( retries and timers) and emits `BTCLatestTickDataState`.

- BTCPriceUseCase: A reactive use case for fetching historical BTC prices in the app. This use case listens for refresh triggers and emits `BTCPriceDataState` 

